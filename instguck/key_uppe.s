KOMISCH		EQU	1

**********************************************************************
* char key_upper(char c);
* Wandelt einen Buchstaben in den entsprechenden Grossbuchstaben
* unter Beachtung der Umlaute
**********************************************************************

		EXPORT key_upper

upper:	DC.B 'Ç', 'Ü', 'É', 'â', 'Ä', '╢', 'Å', 'Ç'
	DC.B 'ê', 'ë', 'è', 'ï', 'î', 'ì', 'Ä', 'Å'
	DC.B 'É', 'æ', 'Æ', 'ô', 'Ö', 'ò', 'û', 'ù'
	DC.B 'ÿ', 'Ö', 'Ü', '¢', '£', '¥', '₧', 'ƒ'
	DC.B 'á', 'í', 'ó', 'ú', 'Ñ', 'Ñ', 'ª', 'º'
	DC.B '¿', '⌐', '¬', '½', '¼', '¡', '«', '»'
	DC.B '╖', '╕', '▓', '▓', '╡'
	EVEN

key_upper:	cmp.b	#'a',D0
		blo.b	up_tabtest	;<'a'? Ja =>
		cmp.b	#'z',D0
		bhi.b	up_tabtest	;>'z'? Ja =>
		sub.b	#'a'-'A',D0	;Nach Grossbuchstabe
		rts

up_tabtest:	cmp.b	#$B4,D0		;Kleines 'oe'
		bgt.b	up_ijtest	;signed>'oe'? Ja => weg
		ext.w	D0
* - Durch den vorzeichenbehafteten Vergleich ist die untere Grenze
* automatisch 128 (das ist C cedille).
* - D0 ist durch das signed extend jetzt 256 zu klein gegenüber dem
* korrekten unsigned extend -> Offset=+256
* - Der Array beginnt aber erst beim Index 128, also wäre das
* korrekte D0 128 zu gross -> Offset=-128
* - Zusammen gibt das ein Offset von +128 auf upper.
		lea	upper+256-128(PC),A0
		move.b	0(A0,D0.w),D0	;Zeichen holen
		rts

up_ijtest:	cmp.b	#$C0,D0
		bne.b	up_ret		;='ij'? Nein =>
		addq.b	#1,D0		;'ij' -> 'IJ'
up_ret:		rts


**********************************************************************
* void key_init(int ap_id, bool menu_visible);
* Initialisiert einige Werte.
**********************************************************************

		EXPORT key_init

key_init:	move.w	D0,msg_out+2	;Absender = Empfänger
		move.w	D1,visible	;Menu-Flag

		moveq	#-1,D0
		move.l	D0,-(A7)	;Hole Tastaturparameter
		move.l	D0,-(A7)
		move.l	D0,-(A7)
		move.w	#16,-(A7)	;Keytbl()
		trap	#14
		lea	14(A7),A7
		
		move.l	D0,A0
		lea	unshift,A1
		move.l	(A0)+,(A1)+	;unshift-Pointer kopieren
		move.l	(A0)+,(A1)+	;shift
		move.l	(A0)+,(A1)+	;capslock
		rts			;Das war's!
		
**********************************************************************
* void key_right(const char *menu, const char *key);
* Testet, ob der String key ganz hinten in menu vorkommt (Leer-
* zeichen dürfen noch dahinter stehen). Direkt davor muss noch ein
* Leerzeichen stehen. Lokale Funktion.
**********************************************************************
* D0 = 0 (Vorbereitung für Rückgabewert)
* D1 = ' '
* D2 = Temp
* A0 = Arbeitsvariable menu
* A1 = Arbeitsvariable key
* A2 = Anfang von menu
* A3 = Anfang von key

		EXPORT	key_right	;Temporär

key_right:	move.l	A2,-(A7)	;Sichern
		move.l	A3,-(A7)
		move.l	A0,A2
		move.l	A1,A3
		moveq	#0,D0		;Vorbereitung für Return
		moveq	#' ',D1

ri_loop1:	tst.b	(A0)+		;menu
		bne.b	ri_loop1	;Suche Stringende
		subq.l	#1,A0		;Eins zu weit
ri_loop2:	cmpa.l	A0,A2		;Kein Nicht-Space im String?
		beq	ri_retFALSE
		cmp.b	-(A0),D1
		beq.b	ri_loop2
		
ri_loop3:	tst.b	(A1)+		;key
		bne.b	ri_loop3	;Suche Stringende
		subq.l	#2,A1		;Zum letzten gültigen Zeichen
		bra.b	ri_entry4

ri_loop4:	subq.l	#1,A0		;Beide eins zurück
		subq.l	#1,A1
ri_entry4:	cmpa.l	A0,A2
		beq	ri_retFALSE	;menu durch? Ja =>
		cmpa.l	A1,A3
		bhi	ri_finalcheck	;Ganzer key verglichen? Ja =>
		move.b	(A0),D2
		cmp.b	(A1),D2		;Zeichen dasselbe?
		beq	ri_loop4
ri_retFALSE:	bra     ri_ret

ri_finalcheck:	cmp.b	(A0),D1		;Steht davor ein Space?
		seq	D0
		neg.b	D0		;In C-Wahrheitswert wandeln
ri_ret:		move.l	(A7)+,A3
		move.l	(A7)+,A2
		rts


**********************************************************************
* void key_search(OBJECT *menu, char *key);
* Durchsucht den Menübaum menu nach dem String key. key muss in
* einem Dropdown-Eintrag ganz rechts stehen (siehe key_right).
* Als Menübaum ist auch NULL erlaubt. Dann passiert einfach nichts.
* Kann auch vom Hauptprogramm her aufgerufen werden, falls weitere
* Tasten behandelt werden sollen (z.B. key_search(menu, "HELP");)
* Sollte nur bei aktivem wind_update(BEG_UPDATE) aufgerufen werden.
**********************************************************************




**********************************************************************
* Parameter: Keycode (Highbyte: Scan, Lowbyte: ASCII)		     *
*	     Menübaum (kann auch NULL sein, wenn kein Menü durch-    *
*	     sucht werden soll.					     *
*								     *
* Rückgabe:							     *
* -1:	  "Unvorhergesehener Fall", sollte nicht passieren, ausser   *
*	  es wurde eine völlig neuartige Tastenkombination gedrückt. *
* 0:	  Nichts zu verarbeiten. Entweder wurde der Tastencode       *
*	  als Menüpunkt interpretiert, oder eine normale Taste mit   *
*	  ASCII-Code 0 wurde gedrückt. (Aufrufer muss nichts tun)    *
* 1..255: ASCII-Code						     *
* >=256:  Im Lowbyte ist der Scancode der Taste, zusätzlich sind     *
*	  noch (wenn nötig) die Werte KEY_CONTROL und/oder KEY_SHIFT *
*	  hineingeODERt. KEY_SPECIAL ist hier immer gesetzt	     *
*	  (das bringt den Wert über 255 hinaus).		     *
**********************************************************************
* D2 = Scancode
* D3 = ASCII
* A2 = text-Ptr
* A3 = menu

key_code:	movem.l	D2-D3/A2-A3,-(A7)
		subq.l	#6,A7		;Lokale Parameter
		move.l	A7,A2		;Textpointer init
		move.l	A0,A3		;menu
		moveq	#0,D3
		move.b	D0,D3		;ASCII
		move.w	D0,D2
		lsr.w	#8,D2		;Scan
		bne	co_scan		;Scan != 0? Ja =>
		move.w	D3,D0		;ASCII zurückgeben
		bra	co_ret
co_scan:
		IF	KOMISCH

		lea	co_komcode(PC),A1
		moveq	#2,D2		;Zähler
co_komloop:	move.l	(A1)+,D1
		cmp.w	D1,D0		;Gefunden?
		beq	co_komfound	;Ja =>
		swap	D1
		cmp.w	D1,D0
		dbeq	D2,co_komloop
		bne	co_special
co_komfound:	addq.l	#co_komtext-(co_komcode+4),A1
		bra	co_searchret	;A1 zeigt auf Text

co_komcode:	dc.w	$0300,$6E00
		dc.w	$071E,$6C1E
		dc.w	$351F,$4A1F
co_komtext:	dc.b	"^2",0,0
		dc.b	"^6",0,0
		dc.b	"^-",0,0
		
		ENDIF

co_special:	


co_ret:
co_searchret: nop

**********************************************************************
;Temporär
		IMPORT	unshift, shift, capslock, msg_out, visible

		END

		BSS

keytbl:
unshift:	ds.l	1		;Reihenfolge muss so bleiben!
shift:		ds.l	1
capslock:	ds.l	1

msg_out:	ds.w	8		;Messagebuffer (ausgenullt)

visible:	ds.w	1		;Flag

