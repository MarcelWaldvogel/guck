********************************************************************************
*                                                                              *
*                              G U C K   V 1 . 7                               *
*                                                                              *
********************************************************************************
*                                                                              *
*      Kleines, schnelles Programm zur Anzeige von Textfiles und Bildern.      *
*      Lässt sich einfach im Desktop installieren und kommt dann anstelle      *
*      der Alertbox "Anzeigen|Drucken|Abbruch".  Hier gibt es Funktionen,      *
*      die viele Anwender auf dem Atari ST bis jetzt vermisst haben.           *
*                                                                              *
********************************************************************************
*
* Änderungen (durchgeführt)
* =========================
                >PART 'History'
*
* - 05.07.1988 mw V0.7d IMG-Dekompression korrigiert.
* - 09.07.1988 mw V0.7d "bsr updateln" in "prtair" eingefügt.
* - 10.07.1988 mw V0.7d "prevline" und "nextline" verschnellert.
* - 10.07.1988 mw V0.8  Errordiffusion für LowRes-Bilder (.NEO und .PI1).
* - 22.09.1988 mw V0.8b Letzte Zeile korrekt/"small" entfernt/.PC2 eingefügt.
*                       Ctrl-C/Anderes Zeichen für ASCII-NUL.
* - 20.10.1988 mw V0.9  Druckerausgabe korrigiert (Absturz).
* - 27.10.1988 mw V0.9a Adressierungsart (PC) erweitert.
* - 01.11.1988 mw V0.9a Tastaturbuffer wird gelöscht. "NUL" als Default.
* - 02.11.1988 mw V0.9a Hilfetext korrigiert (PC-Tastaturbelegung)
* - 24.11.1988 mw V0.9b Ausdruck hört nicht mehr bei erstem "NUL" auf.
*                       Von GUCK angehängtes LF zählt nicht als Zeile.
* - 11.12.1988 mw V0.9b findend/print/bothprt: Unterdrücken nicht mehr
*                       letztes Zeichen, wenn dieses <NUL> ist.
*                       tst.x adress -> move.x adress(PC),Dn
* - 12.12.1988 mw V0.9c Metafiles eingebaut.
* - 13.12.1988 mw V0.9c Vergrösserungsfaktor (Metafiles) korrigiert.
* - 28.12.1988 mw V0.9d ditto, Anpassung an MadMac ((PC) entfernt), Platz
*                       reserviert für Editorpfad und .CFG-Pfad
* - 29.12.1988 mw V0.9d Vergrösserungsfaktor (hoffentlich endgültig)
*                       korrigiert. AES-Initialisierung (für graf_handle),
*                       da sonst Probleme mit GDOS. Flag gemedit eingebaut
* - 04.02.1989 mw V0.9d Metafiles laufen nicht auf "altem" TOS (V1.2)
*                       (laufen weiterhin nicht...)
* - 18.03.1989 mw V1.0  M&T-Version (kompatibel zum Desktop...)
* - 31.03.1989 mw V1.0  dBMAN-Kompatibilität (Ctrl-D[own], Ctrl-U[p])
* - 01.04.1989 mw V1.0b IMG bricht jetzt ab, falls Bildende erreicht in
*                       einer MultipleScanlines-Sequenz.
*                       IMG braucht jetzt keine Versionsnummer von 1 mehr.
*                       Tastenrepeat wird immer ganz hochgesetzt.
*                       WPflag/TABflag (wieder) eingeführt.
* - 08.04.1989 mw V1.0c DUMP-Funktion eingeführt.
* - 09.04.1989 mw V1.0c Daran herumgefeilt.
*                       Rechte Maustaste.
* - 12.04.1989 mw V1.0e "schöne" Speicherverwaltung
*                       Tastenkombinationen in einer Tabelle untergebracht.
*                       32000 Bytes + DUMPflag ==> Anzeige als Bild.
* - 12.04.1989 mw V1.1  Wieder einmal PC-relativiert (ca. 600 Bytes).
* - 17.04.1989 mw V1.1a nextline an WPflag/TABflag angepasst.
*                       tst.x PC-relativiert (zu move.x (PC),Dn)
*                       WP-Modus erweitert: Form Feed und PARAGRAF
* - 17.04.1989 mw V1.1b Autorepeat auf linker Maustaste.
* - 17.04.1989 mw V1.1c Links: <AB>, rechts: <AUF>, beide: <ESC>
* - 29.04.1989 mw V1.1c Vergleiche mit undefinierten Registern entfernt
* - 07.05.1989 mw V1.1d Shift-Home, Shift-^, Shift-v reaktiviert. (Lief ja?!?)
*                       Letzte Zeile wird im Textmodus auch dargestellt, wenn
*                       das allerletzte Byte ein NUL ist. (Lief ja?!?)
* - 18.06.1989 mw V1.1e Fehler beim Aufwärtsscrollen, wenn erstes Zeichen auf
*                       einer Bildschirmzeile, die nicht an einer Textzeilen-
*                       grenze beginnt, ein zu expandierender TAB ist.
*                       "prevline" und "nextline" wieder lesbar gemacht (V0.7d)
*                       Werbung eingebaut.
* - 19.06.1989 mw V1.1f Alles relativ zu A5
* - 28.06.1989 mw V1.1f Tastenrepeat wird nicht mehr verändert
*                       (Wenn man es schnell will, kann man ja die Maus nehmen)
*                       Ausdrucken im DUMP-Modus möglich
* - 16.06.1989 mw V1.1f Test auf Gelingen von Setblock entfernt (falls im Modus
*                       3,4,5 gestartet)
*                       Holen der Fontadresse modifiziert (für Fontwechsler)
*                       Maus wird ausgeschaltet
* - 16.06.1989 mw V1.2  Berechnung der Zeilenanzahl korrigiert
* - 22.11.1989 mw V1.3  Bildschirm invertieren
*                       Bildschirm als PI3 abspeichern
* - 29.11.1989 mw V1.3a Alles mögliche von (PC) nach (A5) gewandelt
* - 26.12.1989 mw V1.3b "Bombiger" Bug in der Errordiffusion entfernt (von 1.3a)
* - 15.03.1990 mw V1.3c Beim Speichern eines Bildes wird der volle Pfadname
*                       genommen und auf Existenz einer gleichnamigen Datei
*                       getestet. Erste Zeile kommt jetzt beim Aufwärtsscrollen
*                       auch korrekt, falls sie länger als 80 Zeichen ist.
* - 23.03.1990 mw V1.3d Invertieren auch im Textmodus (mit Anpassung der
*                       Hilfebildschirme)
* - 16.05.1990 mw V1.3e Degasbild speichern stuerzt nicht mehr ab, falls nur
*                       der Filename (ohne Pfad, also ohne Backslash) da ist.
* - 18.05.1990 mw V1.4  AES-Taskswitchs (evnt_timer(0)) eingebaut, damit
*                       Hintergrundprogramme (z.B. Download aus RUFUS) laufen
* - 22.05.1990 mw V1.4a Von Zahnweh geplagt auch noch die Tastaturabfrage ans
*                       AES angepasst (Hinweis von hjb). ^Q anstelle von ^C
* - 10.06.1990 mw V1.4b Versuch, auf mehr Bildschirmauflösungen zu laufen
* - 26.06.1990 mw V1.4b Logbase() anstelle von Physbase(), und an der
*                       Bildschirmunabhängigkeit weitergearbeitet.
*                       Fehler behoben, der seit V1.2 drin ist: Wenn man
*                       z.B. mit [Alt-E] ans Ende springt und von da her
*                       aufwärtsscrollt, kommt man zur Zeile 0 (d.h. alle
*                       Zeilennummern sind eins zu klein). Dies tritt bei allen
*                       normalen Textfiles ein (wo kein Ctrl-J eingefügt wird).
* - 01.07.1990 mw V1.4c Textmodus sollte nun in allen Auflösungen laufen
* - 07.07.1990 mw V1.4e Wählbare Tabulatorbreite (aus, 2, 4, 8)
*                       Fehler beim Drucken behoben. Nach dem Drucken wird
*                       der Tastaturpuffer gelöscht.
* - 08.07.1990 mw V1.4f Werbung entfernt
* - 14.07.1990 mw V1.4f Mit der [Ctrl-L] kann dem Drucker ein Formfeed
*                       gesendet werden
* - 14.07.1990 mw V1.4g Hilfebildschirm überarbeitet
* - 24.07.1990 mw V1.4g clreos überschreibt die letzte DUMP-Zeile nicht mehr
*                       (Korrektur in printabt). Hilfebildschirme.
* - 24.07.1990 mw V1.4h Bilder verallgemeinert.
* - 24.07.1990 mw V1.4j PC1 und PI2 sind neu dazugekommen.
*                       Bilder scrollen.
                ENDPART
                >PART 'Geschichte der Neuzeit'
* - 25.07.1990 mw V1.5  Hilfetexte anders angeordnet
* - 30.07.1990 mw V1.5a PAC korrigiert (move ,A1 & fehlendes BRA picpic)
* - 02.08.1990 mw V1.5a Hilfetexte korrigiert ("Weiter..." bei PIC)
*                       Backspace scrollt 20 Zeilen nach oben.
* - 07.08.1990 mw V1.5b v_cel_wr selbst berechnet, da er vom Matrix-
*                       Grossbildschirmtreiber nicht gesetzt wird.
* - 20.09.1990 mw V1.6  Calamus-Rastergraphik und -Page-Image darstellen.
*                       Beim Drucken automatischen Retry nach 20 Sekunden.
* - 16.10.1990 mw V1.6a Neuer XDumpmodus: Umschalten zwischen Dump und XDump
*                       mit "D". "^L": Warten auf Loslassen von Ctrl (sonst
*                       schaltet LaserBrain alle Interrupts aus, während die
*                       Tasten noch gedrückt sind -> Endlosrepeat)
*                       Dateilänge nicht mit Fsfirst(), sondern mit Fseek()
*                       (falls die Dateien erst beim Lesen dekomprimiert werden)
* - 17.10.1990 mw V1.6a Aktivieren des XDumpmodus' mit "X".
* - 18.10.1990 mw V1.6b Goto Line/Byte. Geht nicht mehr immer Home bei chTAB
*                       und chWP. Automatischen Retry wieder eingebaut (ist
*                       irgendwie weggefallen). Find String/Find Same.
* - 18.10.1990 mw V1.7  Editoraufruf.
* - 20.10.1990 mw V1.7  Zeichenwandlungstabelle beim Drucken.
*                       Mehrere Parameter möglich.
*
                ENDPART
*
* Änderungen (geplant)
* ====================
*
                >PART 'geplante Änderungen'
* (keine mehr)
*
                ENDPART
*
* Aktuelle ;-Sequenzen
* ====================
*
                >PART
* - ";!tst": Ersetzen war nicht möglich
* - ";bra":  "Bcc.W addr" könnte durch "Bcc.S BRAaddr" ersetzt werden.
* - ";A5 nicht möglich"
*
                ENDPART
*
********************************************************************************

                >PART 'Offsets in der Basepage'

                RSRESET

tpastart:       RS.L 1
tpaend:         RS.L 1
textstrt:       RS.L 1
textsize:       RS.L 1
datastrt:       RS.L 1
datasize:       RS.L 1
bssstrt:        RS.L 1
bsssize:        RS.L 1
dtaptr:         RS.L 1
pntprptr:       RS.L 1
resvd0:         RS.L 1
envptr:         RS.L 1
resvd1:         RS.B 7
curdrv:         RS.B 1
resvd3:         RS.L 18
cmdline:        RS.B 128
bpsize          EQU ^^RSCOUNT

                RSRESET

                ENDPART
                >PART 'ASCII-Werte'
CTRLC           EQU 3
CTRLD           EQU 4
CTRLE           EQU 5
CTRLF           EQU 6
CTRLG           EQU 7
CTRLH           EQU 8
CTRLL           EQU 12
CTRLP           EQU 16
CTRLQ           EQU 17
CTRLS           EQU 19
CTRLU           EQU 21

NUL             EQU 0
BEL             EQU 7
BS              EQU 8
TAB             EQU 9
LF              EQU 10
FF              EQU 12
CR              EQU 13
ESC             EQU 27
EOF             EQU 26

                ENDPART
                >PART 'Spezielle Ausgabezeichen'
ARUP            EQU 1
ARDN            EQU 2
CHECK           EQU 8                   ;Checkmark (Haken vor Menütiteln)

                ENDPART
                >PART 'Spezielle 1st-Word-Zeichen'
PARAGRAF        EQU 11                  ;Grösse des Abschnittes
WPTDU           EQU 25                  ;Bindestrich
WPSPCEXT        EQU 28                  ;Erweiterndes (Füll-)Leerzeichen
WPSPC           EQU 30                  ;Erweiterbares Leerzeichen
;                                        Von 28 bis 30 gehen die "Leerzeichen"
WPREM           EQU 31                  ;Zeichen für Spezialzeile (Lineal etc.)

                ENDPART
                >PART 'Funktionstastencodes'
ALTE            EQU $0812
HOME            EQU $47
CTRLHOME        EQU $0477
UP              EQU $48
CTRLUP          EQU $0448
DOWN            EQU $50
CTRLDOWN        EQU $0450
UNDO            EQU $61
HELP            EQU $62
ALT1            EQU $0878

                ENDPART
                >PART 'Bitnummern der Tasten'
LShift          EQU 24
RShift          EQU 25
Shift           EQU 25
Control         EQU 26
Alternat        EQU 27
CapsLock        EQU 28

                ENDPART
                >PART 'Bildkonstanten'

; Offsets im Header eines .IMG-Files:
VERSION         EQU 0
HDRLEN          EQU 2                   ;Länge des Headers in WORDS!
N_PLANES        EQU 4                   ;Anzahl Planes
PATLEN          EQU 6                   ;Anzahl Bytes im Pattern
SPIXW           EQU 8                   ;Source Pixel Width
SPIXH           EQU 10                  ;   "     "   Height
IWIDTH          EQU 12                  ;Breite (in Pixeln)
IHEIGHT         EQU 14                  ;Höhe (in Zeilen)

; Magics für STAD
stadmag1        EQU "pM85"
stadmag2        EQU "pM86"

; Grösse eines Screenformatbildes
DOOsize         EQU 32000

                ENDPART
                >PART 'Offsets (Line-A-Variablen)'
INTIN           EQU 8                   ;Adresse des Line-A-intins

; Negative Line-A-Variablen
CUR_FONT        EQU -$038A              ;Aktueller Zeichensatz
V_PLANES        EQU -$030E+8            ;Anzahl Planes: Line-A-INQ_TAB[4]
CURMSSTA        EQU -$015C              ;Current Mouse State (gedrückte Knöpfe, Byte)
CUR_X           EQU -$0158              ;Mauskoordinaten (X/Y)
CUR_Y           EQU -$0156
V_CEL_HT        EQU -$2E                ;Höhe eines Zeichens
V_CEL_MX        EQU -$2C                ;Maximale Cursorposition (X)
V_CEL_MY        EQU -$2A                ;Maximale Cursorposition (Y)
V_CEL_WR        EQU -$28                ;[V_CEL_HT]*[BYTES_LIN]
V_FNT_AD        EQU -$16                ;Zeiger auf die Zeichensatzdaten
BYTES_LIN       EQU -$02                ;Bytes pro Pixelzeile

                ENDPART
                >PART 'Druckerkonstanten'
CFG_MAXSIZE     EQU 5000                ;Maximale Grösse in Bytes
CFG_CONST       EQU 6                   ;Die 6 konstanten Bytes
CFG_MAGIC1      EQU 'GST-'
CFG_MAGIC2      EQU 'CFG:'

CFG_FORMFEED    EQU $1E                 ;Opcode für FF
CFG_INIT        EQU $20                 ;Initialisierungscode
CFG_EXIT        EQU $21                 ;Exitcode

                ENDPART
                >PART 'Diverses'
; Zeichenfaktor für Metafile
c_scal          EQU 9                   ;Mittels probieren ermittelt

; Minimalzeilenlänge für das automatische Aktivieren des DUMP-Modus
DLL             EQU 300                 ;Dump Line Length

; Nach wievielen Tastendrücken auf alle Fälle ein Taskswitch stattfindet
forceswitch     EQU 15                  ;Wie ein DBF-Zähler

PRN_TIMEOUT     EQU 10*200              ;10 Sekunden Druckertimeout
PRN_UNTIMEOUT   EQU 20*200              ;Nach 20 Sekunden Retry

GOTOlen         EQU 9                   ;Länge der Eingabezeile für GOTO
FINDlen         EQU 30                  ;Länge der Eingabezeile für FIND

magic           EQU 'Guk0'
                ENDPART
                >PART 'Systemadressen'
conterm         EQU $0484
_hz_200         EQU $04BA

; Hardwareadressen
rgb0            EQU $FFFF8240

                ENDPART
                >PART 'Speicherallozierung'
memfront        EQU 4                   ;Anzahl Bytes, die VOR dem Block freizuhalten sind
memback         EQU 16                  ;Anzahl Bytes dahinter

stacksiz        EQU 2048                ;2 KB Stack

                ENDPART

********************************************************************************

                OUTPUT 'C:\UTIL\GUCK.TTP','kromke1.doc namenlos.doc scansoft.doc test.doc'
                OPT F+                  ;Fastload
                DEFAULT 1

                >PART 'Programmheader'
;
; Erzeugt Programmheader wie folgt:
; bra.s start
; dc.b  "$Header: <prog>, <version>, <date> <time> mw$",0
; even
;
_start:         bra.s   start
                DC.B "$header: GUCK, V1.7, "
dummy           SET ^^DATE&$1F          ;Tag
                DC.B (dummy/10)+'0',(dummy%10)+'0','.'
dummy           SET (^^DATE>>5)&$0F     ;Monat
                DC.B (dummy/10)+'0',(dummy%10)+'0','.'
dummy           SET (^^DATE>>9)&$7F+80  ;Jahr
                IF dummy>=100
                DC.B '20'               ;Jahr 2000 etc. :-)
dummy           SET dummy-100
                ELSE
                DC.B '19'               ;Jahr 1900 etc.
                ENDC
                DC.B (dummy/10)+'0',(dummy%10)+'0',' '

dummy           SET (^^TIME>>11)&$1F    ;Stunde
                DC.B (dummy/10)+'0',(dummy%10)+'0',':'
dummy           SET (^^TIME>>5)&$3F     ;Minute
                DC.B (dummy/10)+'0',(dummy%10)+'0',':'
dummy           SET (^^TIME<<1)&$3F     ;Sekunde
                DC.B (dummy/10)+'0',(dummy%10)+'0'

                DC.B " mw$",0
                EVEN

                ENDPART
start:          >PART
                movea.l 4(A7),A6        ;Zeiger in Basepage
                lea     stack(PC),A7    ;A5 unmöglich

                movea.l textsize(A6),A0 ;Programmlänge berechnen
                adda.l  datasize(A6),A0
                move.l  bsssize(A6),D3
                adda.l  D3,A0
                lea     bpsize(A0),A0   ;+ Basepage

                move.l  A0,-(A7)        ;Neue Länge
                move.l  A6,-(A7)        ;Anfang
                clr.w   -(A7)           ;Dummy
                move.w  #$4A,-(A7)      ;Mshrink
                trap    #1
                lea     12(A7),A7

                BASE A5,databss         ************************************************
                lea     databss(PC),A5  ****************************************

neustart:       move.l  A6,basepage(A5)
                bsr     getinit
                bsr     gem_init

                pea     initcons(PC)
                move.w  #38,-(A7)
                trap    #14
                addq.l  #6,A7

                bsr     scanclp         ;A6 zeigt auf Basepage

                bsr     readfile
                bsr     initflag

                bsr     chktype         ;Bild oder Text?
                tst.l   pictype(A5)
                bne     disppic         ;Zeige Bild an

                ENDPART

********************************************************************************
*                            Anzeige von Text                                  *
********************************************************************************

disptext:       >PART
                sf      redrawit(A5)
                bsr     findend
                tst.b   beenhere(A5)    ;Schon einmal etwas dargestellt?
                bne.s   top             ;Ja, dann auf keinen Fall Bildformat erzwingen

                tst.b   DUMPflag(A5)    ;DUMPflag gesetzt?
                beq.s   top
                cmpi.l  #DOOsize,d_len(A5) ;32000 Bytes?
                beq     disppic         ;Ja, dann wahrscheinlich ein Bild!

                ENDPART
top:            >PART
                st      beenhere(A5)
                moveq   #1,D0
                move.l  D0,nowline(A5)
                move.l  filstrt(A5),filpos1(A5)
redraw2:        bsr     makeinfo        ;Einsprungpunkt von redraw (viel weiter unten)
                bsr     gototop
                movea.l filpos1(A5),A4
                bsr     print
                move.l  A4,filpos2(A5)
                bsr     clreos
                tst.b   clearbuf(A5)    ;Tastatur zuerst löschen?
                beq.s   top3            ;Nein, normal
                bsr     clearkeybuf     ;Tastaturbuffer löschen
top3:           sf      clearbuf(A5)
                sf      redrawit(A5)
                ENDPART
mainloop:       >PART
                move.w  rptcount(A5),D0 ;Letzten Befehl wiederholen?
                beq.s   ml1             ;Nein, hole Taste
                subq.w  #1,D0           ;Dekrementieren
                move.w  D0,rptcount(A5)
                movea.l rptadr(A5),A0   ;Zeiger holen
                jmp     (A0)            ;Und springen

ml1:            bsr     getukey
                tst.w   D0              ;Funktionstaste? (kein ADE)
                beq.s   funckey
                btst    #Shift,D0
                beq.s   ml2
                lea     keytabs(A5),A0  ;Spezialtasten mit Shift
                lea     jmptabs(A5),A1
                bsr.s   keylist         ;Kehrt nur zurück, falls nichts gematcht

ml2:            lea     keytab(A5),A0   ;Ohne Shift oder keine der SpezTasten
                lea     jmptab(A5),A1
                bsr.s   keylist
                bra.s   mainloop        ;War überhaupt nichts

                ENDPART
funckey:        >PART
                swap    D0
                andi.w  #$0CFF,D0       ;Nur ALT und CTRL lassen
                lea     keytabf(A5),A0
                lea     jmptabf(A5),A1
                bsr.s   fkeylist
                bra.s   mainloop

                ENDPART
keylist:        >PART
* Eingabewerte  A0.L: ?keytab?
*               A1.L: ?jmptab?
*               D0.B: Taste
                move.b  (A0)+,D1
                beq.s   keyret
                move.w  (A1)+,D2
                cmp.b   D0,D1
                bne.s   keylist
                addq.l  #4,A7           ;Rücksprungadresse entfernen
                jmp     keylist(PC,D2.w)
keyret:         rts

                ENDPART
fkeylist:       >PART
* Dasselbe, aber mit D0.W als Taste
                move.w  (A0)+,D1
                beq.s   keyret
                move.w  (A1)+,D2
                cmp.w   D0,D1
                bne.s   fkeylist
                addq.l  #4,A7           ;Rücksprungadresse entfernen
                jmp     fkeylist(PC,D2.w)

                ENDPART
                >PART 'up/down20'
up20:           lea     oneup(PC),A0
                bra.s   any20
down20:         lea     onedown(PC),A0
any20:          move.l  A0,rptadr(A5)
                move.w  #19,rptcount(A5) ;20 mal scrollen
                clr.w   switchcnt       ;Danach auf alle Fälle switchen
                jmp     (A0)
                ENDPART
onedown:        >PART
                movea.l filpos2(A5),A4  ;Schon am Ende der Datei?
                cmpa.l  filend(A5),A4
                bcc.s   bramloop
                bsr     scrollup
                bsr     gotobot
                movea.l filpos2(A5),A4
                bsr     print
                move.l  A4,filpos2(A5)
                movea.l filpos1(A5),A4
                bsr     nextline
                move.l  A4,filpos1(A5)

                tst.b   DUMPflag(A5)
                bne.s   onedupdt

                cmpi.b  #LF,-(A4)       ;Eine (echte) Zeile nach unten?
                bne.s   bramloop
                addq.l  #1,nowline(A5)

onedupdt:       bsr     updateln        ;Update Line Number
bramloop:       bra     mainloop

                ENDPART
pagedown:       >PART
                movea.l filend(A5),A3
                movea.l filpos2(A5),A4
                movea.l A4,A6           ;Voraussichtlich neuer Anfang
                cmpa.l  A3,A4           ;Schon am Ende?
                bcc.s   bramloop
                moveq   #-2,D4          ;Siehe pageup
                add.w   v_cel_h(A5),D4  ;Bildhöhe - 2
paged1:         bsr     nextline
                cmpa.l  A3,A4
                dbcc    D4,paged1
                bcs.s   paged5          ;Muss noch eine Zeile abgezählt werden?
                subq.w  #1,D4           ;DBCC verschluckt eine, wenn Seitenende
paged5:         move.l  A4,filpos2(A5)
                neg.w   D4              ;Berechne die Zahl der nach unten
                add.w   v_cel_h(A5),D4  ;gegangenen Zeilen -1(DBRA)
                subq.w  #3,D4
                movea.l filpos1(A5),A4
paged3:         bsr     nextline
                cmpi.b  #LF,-1(A4)
                bne.s   paged4
                addq.l  #1,nowline(A5)
paged4:         dbra    D4,paged3
                movea.l A4,A6           ;Der Anfang stimmte noch nicht
                move.l  A6,filpos1(A5)
                bsr     gototop
                movea.l A6,A4
                bsr     print
                bsr     updateln        ;Zeilennummer nachführen
                bra     mainloop

                ENDPART

********************************************************************************

oneup:          >PART
                movea.l filpos1(A5),A4  ;Geht nicht mehr nach oben...
                movea.l A4,A6           ;Sichern
                cmpa.l  filstrt(A5),A4
                bls     mainloop
                movea.l filpos2(A5),A4
                bsr     prevline
                move.l  A4,filpos2

                movea.l filpos1(A5),A4
                bsr     prevline
                move.l  A4,filpos1(A5)
                bsr     scrolldn
                movea.l filpos1(A5),A4
                move.w  maxpos(A5),maxsave(A5)
                move.b  #2,maxlin(A5)   ;Nur 2. Zeile beschreiben
                bsr     print
                move.w  maxsave(A5),maxpos(A5)

                tst.b   DUMPflag(A5)
                bne.s   oneuupdt

                cmpi.b  #LF,-1(A6)      ;Zeilennummer nachführen
                bne     mainloop
                subq.l  #1,nowline(A5)

oneuupdt:       bsr     updateln
                bsr.s   gototop
                bra     mainloop

                ENDPART
pageup:         >PART
                moveq   #-2,D4          ;Bildhöhe - 2
                add.w   v_cel_h(A5),D4  ;Ohne INFO(-1), DBRA(-1)
                movea.l filpos1(A5),A4
                movea.l filstrt(A5),A3
                cmpa.l  A3,A4
                bls     mainloop
pageupL:        cmpi.b  #LF,-1(A4)
                bne.s   pageupP         ;No physical NewLine encountered
                subq.l  #1,nowline(A5)
pageupP:        bsr     prevline
                cmpa.l  A3,A4
                dbls    D4,pageupL
                move.l  A4,filpos1(A5)
                moveq   #-2,D4
                add.w   v_cel_h(A5),D4  ;filpos2 neu berechnen
                movea.l filpos1(A5),A4  ;angekommen ==> Ende neu berechnen
pageupD:        bsr     nextline
                dbra    D4,pageupD
                move.l  A4,filpos2(A5)
                bra     redraw

                IF 0
                bsr.s   gototop
                movea.l filpos1(A5),A4
                bsr     print
                bsr     updateln
                bra     mainloop
                ENDC
                ENDPART
bottom:         >PART
                move.l  filend(A5),filpos1(A5)
                move.l  numlines(A5),D0
                addq.l  #1,D0
                move.l  D0,nowline(A5)
                bra.s   pageup

                ENDPART
gototop:        >PART
                move.w  #$0100,crspos(A5) ;Zeile 1, Spalte 0
                movea.l screen(A5),A0
                adda.w  v_cel_wr(A5),A0
                move.l  A0,cursor(A5)
                rts

                ENDPART
gotobot:        >PART
                move.w  v_cel_h_1(A5),D0
                move.w  D0,D1           ;Zwischenspeichern
                lsl.w   #8,D0           ;Highbyte = Zeile, Spalte = 0
                move.w  D0,crspos(A5)
                movea.l screen(A5),A0
                mulu    v_cel_wr(A5),D1 ;Auch Cursoradresse berechnen
                adda.l  D1,A0
                move.l  A0,cursor(A5)
                rts

                ENDPART

* DUMP läuft nur korrekt, falls Datei kleiner als 5MBytes ist!
chXDUMP:        >PART                   ;Fällt durch!
                neg.b   DUMPflag(A5)    ;NOP, falls DUMP nicht aktiv (Flag=0)
                bne.s   braredraw       ;bra  Wechselt sonst zwischen (X)Dump
;Fällt durch!
                ENDPART
chDUMP:         >PART
                bsr     clrEOFLF        ;Auf alle Fälle löschen
                tst.b   DUMPflag(A5)
                bne.s   chDclr
                move.b  #1,DUMPflag(A5)
                sf      WPflag(A5)
                bra     top             ;bra
chDclr:         sf      DUMPflag(A5)
                bsr     setEOFLF
                bra     top             ;bra

                ENDPART
chWP:           >PART
                move.l  nowline(A5),D0  ;Zur aktuellen Zeile
                not.b   WPflag(A5)
                beq     gotolineD0      ;WP ausgeschaltet? Ja ->

                tst.b   DUMPflag(A5)    ;(X)DUMP gesetzt?
                beq.s   chWPflags       ;Nein, darf auf aktueller Zeile bleiben
                sf      DUMPflag(A5)    ;(X)DUMP ausschalten
                moveq   #0,D0           ;Und zum Textanfang (Zeile 0=Zeile 1)
chWPflags:      bsr     clrEOFLF        ;Zuerst sicherheitshalber löschen
                bsr     setEOFLF        ;Und dann je nach Text wieder setzen
bratop:         bra     gotolineD0      ;[clr,set]EOFLF ändern D0 nicht!

                ENDPART
chTAB:          >PART
                moveq   #0,D0
                move.b  TABflag(A5),D0
                move.b  TABflagtab(A5,D0.w),D0
                move.b  D0,TABflag(A5)
                neg.b   D0              ;Flag -> Mask
                move.b  D0,TABmask(A5)
                move.l  nowline(A5),D0  ;Wieder die aktuelle Zeile anzeigen
                bra     gotolineD0      ;oder so nah wie möglich daran
                ENDPART

chNUL:          not.b   NULflag(A5)
braredraw:      bra     redraw

********************************************************************************

saveflag:       >PART
                lea     flag(A5),A0     ;Source
                moveq   #fsavarea-flag-1,D0 ;Länge für DBRA
                lea     1(A0,D0.l),A1   ;Destination
sfl:            move.b  (A0),(A1)+      ;Sichern ...
                clr.b   (A0)+           ;... und löschen
                dbra    D0,sfl

initflag:       moveq   #8,D0
                move.b  D0,TABflag(A5)  ;Defaultwerte einsetzen
                neg.b   D0              ;Flags -> Maske
                move.b  D0,TABmask(A5)
                rts

                ENDPART
restflag:       >PART
                lea     flag(A5),A0     ;Destination
                moveq   #fsavarea-flag-1,D0 ;Länge für DBRA
                lea     1(A0,D0.l),A1   ;Source (1 wegen Korrektur von oben)
rfl:            move.b  (A1)+,(A0)+
                dbra    D0,rfl
prtstret:       rts

                ENDPART
helptitl:       >PART
                move.l  screen(A5),cursor(A5) ;ganz HOME
                clr.w   crspos(A5)
                bsr.s   prtstars
                lea     gucktitl(A5),A4
                bsr     print
prtstars:       lea     stern(A5),A4    ;Drucke einen Stern
                bsr     print           ;Bis das Zeilenende erreicht ist
                move.b  crscol(A5),D0   ;Über das Bildschirmende hinaus?
                beq.s   prtstret        ;(dann bleibt die Spalte auf 0)
                cmp.b   maxcol(A5),D0
                bne.s   prtstars
                bra     prtLF           ;Und dann einen Zeilenvorschub

                ENDPART
helpbot:        >PART
                bsr     print
                bsr.s   prtstars
                bsr     clreos
                bra     getukey

                ENDPART
helpchk1:       >PART
                moveq   #" ",D0         ;Variablen initialisieren
                moveq   #CHECK,D1       ;Haken
helpchk:        tst.b   (A0)+           ;Setzt/löscht Haken je nach Flag
                beq.s   hcspc
hcchk:          move.b  D1,(A1)
                rts

helpchkx:       tst.b   (A0)
                bmi.s   hcchk
hcspc:          move.b  D0,(A1)
                rts

                ENDPART
help:           >PART
                lea     NULflag(A5),A0
                lea     ht0+1(A5),A1    ;Immer Offset von 1, da Label 1 zu früh
                bsr.s   helpchk1        ;NULflag?
                lea     htW+1(A5),A1
                bsr.s   helpchk         ;WPflag?
                lea     htX+1(A5),A1
                bsr.s   helpchkx        ;DUMPflag (XDUMP-Modus)?
                lea     htD+1(A5),A1
                bsr.s   helpchk         ;DUMPflag?
                lea     htIt+1(A5),A1
                bsr.s   helpchk         ;INVERTflag?

                moveq   #0,D0           ;Tabulatorgrösse ausgeben
                move.b  TABflag(A5),D0
                move.b  TABcnttab(A5,D0.w),htT-3(A5)

                bsr     saveflag        ;Alle Attribute sichern und ausschalten
                bsr     helptitl
                lea     hilftxt1(A5),A4
                bsr     print
                lea     hilfweiter(A5),A4
                bsr.s   helpbot
                swap    D0
                cmp.w   #UNDO,D0
                beq.s   helpend

                bsr     helptitl
                lea     hilftxt2(A5),A4
                bsr.s   helpbot

helpend:        bsr     restflag        ;zurückholen

redraw:         st      redrawit(A5)
                bra     redraw2

                ENDPART
                >PART 'Speicher freigeben'
xmfree:         move.l  (A0),D3         ;Hole Adresse
                clr.l   (A0)            ;Markiere Speicherbereich als frei
mfree:          tst.l   D3              ;NULL?
                beq.s   mfreeret        ;Ja, zurück
                move.l  D3,-(A7)
                move.w  #$49,-(A7)
                trap    #1
                addq.l  #6,A7
mfreeret:       rts
                ENDPART
term:           >PART
                moveq   #0,D7           ;Aufhören
                bra.s   term2

next:           moveq   #-1,D7          ;Nächste Datei nehmen

term2:          bsr     gem_exit

                lea     memfil(A5),A0   ;Reservierten Speicher freigeben
                bsr.s   xmfree
                lea     picmem1(A5),A0
                bsr.s   xmfree
                lea     picmem2(A5),A0
                bsr.s   xmfree
                lea     cfgmem(A5),A0
                bsr.s   xmfree

                pea     exitcons(A5)
                move.w  #38,-(A7)
                trap    #14
                addq.l  #6,A7

                tst.b   D7              ;Noch eine Datei?
                bne.s   termnext

                clr.w   -(A7)
                trap    #1

termnext:       movea.l basepage(A5),A6 ;Vorbereitung für neustart

                lea     fnamebuf(A5),A1
                movea.l A1,A3
tn_findend:     tst.b   (A3)+           ;Suche Stringende
                bne.s   tn_findend
                suba.l  A1,A3           ;Stringlänge

                movea.l A5,A0           ;A5=Beginn des BSS-Segmentes
                move.w  #(stackbottom-databss)/4,D0
;stackbottom-databss ist die Länge des BSS-Segmentes (ohne Stack)
;-1 fehlt (unterstes Stackwort/-long wird gelöscht), damit das letzte Wort
;vor dem Stack sicher auch gelöscht wird (falls BSS-Länge durch 4 nicht aufgeht)
                moveq   #0,D1
tn_clear:       move.l  D1,(A0)+
                dbra    D0,tn_clear

                lea     cmdline+1(A6),A0 ;Zeiger auf die Kommandozeile
                adda.l  A0,A3
                subq.w  #1,A3
tn_strcpy:      move.b  (A3)+,(A0)+     ;Allfällige weitere Namen kopieren
                bne.s   tn_strcpy
                bra     neustart        ;und mit diesen weiterarbeiten

                ENDPART

exectext:       >PART
                lea     textedit(A5),A0
                tst.b   (A0)            ;Dateiname leer?
                bne.s   shel_write      ;Nein, dieses Programm starten
                lea     errnoeditor(A5),A4
                bsr     messagek
                bra     mainloop

                ENDPART
execgraf:       >PART
                lea     grafedit(A5),A0
                tst.b   (A0)            ;Dateiname leer?
                bne.s   shel_write      ;Nein, dieses Programm starten
                lea     errnoeditor(A5),A4
                bsr     messagek
                bra     picmloop

                ENDPART
shel_write:     >PART
                moveq   #1,D1
                lea     contrl(A5),A1
                move.w  #121,(A1)+      ;shel_write
                move.w  #3,(A1)+        ;#intin
                move.w  D1,(A1)+        ;#intin
                move.w  #2,(A1)+        ;#addrin
                clr.w   (A1)            ;#addrout
                lea     intin(A5),A1
                move.w  D1,(A1)+        ;neues Programm laden
                move.w  D1,(A1)+        ;Immer eine GEM-Applikation
                move.w  D1,(A1)         ;erst nach dem Ende dieses Programmes
                lea     addrin(A5),A1
                move.l  A0,(A1)+        ;Dateiname

                movea.l fnameadr(A5),A0
                movea.l A0,A2           ;Sichern
sw_loop:        tst.b   (A0)+           ;Stringlänge bestimmen
                bne.s   sw_loop
                suba.l  A2,A0           ;Länge+1 in A0
                moveq   #-1,D0
                add.l   A0,D0           ;Länge in D0 (für Byteoperation
                move.b  D0,-(A2)        ;Vor den Dateinamen setzen
                move.l  A2,(A1)         ;Kommandozeile
                bsr     aes
                bra     term

                ENDPART

********************************************************************************
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
********************************************************************************

; Beenden des 1. Parameters mit NUL und Wandlung in Grossbuchstaben
scanclp:        >PART
                lea     cmdline+1(A6),A0
                lea     fnamebuf(A5),A1
                movea.l A1,A4

scanclpcopy:    move.b  (A0)+,(A1)+     ;Arbeitskopie der Kommandozeile
                bne.s   scanclpcopy

                moveq   #" ",D1
scanclp0:       cmp.b   (A4)+,D1        ;Überspringe Leerzeichen
                beq.s   scanclp0
                subq.l  #1,A4           ;Eins zu weit
                move.l  A4,fnameadr(A5) ;Speichere diese Adresse
                move.b  (A4),D0
                bsr     upcase
                move.b  D0,(A4)+
                cmp.b   D0,D1           ;1. Zeichen schon Terminator?
                bcc.s   nofile          ;Ja ==> keine Datei angegeben
scanclp1:       move.b  (A4),D0
                bsr     upcase
                move.b  D0,(A4)+
                cmp.b   D0,D1
                bcs.s   scanclp1
                clr.b   -(A4)
                rts

nofile:         lea     errnofil(A5),A4 ;Meldung ausgeben
                bra     harderr         ;Programm beenden

                ENDPART
readfile:       >PART
                pea     dta(A5)
                move.w  #$1A,-(A7)      ;Fsetdta
                trap    #1
                addq.l  #6,A7

                move.w  #$27,-(A7)      ;Alle Arten von DATEIEN
                move.l  fnameadr(A5),-(A7)
                move.w  #$4E,-(A7)      ;Fsfirst
                trap    #1
                addq.l  #8,A7
                tst.l   D0
                bmi     notfound

                movea.l fnameadr(A5),A0 ;Suche nach Dateiname
                cmpi.b  #":",1(A0)      ;Laufwerksangabe?
                bne.s   rfback
                addq.l  #2,A0           ;Ja, überspringen!
rfback:         movea.l A0,A1
rfnext:         move.b  (A0)+,D0        ;Namensende?
                beq.s   rfname
                cmp.b   #"\",D0         ;Backslash?
                bne.s   rfnext
                bra.s   rfback

rfname:         lea     d_name(A5),A0   ;Und evt. Kurzname ersetzen durch Vollname
rfcopy:         move.b  (A0)+,(A1)+
                bne.s   rfcopy


                clr.w   -(A7)           ;Datei nur lesen
                move.l  fnameadr(A5),-(A7) ;Adresse des Dateinamens
                move.w  #$3D,-(A7)      ;Fopen
                trap    #1
                addq.l  #8,A7
                move.l  D0,D3           ;Handle für CLOSE speichern
                bmi.s   notopen

                move.w  #2,-(A7)        ;Seekmode: FromEnd
                move.w  D3,-(A7)        ;Handle
                clr.l   -(A7)           ;0 Bytes vom Ende weg (=ganz ans Ende)
                move.w  #$42,-(A7)      ;Fseek()
                trap    #1
                lea     10(A7),A7
                move.l  D0,d_len(A5)    ;Dies ist die wirkliche Länge
                bmi.s   noread          ;Negativ? Schlimmer Fehler!

                clr.w   -(A7)           ;Seekmode: FromStart
                move.w  D3,-(A7)        ;Handle
                clr.l   -(A7)           ;Ganz an den Anfang
                move.w  #$42,-(A7)
                trap    #1
                lea     10(A7),A7

                moveq   #memfront+memback,D0 ;Sicherheitsspeicher
                add.l   d_len(A5),D0
                and.w   #$FFFC,D0       ;Unterste 2 Bits dieses LONG (!!) löschen
                move.l  D0,-(A7)
                move.w  #$48,-(A7)      ;Malloc
                trap    #1
                addq.l  #6,A7
                move.l  D0,memfil(A5)
                beq.s   toolongclose    ;Nicht gelungen: Schliessen und Fehler
                movea.l D0,A4
                addq.l  #memfront,A4
                move.l  A4,filstrt(A5)

                move.l  A4,-(A7)        ;filstrt
                move.l  d_len(A5),-(A7)
                move.w  D3,-(A7)        ;Handle
                move.w  #$3F,-(A7)
                trap    #1
                lea     12(A7),A7
                cmp.l   d_len(A5),D0    ;Anzahl gelesener Bytes
                bne.s   noread          ;muss der Dateilänge entsprechen
                adda.l  D0,A4
                clr.b   (A4)            ;Damit PRINT etc. dort abbricht
                move.l  A4,filend(A5)

close:          move.w  D3,-(A7)
                move.w  #$3E,-(A7)      ;Handle schon gesichert
                trap    #1
                addq.l  #4,A7
                rts


notfound:       lea     errfound(A5),A4
                bra.s   brahef          ;bra

notopen:        lea     erropen(A5),A4
                bra.s   brahef          ;bra

noread:         bsr.s   close
                lea     errread(A5),A4
                bra.s   brahef          ;bra

toolongclose:   bsr.s   close
toolong:        lea     errtlong(A5),A4
brahef:         bra     harderrf

                ENDPART
findend:        >PART
                movea.l filstrt(A5),A4
                movea.l A4,A1           ;Zur Längenberechnung
                movea.l filend(A5),A0
                tst.b   endfound(A5)    ;Schon einmal gesetzt, dann nicht mehr nötig!
                bne.s   feskip1
                cmpi.b  #WPREM,(A4)     ;Erstes Zeichen = 31?
                seq     WPflag          ;Dann (wahrscheinlich) 1st-Word
feskip1:        moveq   #0,D1           ;Zeilezaehler
findend1:       move.b  (A4)+,D2        ;Dateiende?
                bne.s   findend0        ;Nein
                cmpa.l  A0,A4
                bhi.s   findend2        ;Ja, Null hinter Dateiende
findend0:       cmp.b   #LF,D2
                bne.s   findend1        ;Kein Line Feed

                addq.l  #1,D1           ;Line Feed!
                bsr.s   findeDLL        ;DUMP-Modus nötig?
                bra.s   findend1

findeDLL:       tst.b   endfound(A5)
                bne.s   findeDrt
                move.l  A4,D2
                sub.l   A1,D2
                movea.l A4,A1           ;Neuen Zeilenanfang sichern
                cmp.l   #DLL,D2         ;Zeile zu lang? DLL=Dump Line Length
                bcs.s   findeDrt
                sf      WPflag(A5)      ;WPflag löschen
                st      DUMPflag(A5)    ;Und DUMPflag setzen
findeDrt:       rts

findend2:       subq.l  #1,A4           ;Schon eins zu weit (Hinter NUL)
                bsr.s   findeDLL        ;DUMP-Modus nötig?
                move.l  D1,numlines(A5)
                st      endfound(A5)    ;Flags gesetzt, lasse jetzt den User daran ändern!
                tst.b   DUMPflag(A5)
                bne.s   findend6        ;Zurückkehren
                bra.s   findend5        ;Sonst vorher noch einiges setzen

                ENDPART
setEOFLF:       >PART                   ;Darf D0 nicht ändern (chWP)
                movea.l filend(A5),A4   ;Hole Dateiende
findend5:       cmpi.b  #EOF,-(A4)      ;Überhaupt ein EOF vorhanden?
                seq     ctrlz(A5)
                beq.s   findend3
                addq.l  #1,A4           ;Wieder korrigieren, falls falsch
findend3:       cmpi.b  #LF,-1(A4)
                beq.s   findend4
                move.b  #LF,(A4)+       ;Hänge ein LF an, damit
                st      ctrlj(A5)       ;letzte Zeile auch sichtbar ist
                addq.l  #1,numlines(A5) ;Hier auch korrigieren
findend4:       clr.b   (A4)            ;Markiere EOF
findend6:       move.l  A4,filend(A5)
                rts

                ENDPART

********************************************************************************

clrEOFLF:       >PART                   ;Darf D0 nicht ändern (chWP)
                movea.l filend(A5),A4
                tst.b   ctrlj(A5)
                beq.s   noctrlj
                sf      ctrlj(A5)
                subq.l  #1,numlines(A5) ;Zeilenanzahl auch wieder korrigieren
                subq.l  #1,A4
noctrlj:        tst.b   ctrlz(A5)
                beq.s   noctrlz
                sf      ctrlz(A5)
                move.b  #EOF,(A4)+
noctrlz:        move.l  A4,filend(A5)
                clr.b   (A4)
                rts

                ENDPART

********************************************************************************

harderr:        bsr.s   messagek
                bra     term

harderrf:       >PART 'Kann Datei xxx yyy. Taste...'
                move.l  A4,-(A7)
                bsr.s   startinf        ;Alles in Infozeile
                lea     errfile(A5),A4  ;"Kann Datei "
                bsr     tnirp
                movea.l fnameadr(A5),A4
                bsr     tnirp
                movea.l (A7)+,A4        ;Übergebener Text
                bsr     tnirp
                lea     taste(A5),A4    ;"Taste drücken..."
                bsr     tnirp
                bsr.s   stopinf
                bsr     getukey         ;Input
                bra     term

                ENDPART
messagef:       >PART 'Nicht schreiben'
                bsr.s   startinf
                lea     errfile(A5),A4  ;"Kann Datei "
                bsr     tnirp
                lea     savename(A5),A4 ;Savefilename
                bsr     tnirp
                lea     errwrite(A5),A4 ;" nicht schreiben!   Taste drücken..."
                bsr     tnirp
                bsr.s   stopinf
                bra     getukey

                ENDPART
messagee:       >PART 'Existiert schon'
                bsr.s   startinf
                lea     errafile(A5),A4 ;"Datei "
                bsr     tnirp
                lea     savename(A5),A4 ;Savefilename
                bsr     tnirp
                lea     errexist(A5),A4 ;" existiert bereits!"
                bra.s   message0
                ENDPART
messagek:       >PART 'Blablabla. Taste drücken...'
                bsr.s   startinf        ;Darf A4 nicht ändern
message0:       bsr     tnirp
                lea     taste(A5),A4
                bsr     tnirp
                bsr.s   stopinf
                bra     getukey

                ENDPART
message:        >PART
                bsr.s   startinf
                bsr     tnirp
                bra.s   stopinf
                ENDPART
startinf:       >PART
                move.l  screen(A5),cursor(A5) ;Von jetzt an INFO-Zeile beschreiben
                move.w  maxpos(A5),maxsave(A5)
                move.b  #1,maxlin(A5)
                clr.w   crspos(A5)
                rts
                ENDPART
stopinf:        >PART
                tst.b   crslin(A5)
                bne.s   siret           ;Über Zeilenende hinaus geschrieben?
                lea     crlf(A5),A4
                bsr     tnirp           ;löschen bis Zeilenende
siret:          move.w  maxsave(A5),maxpos(A5) ;Nicht mehr in INFO-Zeile
                rts
                ENDPART
clreos:         >PART
                move.b  maxlin(A5),D0
                cmp.b   crslin(A5),D0   ;Schon alles durch?
                beq.s   cesret
                tst.b   crscol(A5)
                beq.s   cesnLF
                bsr.s   prtLF
cesnLF:         moveq   #0,D0
                move.b  maxlin(A5),D0
                sub.b   crslin(A5),D0   ;Jetzt am Ende?
                mulu    v_cel_ht(A5),D0 ;Textzeilen*Zeichenhöhe = Anzahl Zeilen
                beq.s   cesret
                subq.w  #1,D0           ;Für DBF, Schirm nie höher als 32000 Zeilen
                moveq   #0,D1
                move.w  v_cel_w(A5),D3
                mulu    v_planes(A5),D3
                move.w  bytes_lin(A5),D4
                sub.w   D3,D4
                movea.l cursor(A5),A0
cesloop:        move.w  D3,D2
                lsr.w   #2,D2           ;/4
                bcc.s   cesnword
                move.w  D1,(A0)+
cesnword:       subq.w  #1,D2
                beq.s   cesloop3
cesloop2:       move.l  D1,(A0)+
                dbra    D2,cesloop2
                adda.w  D4,A0
cesloop3:       dbra    D0,cesloop
cesret:         rts

                ENDPART
prtLF:          >PART
                movea.l cursor(A5),A1
                bsr     printCR         ;Leerzeichen bis zum Zeilenende
                bsr     printLF         ;Und auf die nächste Zeile
                move.l  A1,cursor(A5)
                rts
                ENDPART
; Möglichst ohne Interpretation von Steuerzeichen (ausser CR, LF, TAB)
print:          >PART
                move.b  maxlin(A5),D0
                cmp.b   crslin(A5),D0
                beq     printret2
                movea.l fontadr(A5),A0
                movea.l cursor(A5),A1

                sf      printMEM(A5)    ;Default: geladenes Dokument drucken
                cmpa.l  filstrt(A5),A4
                scs     printMEM(A5)    ;Adresse vor dem Buffer: Default falsch
                bcs.s   printch
                cmpa.l  filend(A5),A4
                shs     printMEM(A5)    ;Adresse hinter Buffer: Default falsch

printch:        moveq   #0,D3
                move.b  (A4)+,D3
                bne.s   printN0
                tst.b   printMEM(A5)    ;Falls nicht der Buffer angezeigt wird,
                bne     printret        ;dann ist beim NULL das Ende
                cmpa.l  filend(A5),A4
                bhi     printabt
printN0:        tst.b   DUMPflag(A5)    ;Nichts interpretieren
                bne.s   printLFn
                move.b  TABflag(A5),D0  ;TAB expandieren?
                beq.s   prinTABn        ;Nein
                cmpi.b  #TAB,D3
                beq     printTAB
prinTABn:       tst.b   DUMPflag(A5)    ;CR/LF-Test überspringen
                bne.s   printLFn
                cmpi.b  #CR,D3
                bne.s   printCRn
                cmpi.b  #LF,(A4)        ;CR werden nur angezeigt, wenn
                beq.s   printch         ;nicht von LF gefolgt.
                bra.s   printLFn
printCRn:       cmpi.b  #LF,D3
                bne.s   printLFn
                bsr     printCR
                bsr     printLF
                bra.s   printch

printLFn:       move.b  crscol(A5),D2
                cmp.b   maxcol(A5),D2
                beq     printeol
                addq.b  #1,D2
                move.b  D2,crscol(A5)

                tst.b   DUMPflag(A5)    ;Welcher DUMP-Modus?
                bpl.s   printout        ;Keiner oder "alter": ->
                cmpi.b  #" ",D3         ;32..159?
                bmi     printXXX        ;Spezialzeichen ausgeben

printout:       tst.b   D3
                beq     printNUL
                tst.b   WPflag(A5)      ;Ist der WP-Modus eingeschalten?
                beq.s   printANY        ;Nein, dann ganz normal
                cmpi.b  #" ",D3
                bcc.s   printANY        ;>=" ", dann normal
                cmpi.b  #ESC,D3         ;ESC?
                beq.s   printESC
                cmpi.b  #PARAGRAF,D3    ;Absatzlänge?
                beq.s   printESC
                cmpi.b  #FF,D3          ;Fester Seitenumbruch?
                beq.s   printFF
                cmpi.b  #WPTDU,D3       ;Trait d'Union
                bne.s   prinTDUn
                moveq   #"~",D3         ;Ersetzen
                bra.s   printANY
prinTDUn:       cmpi.b  #WPSPCEXT,D3    ;kleiner als verlängerndes Leerzeichen?
                bcs.s   printANY        ;Ja, anzeigen
                cmpi.b  #WPSPC,D3       ;grösser als "normales" WP-Leerzeichen?
                bhi.s   printANY        ;Ja, anzeigen
                bsr     printSPC        ;sonst Leerzeichen
                bra     printch

printESC:       addq.l  #1,A4           ;Ja, nächstes Zeichen überspringen
printFF:        subq.b  #1,crscol(A5)   ;Spaltenzähler wieder zurücksetzen
                bra     printch

printANY:       lea     0(A0,D3.w),A2   ;Zeichen auf Schirm ausgeben
                move.w  bytes_lin(A5),D3
                move.w  v_planes_1(A5),D6

printANYl:      adda.w  v_cel_wr(A5),A1 ;Gleiche Stelle eine Textzeile weiter
                cmpi.w  #16,v_cel_ht(A5) ;16 Pixel hoch?
                bne.s   printANY8
                suba.w  D3,A1
                move.b  $0F00(A2),(A1)
                suba.w  D3,A1
                move.b  $0E00(A2),(A1)
                suba.w  D3,A1
                move.b  $0D00(A2),(A1)
                suba.w  D3,A1
                move.b  $0C00(A2),(A1)
                suba.w  D3,A1
                move.b  $0B00(A2),(A1)
                suba.w  D3,A1
                move.b  $0A00(A2),(A1)
                suba.w  D3,A1
                move.b  $0900(A2),(A1)
                suba.w  D3,A1
                move.b  $0800(A2),(A1)
printANY8:      suba.w  D3,A1
                move.b  $0700(A2),(A1)
                suba.w  D3,A1
                move.b  $0600(A2),(A1)
                suba.w  D3,A1
                move.b  $0500(A2),(A1)
                suba.w  D3,A1
                move.b  $0400(A2),(A1)
                suba.w  D3,A1
                move.b  $0300(A2),(A1)
                suba.w  D3,A1
                move.b  $0200(A2),(A1)
                suba.w  D3,A1
                move.b  $0100(A2),(A1)
                suba.w  D3,A1
                move.b  (A2),(A1)
                addq.l  #2,A1
                dbra    D6,printANYl

printANYadj:    move.w  A1,D6
                and.w   #1,D6           ;Gerade?
                bne.s   printANYo       ;Nein ->
                suba.w  v_planes__2(A5),A1
                addq.l  #1,A1
                bra     printch

printANYo:      subq.l  #1,A1
                bra     printch

printabt:       subq.l  #1,A4           ;abgebrochen wegen Textende
                bsr.s   printCR         ;Zeiger korrigieren und bis Zeilenede löschen
                bsr.s   printLF         ;Und auf die nächste Zeile gehen
;(damit clreos keinen Mist baut)
printret:       move.l  A1,cursor(A5)   ;Neue Cursorposition speichern
printret2:      rts

printTAB:       move.b  crscol(A5),D2
                move.b  D2,D0
                move.b  maxcol(A5),D1
                cmp.b   D1,D2           ;Jetzt schon am Ende --> neue Zeile
                beq.s   printeol
                or.b    TABmask(PC),D2
                not.b   D2              ;= Zuerst NOTen, dan ANDen
                ext.w   D2              ;Vorzeichenlos erweitern (D2 ε {2,4,8})
printTL:        bsr.s   printSPC
                addq.b  #1,D0           ;Aktuelle Position erhöhen
                cmp.b   D0,D1           ;Schon am Zeilenende?
                dbeq    D2,printTL
                move.b  D0,crscol(A5)   ;Neue Position merken
                bra     printch

printeol:       move.w  v_planes(A5),D0 ;Zeilenende erreicht
                mulu    v_cel_w(A5),D0
                suba.l  D0,A1
                clr.b   crscol(A5)
                subq.l  #1,A4           ;Damit das Zeichen nochmal geholt wird
                pea     printch(PC)     ;printLF kehrt dann dorthin zurück

printLF:        move.b  crslin(A5),D2
                addq.b  #1,D2
                move.b  D2,crslin(A5)   ;Damit immer auf dem neuesten Stand
                cmp.b   maxlin(A5),D2
                beq.s   prtret04
                adda.w  v_cel_wr(A5),A1 ;Cursor eine Zeichenzeile abwärts
                rts

prtret04:       addq.l  #4,A7
                bra.s   printret

printCR:        moveq   #0,D2
                move.b  maxcol(A5),D2   ;In letzter Spalte, dann nicht löschen
                sub.b   crscol(A5),D2
                bra.s   printCRd
printCRc:       bsr.s   printSPC        ;1 Zeichen löschen
printCRd:       dbra    D2,printCRc

                move.w  v_planes(A5),D0 ;Zurück zum Zeilenanfang
                mulu    v_cel_w(A5),D0
                suba.l  D0,A1
                clr.b   crscol(A5)
                rts


tnirpSPC:       moveq   #-1,D7
                bra.s   printSPC0
printSPC:       moveq   #0,D7
printSPC0:      move.w  v_planes_1(A5),D6
                move.w  bytes_lin(A5),D3
printSPC0l:     adda.w  v_cel_wr(A5),A1 ;Gleiche Stelle eine Textzeile weiter
                cmpi.w  #16,v_cel_ht(A5) ;16 Pixel hoch?
                bne.s   printSPC08
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
printSPC08:     suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                addq.l  #2,A1
                dbra    D6,printSPC0l

                move.w  A1,D6
                and.w   #1,D6           ;Gerade?
                bne.s   printSPCo       ;Nein ->
                suba.w  v_planes__2(A5),A1
                addq.l  #1,A1
                rts

printSPCo:      subq.l  #1,A1
                rts


; Selbstdefinierte(s) Zeichen für ASCII 0
printNUL:       move.w  bytes_lin(A5),D3
                moveq   #0,D7
                move.w  v_planes_1(A5),D6
                tst.b   NULflag(A5)
                bne.s   prtMSNUL

printNULl:      adda.w  v_cel_wr(A5),A1 ;Gleiche Stelle eine Textzeile weiter
                cmpi.w  #16,v_cel_ht(A5) ;16 Pixel hoch?
                bne.s   printNUL8
                suba.w  D3,A1           ;'NUL'
                move.b  #$1E,(A1)
                suba.w  D3,A1

                moveq   #$10,D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  #$18,(A1)
                suba.w  D3,A1

                moveq   #$24,D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)

printNUL8:      suba.w  D3,A1
                moveq   #$24,D0         ;Muss sein...
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1

                moveq   #$48,D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  #$58,(A1)
                suba.w  D3,A1
                move.b  #$68,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                addq.l  #2,A1
                dbra    D6,printNULl
                bra     printANYadj

prtMSNUL:       adda.w  v_cel_wr(A5),A1 ;Gleiche Stelle eine Textzeile weiter
                cmpi.w  #16,v_cel_ht(A5) ;16 Pixel hoch?
                bne.s   printMSNUL8
                suba.w  D3,A1           ;'00'
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  #$60,(A1)
                suba.w  D3,A1
                move.b  #$90,(A1)
                suba.w  D3,A1
                move.b  #$B0,(A1)
                suba.w  D3,A1
                move.b  #$D0,(A1)
                suba.w  D3,A1
                move.b  #$90,(A1)
                suba.w  D3,A1
                move.b  #$60,(A1)
printMSNUL8:    suba.w  D3,A1
                move.b  #$0C,(A1)
                suba.w  D3,A1
                move.b  #$12,(A1)
                suba.w  D3,A1
                move.b  #$16,(A1)
                suba.w  D3,A1
                move.b  #$1A,(A1)
                suba.w  D3,A1
                move.b  #$12,(A1)
                suba.w  D3,A1
                move.b  #$0C,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                suba.w  D3,A1
                move.b  D7,(A1)
                addq.l  #2,A1
                dbra    D6,prtMSNUL
                bra     printANYadj

; Selbstdefinierte(s) Zeichen für ASCII 0
printXXX:       move.w  bytes_lin(A5),D3
                moveq   #0,D7
                move.w  v_planes_1(A5),D6

printXXXl:      adda.w  v_cel_wr(A5),A1 ;Gleiche Stelle eine Textzeile weiter
                cmpi.w  #16,v_cel_ht(A5) ;16 Pixel hoch?
                bne.s   printXXX8
                suba.w  D3,A1           ;spezielles 'X' ausgeben

                moveq   #0,D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)

printXXX8:      suba.w  D3,A1
                moveq   #0,D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  #$44,(A1)
                suba.w  D3,A1

                moveq   #$28,D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  #$10,(A1)
                suba.w  D3,A1
                move.b  D0,(A1)
                suba.w  D3,A1

                move.b  #$44,(A1)
                suba.w  D3,A1
                clr.b   (A1)
                addq.l  #2,A1
                dbra    D6,printXXXl
                bra     printANYadj

                ENDPART
tnirp:          >PART
; Wie print, einfach mit inverser Zeichenausgabe
; NICHT möglich ist die Ausgabe des eingelesenen Textfiles, da NUL immer
; Abschlusszeichen ist und CR nie gedruckt wird.
                move.b  maxlin(A5),D0
                cmp.b   crslin(A5),D0
                beq     tnirpret2
                movea.l fontadr(A5),A0
                movea.l cursor(A5),A1
tnirpch:        moveq   #0,D3
                move.b  (A4)+,D3
                beq     tnirpret
                cmpi.b  #TAB,D3
                beq     tnirpTAB
                cmpi.b  #CR,D3
                bne.s   tnirpCRn
                pea     tnirpch(PC)
                bra     tnirpCR
tnirpCRn:       cmpi.b  #LF,D3
                bne.s   tnirpLFn
                cmpi.b  #CR,-2(A4)      ;War das letzte Zeichen CR?
                beq     tnirpLF         ;Dann nur einfaches LF,
                pea     tnirpLF(PC)     ;sonst CRLF
                bra     tnirpCR
tnirpLFn:       move.b  crscol(A5),D2
                cmp.b   maxcol(A5),D2
                beq     tnirpeol
                addq.b  #1,D2
                move.b  D2,crscol(A5)

tnirpANY:       lea     0(A0,D3.w),A2   ;Zeichen auf Schirm ausgeben
                move.w  bytes_lin(A5),D3
                move.w  v_planes_1(A5),D6

tnirpANYl:      adda.w  v_cel_wr(A5),A1 ;Gleiche Stelle eine Textzeile weiter
                cmpi.w  #16,v_cel_ht(A5) ;16 Pixel hoch?
                bne.s   tnirpANY8
                suba.w  D3,A1
                move.b  $0F00(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0E00(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0D00(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0C00(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0B00(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0A00(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0900(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0800(A2),D0
                not.b   D0
                move.b  D0,(A1)
tnirpANY8:      suba.w  D3,A1
                move.b  $0700(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0600(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0500(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0400(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0300(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0200(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  $0100(A2),D0
                not.b   D0
                move.b  D0,(A1)
                suba.w  D3,A1
                move.b  (A2),D0
                not.b   D0
                move.b  D0,(A1)
                addq.l  #2,A1
                dbra    D6,tnirpANYl

                move.w  A1,D6
                and.w   #1,D6           ;Gerade?
                bne.s   tnirpANYo       ;Nein ->
                suba.w  v_planes__2(A5),A1
                addq.l  #1,A1
                bra     tnirpch

tnirpANYo:      subq.l  #1,A1
                bra     tnirpch

tnirpret:       move.l  A1,cursor(A5)   ;Neue Cursorposition speichern
tnirpret2:      rts

tnirpTAB:       move.b  crscol(A5),D2
                move.b  D2,D0
                move.b  maxcol(A5),D1
                cmp.b   D1,D2           ;Jetzt schon am Ende --> neue Zeile
                beq.s   tnirpeol
                not.b   D2
                and.w   #7,D2
tnirpTL:        bsr     tnirpSPC
                addq.b  #1,D0           ;Aktuelle Position erhöhen
                cmp.b   D0,D1           ;Schon am Zeilenende?
                dbeq    D2,tnirpTL
                move.b  D0,crscol(A5)   ;Neue Position merken
                bra     tnirpch

tnirpeol:       suba.w  bytes_lin(A5),A1
                clr.b   crscol(A5)
                subq.l  #1,A4

tnirpLF:        move.b  crslin(A5),D2
                addq.b  #1,D2
                move.b  D2,crslin(A5)   ;Damit auf neuestem Stand
                cmp.b   maxlin(A5),D2
                beq.s   tnirpret
                adda.w  v_cel_wr(A5),A1 ;Cursor eine Zeichenzeile abwärts
                bra     tnirpch

tnirpCR:        moveq   #0,D2
                move.b  maxcol(A5),D2   ;In letzter Spalte, dann nicht löschen
                sub.b   crscol(A5),D2
                bra.s   tnirpCRd
tnirpCRc:       bsr     tnirpSPC        ;1 Zeichen löschen
tnirpCRd:       dbra    D2,tnirpCRc

                suba.w  bytes_lin(A5),A1 ;Eine Pixelzeile zurück
                clr.b   crscol(A5)
                rts

                ENDPART

********************************************************************************

                >PART 'getukey'
getukeyloop:    bsr     evnt_multi      ;ACCs ans Ruder lassen
                tst.l   D0              ;Taste gedrückt?
                bne.s   getukeyret
                tst.l   kbdtimeout(A5)  ;Muss getimeoutet werden?
                beq.s   getukey         ;Nein ->
                bsr     get_hz_200      ;Aktuelle Systemzeit holen
                cmp.l   kbdtimeout(A5),D0 ;Zeitpunkt schon verstrichen?
                blo.s   getukey         ;Nein, normal weiter
                moveq   #0,D0           ;Taste="Keine Taste"
                bra.s   getukeyret
getukey:        bsr.s   testkey         ;Liegt eine Taste an? (Entry Point)
                beq.s   getukeyloop     ;Nein, weiter warten
getukeyret:     clr.l   kbdtimeout(A5)  ;Sicherheitshalber löschen
                rts

                ENDPART
clearkeybuf:    >PART
                move.w  #100,evnt_delay(A5) ;2 mal 0.1 Sekunden Timeout
clrkbloop:      bsr.s   testkey1        ;Zweimal hintereinander
                bne.s   clrkbloop       ;keine Taste, die wartet
                bsr.s   testkey1        ;(der Timerdelay ist manchmal nicht
                bne.s   clrkbloop       ;besonders genau)
                clr.w   evnt_delay(A5)
                rts
                ENDPART
                >PART 'Testkey'
testkey1:       bsr     evnt_multi
                tst.l   D0              ;Ist etwas gekommen?
                beq.s   testkeyx        ;Nein, normal lesen
                rts

testkey:        bsr     evt_switch      ;Eventuell die ACCs mal dranlassen

testkeyx:       move.w  #2,-(A7)        ;Device: CON:
                move.w  #1,-(A7)        ;Bconstat
                trap    #13
                addq.l  #4,A7
                tst.l   D0
                bne.s   readkey         ;Taste abholen!

                movea.l lineaptr(A5),A0
                bsr.s   tkmget
                beq.s   tkret           ;Nein, alle losgelassen
                subq.b  #2,D0
                bmi.s   tkmlinks        ;Linke Taste?
                beq.s   tkmrecht
tkmwait:        bsr.s   tkmget
                bne.s   tkmwait         ;Warte, bis losgelassen
                moveq   #ESC,D0         ;Melde <ESC>
testret:        rts

tkmlinks:       moveq   #DOWN,D0
                bra.s   tkmret

tkmrecht:       moveq   #UP,D0
tkmret:         swap    D0
                rts

tkmget:         moveq   #3,D0           ;Wir wollen nur die Maustasten
                and.b   CURMSSTA(A0),D0 ;Sind überhaupt Maustaste(n) gedrückt?
                rts
                ENDPART
readkey:        >PART
                move.w  #2,-(A7)        ;Device: CON
                move.w  #2,-(A7)        ;Bconin
                trap    #13
                addq.l  #4,A7

                movea.l ioreck(A5),A0   ;Lösche Tastaturpuffer
                clr.l   6(A0)           ;Setze Head=Tail=0

key_finish:     bclr    #LShift,D0      ;Ist LeftShift gedrückt?
                beq.s   upcase
                bset    #Shift,D0       ;Dann vereinheitliche das zu 1 (R)Shift
upcase:         tst.b   noupcase(A5)    ;In Grossbuchstaben wandeln?
                bne.s   rkret           ;Nein ->
                cmpi.b  #"a",D0         ;Wandle in Grossbuchstaben
                bcs.s   rkret
                cmpi.b  #"z",D0
                bhi.s   rkret
                sub.b   #"a"-"A",D0
rkret:          andi.l  #$0FFF00FF,D0   ;Ohne CapsLock und RMouse/LMouse
tkret:          rts

                ENDPART

********************************************************************************

; Sucht das Ende der nächsten BILDSCHIRMzeile
nextline:       >PART
                move.w  v_cel_w(A5),D0
                moveq   #0,D1
                move.l  filend(A5),D2

                tst.b   DUMPflag(A5)
                bne.s   nextDUMP

nextch:         move.b  (A4)+,D3
                bne.s   nexttTAB
                cmpa.l  D2,A4
                bhi.s   nextret1
nexttTAB:       cmpi.b  #TAB,D3
                beq.s   nextTAB
                cmpi.b  #CR,D3
                bne.s   nexttLF
                cmpi.b  #LF,(A4)
                beq.s   nextch
                bra.s   nextnLF
nexttLF:        cmpi.b  #LF,D3
                beq.s   nextret
nextnLF:        tst.b   WPflag          ;!tst WP-Modus?
                beq.s   nextoter        ;Nein, normal
                cmpi.b  #ESC,D3         ;Attributumschaltsequenz (2 Zeichen)?
                beq.s   nextWP          ;Dieses und nächstes Zeichen ignorieren
                cmpi.b  #PARAGRAF,D3    ;Absatzlänge?
                beq.s   nextWP          ;Dieses und nächstes Zeichen ignorieren
                cmpi.b  #FF,D3          ;Feste Zeilentrennung?
                beq.s   nextch          ;Dieses Zeichen ignorieren

nextoter:       cmp.b   D0,D1
                bhs.s   nextret1
                addq.b  #1,D1           ;Nächstes Zeichen, aber nur wenn
                bra.s   nextch          ;nicht EOF

nextret1:       subq.l  #1,A4
nextret:        rts

nextWP:         addq.l  #1,A4           ;Zeichen überspringen
                cmpa.l  D2,A4
                bhi.s   nextret1
                bra.s   nextch          ;Und ganze Sequenz ignorieren

nextTAB:        tst.b   TABflag(A5)     ;!tst
                beq.s   nextoter        ;Wie normales Zeichen
                cmp.b   D0,D1
                bhs.s   nextret1
                add.b   TABflag(A5),D1  ;Falls die Anzahl der Zeichenzellen
                and.b   TABmask(A5),D1  ;nicht durch TABflag teilbar ist, wird
                bra.s   nextch          ;hier ein zu grosses D1 erzeugt

nextDUMP:       adda.w  D0,A4           ;+ Bildbreite
                move.l  filend(A5),D1
                cmpa.l  D1,A4
                bcs.s   nextret
                movea.l D1,A4
                rts

                ENDPART
; Sucht den Beginn der vorhergehenden Bildschirmzeile
prevline:       >PART
                tst.b   DUMPflag(A5)
                bne.s   prevDUMP
                movea.l A4,A2
                movea.l filstrt(A5),A0
                moveq   #LF,D0
                subq.l  #1,A4           ;Überspringe dieses LF
prevLF:         cmpa.l  A0,A4
                bcs.s   prevatbegin
                cmp.b   -(A4),D0
                bne.s   prevLF
prevatbegin:    addq.l  #1,A4           ;Wieder direkt hinter dieses LF
prevnext:       movea.l A4,A1           ;Letzte Bildschirmzeile direkt
                bsr     nextline        ;vor der zuletzt dargestellten
                cmpa.l  A4,A2           ;suchen
                bhi.s   prevnext
                movea.l A1,A4
                rts

* Läuft nur, falls Datei kleiner als 5MBytes ist!
prevDUMP:       move.l  A4,D0
                movea.l filstrt(A5),A4
                sub.l   A4,D0
                bcs.s   prevDret
                subq.l  #1,D0
                bcs.s   prevDret
                divu    v_cel_w(A5),D0
                mulu    v_cel_w(A5),D0
                adda.l  D0,A4
prevDret:       rts

                ENDPART

********************************************************************************
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
********************************************************************************

str2long:       >PART                   ; Liest Zahl aus dem String aus
                moveq   #0,D1
                move.b  (A0)+,D1
                sub.b   #"0",D1         ;Erstes Zeichen ungültig?
                bcs.s   s2l_ret         ;Ja, Originalwert von D0 zurückgeben
                moveq   #0,D0

s2l_loop:       move.l  D0,D2
                add.l   D0,D0           ;*2
                lsl.l   #3,D2           ;*8
                add.l   D2,D0           ;d1*2+d1*8=d1*10
                add.l   D1,D0           ;Nächste Stelle dazuzählen
                move.b  (A0)+,D1
                sub.b   #"0",D1
                bcc.s   s2l_loop
s2l_ret:        rts

                ENDPART
; Schreibe Zahl ohne führende Leerzeichen (Zahl in D3, Text ab A4)
long2str:       >PART
                lea     numbers(A5),A0
                moveq   #0,D1           ;Keine "leading spaces" o.ä.
numloop:        move.l  (A0)+,D2
                beq.s   numret
                cmp.l   D2,D3
                bcc.s   numdigit
                tst.b   D1              ;Ein Zeichen schreiben?
                beq.s   numloop         ;Nöö!
                move.b  D1,(A4)+
                bra.s   numloop

numdigit:       moveq   #"0",D0
                moveq   #"0",D1         ;In Zukunft auch Nullen schreiben!
numnxtd:        sub.l   D2,D3
                addq.b  #1,D0
                cmp.l   D2,D3
                bcc.s   numnxtd         ;Immer noch grösser?
                move.b  D0,(A4)+
                bra.s   numloop

numret:         add.b   #"0",D3         ;letzte Stelle schreiben
                move.b  D3,(A4)+
                rts

                ENDPART
; Schreibe Zahl mit der Anzahl Zeichen, die NUMLINES bzw. D_LEN auch hat
long3str:       >PART
                lea     numbers(A5),A0  ;Suche richtige Dezimalstelle
                move.l  numlines(A5),D0 ;Default

                tst.b   DUMPflag(A5)
                beq.s   l3sL
                move.l  d_len(A5),D0    ;Default war falsch...

l3sL:           cmp.l   (A0)+,D0
                bcs.s   l3sL
                subq.l  #4,A0           ;Schon eins zu weit
                moveq   #" ",D1         ;Mit "leading spaces"
                bra.s   numloop

                ENDPART
makeinfo:       >PART
                bsr     startinf
                lea     infotext(A5),A3
                lea     infoline(A5),A4
                bsr.s   copyA3A4        ;kopiere "Datei: "
                movea.l fnameadr(A5),A6
                bsr.s   copyA6A4        ;kopiere Dateiname

                tst.b   DUMPflag(A5)    ;DUMP?
                bne.s   makeD1          ;Nein, Textmodus
                bsr.s   copyA3A4        ;kopiere ", "
                move.l  d_len(A5),D3
                bsr.s   long2str        ;kopiere Länge
                bsr.s   copyA3A4        ;kopiere " Bytes, Zeile "
                bra.s   makeD1n

makeD1:         lea     dumpinfo(A5),A3
                bsr.s   copyA3A4        ;Kopiere ", Byte "

makeD1n:        lea     infoline(A5),A4
                bsr     tnirp
                move.w  crspos(A5),alnatcrs(A5)
                move.l  cursor(A5),alnatpos(A5)

                lea     infoline(A5),A4
                tst.b   DUMPflag(A5)
                beq.s   makeD2
                move.l  filpos1(A5),D3
                sub.l   filstrt(A5),D3
                bsr.s   long3str        ;kopiere relative Position in der Datei
                bsr.s   copyA3A4        ;kopiere " von "
                move.l  d_len(A5),D3
                bra.s   makeD2n

makeD2:         move.l  nowline(A5),D3
                bsr.s   long3str        ;kopiere NOWLINE analog NUMLINES
                bsr.s   copyA3A4        ;kopiere " von "
                move.l  numlines(A5),D3

makeD2n:        bsr     long3str
                clr.b   (A4)+
                lea     infoline(A5),A4
                bsr     tnirp
                bra     stopinf         ;Anzeigen und zurück


copyA3A4:       move.b  (A3)+,(A4)+
                bne.s   copyA3A4
                subq.l  #1,A4
                rts

copyA6A4:       move.b  (A6)+,(A4)+
                bne.s   copyA6A4
                subq.l  #1,A4
                rts

                ENDPART
; Schreibe nur neue Zeilennummer
updateln:       >PART
                move.w  alnatcrs(A5),crspos(A5)
                tst.b   alnatcrs(A5)    ;Kein Platz für Zeilennummer?
                bne.s   updlnret
                move.l  alnatpos(A5),cursor(A5)
                move.w  maxpos(A5),maxsave(A5)
                move.b  #1,maxlin(A5)
                lea     alnat(A5),A4
                move.l  nowline(A5),D3  ;Default

                tst.b   DUMPflag(A5)
                beq.s   updateDn
                move.l  filpos1(A5),D3  ;Default war falsch...
                sub.l   filstrt(A5),D3

updateDn:       bsr     long3str
                clr.b   (A4)+           ;$00 anfügen
                lea     alnat(A5),A4
                bsr     tnirp
                move.w  maxsave(A5),maxpos(A5)
updlnret:       rts

                ENDPART

********************************************************************************

edit:           >PART 'Zeileneditor'
                move.w  D0,editmax(A5)  ;Maximallänge merken
                move.b  D1,editnum(A5)  ;Flag
                move.l  A1,editbuf(A5)  ;Bufferanfang merken
                movea.l A0,A4           ;Sichern
                bsr     startinf        ;Zur Inforzeile
                bsr     tnirp           ;Prompt invers ausgeben
                move.w  crspos(A5),editpos(A5)
                move.l  cursor(A5),editcurs(A5) ;Aktuelle Position merken
editmloop:      move.w  editpos(A5),crspos(A5)
                move.l  editcurs(A5),cursor(A5) ;Aktuelle Position zurück
                movea.l editbuf(A5),A4
                bsr     print           ;Aktuelle Zeile ausgeben
                lea     space(A5),A4    ;Leerzeichen invers ausgeben
                bsr     tnirp
                bsr     prtLF           ;Bis Zeilenende löschen
editkey:        st      noupcase(A5)    ;Nicht nach Grossbuchstaben wandeln
                bsr     getukey
                sf      noupcase(A5)
                tst.b   D0              ;Unteres Byte 0?
                beq.s   editkey         ;Ja, ungültiges Zeichen
                movea.l editbuf(A5),A0  ;Bufferadresse holen
                cmp.b   #BS,D0          ;Backspace?
                beq.s   editbs          ;Ja -> letztes Zeichen löschen
                cmp.b   #ESC,D0         ;ESC?
                beq.s   editesc         ;Ja -> ganzen String löschen
                cmp.b   #CR,D0          ;Return?
                beq     siret           ;Ja -> Ende der Eingabe
                cmp.b   #" ",D0         ;Kleiner als Space?
                bcs.s   editkey         ;Ja -> unültiges Zeichen
                tst.b   editnum(A5)     ;Nur Ziffern?
                beq.s   editaddchar     ;Nein -> Zeichen ok
                cmp.b   #"0",D0
                bcs.s   editkey         ;<"0"? Ja -> ungültiges Zeichen
                cmp.b   #"9",D0
                bhi.s   editkey         ;>"9"? Ja -> ungültiges Zeichen

editaddchar:    move.w  editmax(A5),D1  ;Maximale Zeilenlänge
editstrcat:     subq.w  #1,D1           ;Noch Platz
                bcs.s   editkey         ;Nein -> nichts tun
                tst.b   (A0)+           ;Stringende?
                bne.s   editstrcat      ;Nein -> weiter suchen
                move.b  D0,-1(A0)       ;Ja, Zeichen anhängen
editesc:        clr.b   (A0)            ;Und Stringende markieren
                bra.s   editmloop       ;Und weiter

editbs:         tst.b   (A0)+           ;Stringende schon am Anfang
                beq.s   editkey         ;Ja, String leer -> nichts tun
editbsloop:     tst.b   (A0)+           ;Stringende?
                bne.s   editbsloop      ;Nein ->
                clr.b   -2(A0)          ;Ja, letztes Zeichen löschen
                bra     editmloop

                ENDPART
goto:           >PART 'Springe Zeile an'
                clr.b   gotobuf(A5)     ;Mit leerer Eingabezeile beginnen

                moveq   #GOTOlen,D0     ;Maximale Zeilenlänge
                moveq   #1,D1           ;Nur Ziffern
                lea     gotobuf(A5),A1  ;Eingabebuffer

                tst.b   DUMPflag(A5)
                bne.s   gotodump        ;DUMP? Ja ->

                lea     gotolinetxt(A5),A0 ;Eingabeprompt
                bsr     edit

                move.l  nowline(A5),D0
                lea     gotobuf(A5),A0
                bsr     str2long

gotolineD0:     move.l  D0,nowline(A5)
                cmp.l   numlines(A5),D0
                bhs     bottom          ;>= Letzte Zeile? Ja -> Ende
                subq.l  #1,D0
                bls     top             ;Zeile 0 oder 1? Ja -> Anfang

                moveq   #LF,D1
                movea.l filstrt(A5),A4  ;Hole Dateianfang
g_findlf:       cmp.b   (A4)+,D1        ;LF?
                bne.s   g_findlf        ;Nein -> nochmals
                subq.l  #1,D0           ;Eine echte Zeile weniger
                bne.s   g_findlf        ;Noch mehr? Ja ->

                move.l  A4,filpos1(A5)
                movea.l filend(A5),A3
                move.w  v_cel_h(A5),D4  ;Bildhöhe
                bra.s   g_fbentry

g_findbot:      bsr     nextline
g_fbentry:      cmpa.l  A3,A4
                bcc     bottom          ;Text hier zuende -> gehe ans Ende
                subq.w  #1,D4           ;Schon am unteren Bildschirmende?
                bne.s   g_findbot       ;Nein ->

                move.l  A4,filpos2(A5)
                bra     redraw


gotodump:       lea     gotobytetxt(A5),A0 ;"Gehe Byte"
                bsr     edit

                move.l  filpos1(A5),D0
                sub.l   filstrt(A5),D0  ;Defaultwert
                lea     gotobuf(A5),A0
                bsr     str2long        ;Hole eingegebene Zahl

gotodumpD0:     move.w  v_cel_w(A5),D1
                divu    D1,D0           ;Abrunden auf nächstkleineres
                mulu    D1,D0           ;Vielfaches der Zeichen/Zeile
                mulu    v_cel_h_1(A5),D1 ;Bildschirmbreite * -höhe
                add.l   D0,D1
                cmp.l   d_len(A5),D1    ;Wäre Bildende ausserhalb?
                bhs     bottom          ;Ja -> ganz nach unten
                add.l   filstrt(A5),D0  ;Nein, alles hat Platz
                move.l  D0,filpos1(A5)  ;filpos1/2 bestimmen
                add.l   filstrt(A5),D1
                move.l  D1,filpos2(A5)
                bra     redraw

                ENDPART
find:           >PART 'Wer suchet, der findet' ;(manchmal)
                moveq   #FINDlen,D0     ;Eingabelänge
                moveq   #0,D1           ;Alle Zeichen
                lea     findtxt(A5),A0  ;Eingabeprompt
                lea     findbuf(A5),A1
                bsr     edit

                move.l  nowline(A5),D1  ;Aktuelle Zeilennummer
                movea.l filpos1(A5),A0  ;Suche ab aktueller Position
findfromsame:   lea     findbuf(A5),A1  ;Suche nach dem eingegebenen Text
                move.l  A0,D7           ;Sichern für finddump
                tst.b   (A1)            ;Suchstring leer?
                beq.s   findbell        ;Ja -> Klingeln
                bsr.s   achfind         ;Jetzt suchen
                subq.l  #1,D0           ;Gefunden?
                bcs.s   findbell        ;Nein ->
                tst.b   DUMPflag(A5)    ;DUMPmodus?
                bne.s   finddump        ;Ja, springe dieses Byte an
                move.l  D1,D0           ;Nein, hole anzuspringende Zeile
                bra     gotolineD0      ;und springe diese an

finddump:       add.l   D7,D0           ;Relativ zur aktuellen Adresse wird zu
                sub.l   filstrt(A5),D0  ;relativ zum Dateianfang
                bra.s   gotodumpD0

findbell:       bsr.s   bell
                bsr     makeinfo
                bra     mainloop

                ENDPART
findsame:       >PART '... und findet nochmals ...'
                movea.l filpos1(A5),A4  ;Aktuelle Position holen
                bsr     nextline        ;Eine Zeile nach unten
                movea.l A4,A0
                move.l  nowline(A5),D1  ;Hole Zeile
                cmpi.b  #LF,-1(A4)      ;Eine Zeile nach unten?
                bne.s   findfromsame    ;Nein, alles ok
                addq.l  #1,D1           ;Ja, eins dazu
                bra.s   findfromsame

                ENDPART
                >PART 'Suche String im Buffer'
; Sucht einen String (beginnend mit A1) im String beginnend mit A0
; Rückgabe in D0:
; 0: Nicht gefunden
; 1: an erster Position
; 2: an zweiter Position
; etc.
; Rückgabe in D1: Aktuelle Zeilennummer
achfind:        movea.l filend(A5),A6
                movea.l A0,A2           ;Zwischenspeichern (Positionsberechnung)
                move.b  (A1)+,D0        ;1. zu suchendes Byte
                beq.s   affnd1          ;Patternstring leer? ==> schon gefunden
                moveq   #LF,D3
achfnd1:        cmpa.l  A0,A6           ;Bufferende erreicht?
                bls.s   afnfnd          ;Ja, nicht gefunden
                move.b  (A0)+,D2        ;Suchen...
                cmp.b   D3,D2           ;Zeile zuende?
                bne.s   achfndnlf       ;Nein ->
                addq.l  #1,D1           ;Ja, nächste Zeile
achfndnlf:      cmp.b   D2,D0
                bne.s   achfnd1         ;Noch kein möglicher Anfang gefunden, weiter
                movea.l A1,A3           ;Speichern
                movea.l A0,A4
achfnd2:        move.b  (A3)+,D2
                beq.s   affound         ;Ende des Patternstrings?
                cmpa.l  A4,A6           ;Bufferende erreicht?
                bls.s   afnfnd
                cmp.b   (A4)+,D2        ;noch gleich?
                beq.s   achfnd2         ;Ja -> hier weitersuchen
                bra.s   achfnd1         ;Nein, wieder nach dem 1. Byte suchen
affnd1:         moveq   #1,D0
                bra.s   afret
afnfnd:         moveq   #0,D0           ;Nicht gefunden
                bra.s   afret
affound:        suba.l  A2,A0           ;Position zurückmelden
                move.l  A0,D0
afret:          rts

                ENDPART
bell:           >PART 'Klingeln'
                move.w  #BEL,-(A7)
                move.w  #2,-(A7)        ;CON:
                move.w  #3,-(A7)        ;Bconout()
                trap    #13
                addq.l  #6,A7
                rts

                ENDPART

********************************************************************************
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
********************************************************************************

bptitle:        >PART
                tst.b   DUMPflag(A5)
                beq.s   bptnodump
                bsr     startinf
                lea     tausdump(A5),A4 ;"Drucke Byte"
                bsr     tnirp
                lea     tausabbr(A5),A4 ;TAB,TAB,"Abbruch mit <ESC>"
                bsr     tnirp
                bra     stopinf
bptnodump:      lea     tausdruk(A5),A4 ;"Drucke Zeile",TAB,TAB,"Abbr."
                bra     message
                ENDPART
filprt:         >PART
                bsr.s   prtsav
                bsr     initprinter
filprt2:        moveq   #1,D0           ;Zeilennummer
                move.l  D0,nowline(A5)
                movea.l filstrt(A5),A4
                bra.s   bothprt

filprtdirect:   clr.l   cfgptr1(A5)     ;Direkt ausdrucken
                clr.l   cfgptr2(A5)
                bsr.s   prtsav
                bra.s   filprt2

prtsav:         move.l  nowline(A5),savnowln(A5)
                move.l  filpos1(A5),savfpos1(A5)
                rts

                ENDPART
blkprt:         >PART
                bsr.s   prtsav
                bsr     initprinter
                movea.l savfpos1(A5),A4

                IF 0
                moveq   #LF,D1
blkprt1:        move.b  -(A4),D0        ;Suche Anfang dieser phys. Zeile
                beq.s   blkprt2
                cmp.b   D1,D0
                bne.s   blkprt1
blkprt2:        addq.l  #1,A4
                ENDC

                ENDPART
bothprt:        >PART
                st      clearbuf(A5)    ;Nachher Tastaturpuffer löschen
                movea.l A4,A6
                bsr     clrEOFLF        ;Lösche EOF/LF-Flags und korr. Datei
                tst.b   DUMPflag(A5)
                beq.s   bpnodump
                move.l  A6,filpos1(A5)  ;Für updateln
                move.w  v_cel_w_1(A5),D4 ;Bildbreite (DBF) falls DUMP
bpnodump:       bsr.s   bptitle
                movea.l screen(A5),A0
                moveq   #14,D0          ;Selbst berechnet
                mulu    v_planes(A5),D0
                adda.w  D0,A0
                move.l  A0,alnatpos(A5)
                moveq   #0,D3           ;Unsigned Extend
                bra.s   bpnl1
bpnl:           addq.l  #1,nowline(A5)
bpcont:         bsr     testkey         ;Abbruch manuell?
                cmp.w   #ESC,D0         ;<ESC>?
                beq.s   prtrest
bpnl1:          bsr     updateln
bpnc:           move.b  (A6)+,D3
                bne.s   bpN0            ;Ende des Dokuments?
                cmpa.l  filend(A5),A6
                bhi.s   prtrest
bpN0:           bsr     prttranschar    ;Kehrt bei Benutzerabbruch nicht zurück
                tst.b   DUMPflag(A5)
                bne.s   bpDUMPln
                cmp.w   #LF,D3
                beq.s   bpnl
                bra.s   bpnc

bpDUMPln:       move.l  A6,filpos1(A5)  ;Für updateln
                dbra    D4,bpnc
                move.w  v_cel_w_1(A5),D4
                bra.s   bpcont

prtrest:        bsr     exitprinter
                bra.s   prtrest1

prtlongjmp:     lea     stack(A5),A7    ;Harter Restore from Subprogram
prtrest1:       move.l  savnowln(A5),nowline(A5) ;Restore Variables ...
                move.l  savfpos1(A5),filpos1(A5)
                bsr     setEOFLF        ;Und setze die gelöschten Flags wieder
                bra     redraw          ;... and redraw Screen


prtchar:        move.w  D3,-(A7)        ;Sichern (für Bconout schon auf Stack)

prtagain:       bsr.s   checkprt        ;Reagiert der Drucker?
                bne.s   prtchar1        ;Ja, ausgeben
                bsr.s   get_hz_200      ;Nein, 5 Sekunden auf den Drucker
                move.l  #PRN_TIMEOUT,D3 ;warten
                add.l   D0,D3
prttstl:        bsr.s   checkprt
                bne.s   prtchar1        ;Drucker ist bereit
                bsr.s   get_hz_200
                cmp.l   D0,D3           ;Timeout?
                bcc.s   prttstl         ;Nein, nochmals versuchen
                bsr.s   prtair          ;Printer Error: Abort, Ignore, Retry?
                beq.s   prtlongjmp      ;Beendet... (enfernt Rücksprung)
                bra.s   prtagain        ;Ist er jetzt bereit?
prtchar1:                               ;Zeichen schon auf Stack
                clr.w   -(A7)           ;Device: PRT:
                move.w  #3,-(A7)        ;Ausgabe
                trap    #13
                addq.l  #4,A7
                tst.l   D0              ;Drucker reagierte nicht...
                bne.s   prtchret
                bsr.s   prtair
                beq.s   prtlongjmp
                bra.s   prtagain
prtchret:       move.w  (A7)+,D3
                rts

prtmsg:         lea     prtretry(A5),A4
                bsr     message
                bsr.s   get_hz_200
                add.l   #PRN_UNTIMEOUT,D0 ;20 Sekunden Timeout
                move.l  D0,kbdtimeout(A5)
                bsr     getukey
                rts

prtair:         bsr.s   prtmsg
                move.l  D0,-(A7)
                bsr     bptitle         ;Titel wieder darstellen
                bsr     updateln
                move.l  (A7)+,D0
                cmp.w   #ESC,D0         ;Falls Taste=<ESC>, liefere EQUAL zurück
                rts


checkprt:       clr.w   -(A7)           ;Device: PRT:
                move.w  #8,-(A7)        ;Ausgabe möglich?
                trap    #13
                addq.l  #4,A7
                tst.l   D0
                rts

                ENDPART
get_hz_200:     >PART
                pea     __get200(PC)
                move.w  #38,-(A7)
                trap    #14             ;Supexec()
                addq.l  #6,A7
                rts

__get200:       move.l  _hz_200.w,D0
                rts

                ENDPART
formfeed:       >PART
                move.w  #-1,-(A7)       ;Holen
                move.w  #11,-(A7)       ;Kbshift()
                trap    #13
                addq.l  #4,A7
                and.w   #1<<(Control-24),D0 ;Ist Control gedrückt?
                bne.s   formfeed        ;Ja, warten

                bsr.s   checkprt        ;Drucker bereit?
                bne.s   formfeed1       ;Ja, Zeichen ausgeben
                bsr.s   prtmsg          ;Nein, Mitteilung ausgeben
                cmp.w   #ESC,D0         ;[ESC] gedrückt?
                bne.s   formfeed        ;Nein, Drucker nochmals testen
                bra.s   redrawtop       ;Ja, zurück

formfeed1:      move.w  #FF,-(A7)       ;<FF> senden
                clr.w   -(A7)           ;Device: PRT:
                move.w  #3,-(A7)        ;Ausgabe
                trap    #13             ;Falls jetzt ein Fehler passiert, ist
                addq.l  #6,A7           ;... es mir egal, der Benutzer merkt's
redrawtop:      bsr     makeinfo
                bra     mainloop
                ENDPART

initprinter:    >PART
                lea     printercfg(A5),A3
                tst.b   (A3)            ;Name leer?
                beq.s   ip_ret          ;Ja -> nichts tun
                tst.l   cfgmem(A5)      ;Druckertreiber schon geladen?
                bne.s   ip_init         ;Ja ->

                move.l  #CFG_MAXSIZE,D4 ;Grösse
                move.l  D4,D3
                bsr     malloc          ;Hole Speicher
                move.l  D0,cfgmem(A5)   ;Sichern und testen
                beq.s   ip_mallocerr    ;Kein Speicher -> Fehler
                movea.l D0,A4

                clr.w   -(A7)           ;Datei einlesen
                pea     (A3)            ;Dieser Name
                move.w  #$3D,-(A7)      ;Fopen()
                trap    #1
                addq.l  #8,A7
                move.l  D0,D3           ;Handle retten und testen
                bmi.s   ip_openerr

                move.l  A4,-(A7)        ;Bufferadresse
                move.l  D4,-(A7)        ;Count
                move.w  D3,-(A7)        ;Handle
                move.w  #$3F,-(A7)      ;Fread()
                trap    #1
                lea     12(A7),A7

                move.l  D0,D7           ;Sichern
                bsr     close           ;Datei schliessen
                tst.l   D7              ;Fehler?
                bmi.s   ip_readerr      ;Ja ->
                cmp.l   D7,D4           ;Eingelesene Bytes = angeforderte Bytes?
                beq.s   ip_bigerr       ;Ja, zu gross ->
                clr.b   1(A4,D7.l)      ;Mit einem Nullbyte abschliessen

                bsr.s   ip_getpointer
                tst.l   cfgptr2(A5)     ;Zeiger gültig?
                beq.s   ip_badformat    ;Nein ->
                bra.s   ip_init2
ip_init:        bsr.s   ip_getpointer   ;Zeiger holen, ohne Test
ip_init2:       moveq   #CFG_INIT,D0    ;Diese Sequenz suchen
                bsr     exitprinter2    ;und zum Drucker schicken
ip_ret:         rts


ip_mallocerr:   lea     errnomem(A5),A4
                bsr     messagek
                bra     prtlongjmp      ;Aktion abbrechen

ip_badformat:   pea     errbadformat(A5) ;" falsches Format!"
                bra.s   ip_errmsg2
ip_bigerr:      pea     errtoobig(A5)   ;" zu gross!"
ip_errmsg2:     bsr     startinf
                lea     errcfg(A5),A4   ;"Druckertreiber "
                bra.s   ip_errmsg0

ip_readerr:     pea     errread(A5)     ;" nicht lesen!"
                bra.s   ip_errmsg1
ip_openerr:     pea     errfound(A5)    ;" nicht finden!"
ip_errmsg1:     bsr     startinf
                lea     errcancfg(A5),A4
ip_errmsg0:     bsr     tnirp           ;"Kann Druckertreiber "
                lea     printercfg(A5),A4
                bsr     tnirp           ;Dateiname
                movea.l (A7)+,A4
                bsr     message0

                movea.l cfgmem(A5),A0   ;Magic löschen
                clr.l   (A0)
                bra     prtlongjmp

ip_getpointer:  movea.l cfgmem(A5),A1   ;Hole Blockadresse
                cmpi.l  #CFG_MAGIC1,(A1)+ ;Magic ok?
                bne.s   ip_gp_ret
                cmpi.l  #CFG_MAGIC2,(A1)
                bne.s   ip_gp_ret
ip_gp_l1:       tst.b   (A1)+           ;Suche Stringende
                bne.s   ip_gp_l1
                addq.l  #CFG_CONST,A1
                movea.l A1,A0           ;Speichern
                moveq   #0,D0           ;Für unsgined Extend
ip_gp_loop:     adda.w  D0,A1           ;Zum nächsten Eintrag (1. Mal ein NOP)
                move.b  (A1),D0
                bne.s   ip_gp_loop      ;Ende gefunden? Nein ->
                addq.l  #1,A1           ;A1 zeigt auf Anfang des zweiten Blocks
                movem.l A0-A1,cfgptr1(A5) ;Beide Pointer setzen
ip_gp_ret:      rts

                ENDPART
exitprinter:    >PART
                moveq   #CFG_EXIT,D0    ;Diese Sequenz suchen
exitprinter2:   movea.l cfgptr1(A5),A0  ;In diesem Buffer suchen
                bsr.s   pt_find2
                moveq   #0,D0           ;Unsigned Extend
                move.b  (A0),D0
                addq.l  #2,A0           ;Zum eigentlichen zu sendenden String
                subq.w  #3,D0           ;Korrigieren (Länge, Zeichen, DBF)
                bcc.s   pt_out          ;Initsequenz leer oder nicht da? Nein ->
ep_ret:         rts

                ENDPART
prttranschar:   >PART
                move.w  D3,D0           ;Zu suchendes Zeichen
                bsr.s   pt_find         ;Suchen
                moveq   #0,D0
                move.b  (A0),D0         ;Hole Stringlänge
                beq.s   braprtchar      ;0: Zeichen direkt ausgeben (noch in D3)
                addq.l  #2,A0
                subq.w  #2,D0
                beq.s   pt_spc          ;Leer definiert: Leerzeichen ausgeben
                subq.w  #1,D0           ;DBF-Vorbereitung
pt_out:
pt_loop:        moveq   #0,D3
                move.b  (A0)+,D3
                move.l  A0,-(A7)        ;Register sichern
                move.w  D0,-(A7)
                bsr.s   braprtchar      ;Zeichen ausgeben
                move.w  (A7)+,D0        ;Register zurückholen
                movea.l (A7)+,A0
                dbra    D0,pt_loop
                rts

pt_spc:         moveq   #" ",D3
braprtchar:     bra     prtchar

; Eingabe: Zeichen in D0, Zeiger auf Tabelle in A0
; Ausgabe: Zeiger auf zu Übersetzung in A0 (zeigt auf 0, falls nicht gefunden)
pt_find:        movea.l cfgptr2(A5),A0
pt_find2:       move.l  A0,D1           ;NULL-Pointer?
                beq.s   pt_f_zero       ;Ja -> Zeiger auf 0 zurückgeben
                moveq   #0,D1           ;Unsigned Extend
pt_f_loop:      adda.w  D1,A0           ;+Länge
                move.b  (A0),D1         ;Hole Länge
                beq.s   pt_f_ret        ;0 (Ende)? Ja ->
                cmp.b   1(A0),D0        ;Zu übersetzendes Zeichen gefunden?
                bne.s   pt_f_loop
pt_f_ret:       rts

pt_f_zero:      lea     zero(A5),A0     ;"Nicht gefunden" simulieren
                rts

                ENDPART

********************************************************************************
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
********************************************************************************

initcons:       >PART
                move.b  conterm.w,consav ;Nicht A5-relativ, da im Supexec()
                bset    #3,conterm.w    ;Kbshift in 24-31

                moveq   #15,D0          ;aktuelle Palette sichern
                lea     rgb0.w,A0
                lea     colorsav(PC),A1 ;A5 nicht möglich
icloop:         move.w  (A0)+,D1
                and.w   #$0FFF,D1       ;Unwichtige Bits ausmaskieren
                move.w  D1,(A1)+        ;Maske ist wegen STE $0FFF
                dbra    D0,icloop
                rts

                ENDPART
exitcons:       move.b  consav(PC),conterm.w ;A5 nicht möglich
                lea     colorsav(PC),A0
                move.l  A0,paletteptr   ;Fällt durch!
setcolor:       >PART
                moveq   #15,D0          ;aktuelle Palette sichern
                lea     rgb0.w,A0
                movea.l paletteptr(PC),A1 ;A5 nicht möglich
scloop:         move.w  (A1)+,(A0)+
                dbra    D0,scloop
                rts
                ENDPART
invscren:       >PART
                lea     rgb0.w,A0
                moveq   #15,D0          ;16 Farben
invscren1:      not.w   (A0)+           ;invertieren
                dbra    D0,invscren1
                rts
                ENDPART
getinit:        >PART 'Initialisierungen'
                linea   #0 [ Init ]     ;LINE-A: Get Parameters
                move.l  A0,lineaptr(A5)
                move.l  V_FNT_AD(A0),fontadr(A5) ;Adresse der Fontdaten

                move.w  V_PLANES(A0),D0 ;Anzahl Planes
                move.w  D0,v_planes(A5)
                subq.w  #1,D0
                move.w  D0,v_planes_1(A5)
                addq.w  #1,D0
                add.w   D0,D0           ;*2
                move.w  D0,v_planes__2(A5)

                move.w  V_CEL_HT(A0),D0 ;Höhe eines Zeichens
                move.w  D0,v_cel_ht(A5)
                move.w  D0,D1           ;MATRIX: Berechnung von V_CEL_WR
                subq.w  #1,D0
                move.w  D0,v_cel_ht_1(A5)

                move.w  V_CEL_MX(A0),D0 ;Breite in Zeichenpositionen-1
                move.w  D0,v_cel_w_1(A5)
                addq.w  #1,D0
                move.w  D0,v_cel_w(A5)
                move.b  D0,maxcol(A5)   ;Auch maxpos setzen

                move.w  V_CEL_MY(A0),D0 ;Höhe in Zeichenpositionen-1
                move.w  D0,v_cel_h_1(A5)
                addq.w  #1,D0
                move.w  D0,v_cel_h(A5)
                move.b  D0,maxlin(A5)   ;Auch maxpos setzen

                move.w  BYTES_LIN(A0),D0 ;Höhe in Zeichenpositionen
                move.w  D0,bytes_lin(A5)
                mulu    D0,D1           ;MATRIX: Berechnung von V_CEL_WR
                subq.w  #1,D0
                move.w  D0,bytes_lin_1(A5)

                move.w  D1,v_cel_wr(A5) ;MATRIX: Berechnung von V_CEL_WR
;move.w V_CEL_WR(A0),D0 ;[V_CEL_HT]*[BYTES_LIN]
;move.w D0,v_cel_wr(A5)

                move.w  #3,-(A7)        ;Logbase
                trap    #14
                addq.l  #2,A7
                move.l  D0,screen(A5)
                move.l  D0,cursor(A5)   ;Position des Cursors

                clr.w   -(A7)           ;System-Cursor ausschalten
                move.w  #21,-(A7)       ;cursconf
                trap    #14
                addq.l  #4,A7

                move.w  #1,-(A7)        ;Keyboard-
                move.w  #14,-(A7)       ;Iorec
                trap    #14
                addq.l  #4,A7
                move.l  D0,ioreck(A5)
                rts

                ENDPART
scrollup:       >PART 'Aufwärtsscrollen'
                movea.l screen(A5),A1
                movea.l A1,A2           ;Zwischenspeichern
                move.w  v_cel_wr(A5),D0
                adda.w  D0,A1
                move.w  maxpos(A5),D1   ;Letzte Zeile, letzte Spalte
                clr.b   D1              ;Letzte Zeile, erste Spalte
                move.w  D1,crspos(A5)   ;Position speichern
                movea.l A1,A0
                adda.w  D0,A1           ;Hier ist es A1!
                suba.w  D0,A2           ;A2 = screen - v_cel_wr * (v_cel_h - 2)
                moveq   #0,D1
                move.w  D0,D1
                mulu    v_cel_h_1(A5),D0
                sub.l   D1,D0
                suba.w  D1,A2           ;- v_cel_wr
                move.l  A2,cursor(A5)   ;Aktuelle Position: unterste Zeile
                bra.s   memmove

                ENDPART
scrolldn:       >PART 'Abwärtsscrollen' ;Fällt durch!
                movea.l screen(A5),A1
                move.w  v_cel_wr(A5),D0
                adda.w  D0,A1
                move.l  A1,cursor(A5)   ;ist gleich aktuelle Schreibzeile
                move.w  #$0100,crspos(A5) ;Zeile 1, Spalte 0
                movea.l A1,A0
                adda.w  D0,A0
                move.w  v_cel_h(A5),D1
                subq.w  #2,D1
                mulu    D1,D0
;Fällt durch!
                ENDPART
                >PART 'memmove'
;IN: D0.L: Länge, A0.L: Dest, A1.L: Src

memmove:        tst.l   D0              ;Blocklänge 0?
                beq     mem_ret
                cmpa.l  A0,A1           ;Welche Adresse kommt vorher?
                bhi     mem_vorw        ;Vorwärts kopieren
                beq     mem_ret         ;Gleich? Nicht kopieren!

                adda.l  D0,A1           ;Von hinten her kopieren:
                adda.l  D0,A0           ;Endadressen berechnen
                move.w  A1,D1
                move.w  A0,D2
                btst    #0,D1           ;Dest gerade?
                beq.s   mem_dsteven     ;Ja -> weiter im Entscheidungsbaum
                btst    #0,D2           ;Src gerade?
                bne.s   mem_bothodd     ;Nein ->

mem_evodd:      move.b  -(A1),-(A0)     ;Kopiere Byteweise rückwärts
                subq.l  #1,D0           ;So langsam wie möglich... :-)
                bne.s   mem_evodd
                bra     mem_ret

mem_dsteven:    btst    #0,D2           ;Src auch ungerade?
                bne.s   mem_evodd       ;Nein -> Byteweise kopieren
                bra.s   mem_even

mem_bothodd:    move.b  -(A1),-(A0)     ;Beide ungerade: Zuerst ein Byte
                subq.l  #1,D0           ;kopieren, dann wortweise weiterkopieren
                beq     mem_ret         ;(falls mehr als ein Byte zu kopieren)

mem_even:       move.l  D0,D1
                lsr.l   #5,D1
                lsr.l   #4,D1           ;D1 = Länge / 512
                beq.s   mem_longs       ;weniger als 512
                movem.l D0/D2-D7/A2-A6,-(A7) ;Alle Register sichern
                move.l  D1,-(A7)

mem_v512:       movem.l -$34(A1),D0-D7/A2-A6 ;Und jetzt so richtig zuschlagen!
                movem.l D0-D7/A2-A6,-(A0) ;52 Bytes aufs Mal
                movem.l -$68(A1),D0-D7/A2-A6
                movem.l D0-D7/A2-A6,-(A0)
                movem.l -$9C(A1),D0-D7/A2-A6
                movem.l D0-D7/A2-A6,-(A0)
                movem.l -$D0(A1),D0-D7/A2-A6
                movem.l D0-D7/A2-A6,-(A0)
                movem.l -$0104(A1),D0-D7/A2-A6
                movem.l D0-D7/A2-A6,-(A0)
                movem.l -$0138(A1),D0-D7/A2-A6
                movem.l D0-D7/A2-A6,-(A0)
                movem.l -$016C(A1),D0-D7/A2-A6
                movem.l D0-D7/A2-A6,-(A0)
                movem.l -$01A0(A1),D0-D7/A2-A6
                movem.l D0-D7/A2-A6,-(A0)
                movem.l -$01D4(A1),D0-D7/A2-A6
                movem.l D0-D7/A2-A6,-(A0)
                lea     -$0200(A1),A1   ;512 Bytes zurück
                movem.l (A1),D2-D7/A2-A6 ;Offset jetzt 0, da suba.w schon vorher
                movem.l D2-D7/A2-A6,-(A0) ;Diesmal nur noch 44 Bytes
                subq.l  #1,(A7)         ;1x mehr kopiert
                bne.s   mem_v512        ;noch mehr kopieren
                addq.l  #4,A7           ;"D1" wieder vom Stack werfen
                movem.l (A7)+,D0/D2-D7/A2-A6 ;Alle Register wieder zurück

mem_longs:      move.w  D0,D1
                and.w   #$01FF,D0       ;Rest (ohne 512er-Blöcke)
                lsr.w   #2,D0           ;/4
                beq.s   mem_bytes       ;Keine Longwords zu verschieben?
                subq.w  #1,D0           ;Für DBF
mem_lloop:      move.l  -(A1),-(A0)     ;Langwort kopieren
                dbra    D0,mem_lloop

mem_bytes:      and.w   #$03,D1         ;Noch einzelne Bytes?
                beq     mem_ret
                subq.w  #1,D1
mem_bloop:      move.b  -(A1),-(A0)
                dbra    D1,mem_bloop
                bra     mem_ret


mem_vorw:       move.w  A1,D1           ;Dasselbe nochmals in grün
                move.w  A0,D2
                btst    #0,D1
                beq.s   mem_vdeven
                btst    #0,D2
                bne.s   mem_vboth

mem_vodd:       move.b  (A1)+,(A0)+
                subq.l  #1,D0
                bne.s   mem_vodd
                bra     mem_ret

mem_vdeven:     btst    #0,D2
                bne.s   mem_vodd
                bra.s   mem_veven

mem_vboth:      move.b  (A1)+,(A0)+
                subq.l  #1,D0

mem_veven:      move.l  D0,D1
                lsr.l   #5,D1
                lsr.l   #4,D1
                beq.s   mem_vlongs

                movem.l D0/D2-D7/A2-A6,-(A7)
                move.l  D1,-(A7)
mem_vv512:      movem.l (A1)+,D0-D7/A2-A6 ;52 Bytes aufs Mal
                movem.l D0-D7/A2-A6,(A0)
                movem.l (A1)+,D0-D7/A2-A6
                movem.l D0-D7/A2-A6,52(A0)
                movem.l (A1)+,D0-D7/A2-A6
                movem.l D0-D7/A2-A6,104(A0)
                movem.l (A1)+,D0-D7/A2-A6
                movem.l D0-D7/A2-A6,156(A0)
                movem.l (A1)+,D0-D7/A2-A6
                movem.l D0-D7/A2-A6,208(A0)
                movem.l (A1)+,D0-D7/A2-A6
                movem.l D0-D7/A2-A6,260(A0)
                movem.l (A1)+,D0-D7/A2-A6
                movem.l D0-D7/A2-A6,312(A0)
                movem.l (A1)+,D0-D7/A2-A6
                movem.l D0-D7/A2-A6,364(A0)
                movem.l (A1)+,D0-D7/A2-A6
                movem.l D0-D7/A2-A6,416(A0)
                movem.l (A1)+,D2-D7/A2-A6 ;Nur noch 44 Bytes
                movem.l D2-D7/A2-A6,468(A0)

                lea     $0200(A0),A0
                subq.l  #1,(A7)
                bne.s   mem_vv512
                addq.l  #4,A7           ;"D1" vom Stack
                movem.l (A7)+,D0/D2-D7/A2-A6

mem_vlongs:     move.w  D0,D1
                and.w   #$01FF,D0
                lsr.w   #2,D0
                beq.s   mem_vbytes
                subq.w  #1,D0
mem_vlloop:     move.l  (A1)+,(A0)+
                dbra    D0,mem_vlloop

mem_vbytes:     and.w   #$03,D1
                beq.s   mem_ret
                subq.w  #1,D1
mem_vbloop:     move.b  (A1)+,(A0)+
                dbra    D1,mem_vbloop
mem_ret:        rts

                ENDPART
                >PART 'Bildschirm invertieren'
invertp:        bsr.s   _invert
                bra     picmloop

invertt:        pea     mainloop(PC)

_invert:        move.w  #37,-(A7)       ;Vsync()
                trap    #14
                addq.l  #2,A7

                pea     invscren(A5)    ;Negiert aktuelle Farbe 0
                move.w  #38,-(A7)
                trap    #14
                addq.l  #6,A7

                not.b   INVERTflag
                rts

                ENDPART
save:           >PART 'Degasbild speichern'
                sf      forcesave
                bra.s   save_do
save1:          st      forcesave
save_do:        moveq   #15,D1          ;16 Words kopieren
                lea     pi3col(A5),A1   ;Destination
                move.l  paletteptr(A5),D0
                movea.l D0,A0           ;Ändert CCR nicht
                bne.s   ssetpal         ;Keine eigene Palette?
                lea     colorsav(A5),A0 ;dann Standardpalette nehmen
ssetpal:        move.w  (A0)+,(A1)+     ;Palette kopieren
                dbra    D1,ssetpal

                movea.l fnameadr(A5),A0
                lea     savename(A5),A1
                movea.l A1,A4
                moveq   #'\',D1
sgetslash:      move.b  (A0)+,D0        ;Zeichen speichern und kopieren
                move.b  D0,(A1)+
                beq.s   sgotslash       ;Stringende? Ja =>
                cmp.b   D0,D1
                bne.s   sgetslash       ;Backslash gefunden? Ja =>
                movea.l A1,A4           ;Position speichern
                bra.s   sgetslash
sgotslash:      moveq   #'.',D1
sgetdot:        move.b  (A4)+,D0        ;Suche Stringende ...
                beq.s   sgotdot
                cmp.b   D0,D1           ;... oder Punkt der Extension
                bne.s   sgetdot
sgotdot:        move.b  D0,-1(A4)       ;Setze Punkt

                move.w  v_planes(A5),D0
                cmpi.w  #4,D0           ;Maximal 4 Planes?
                bhi     badreso         ;Nein -> "Nicht in dieser Auflösung"

                move.b  pi123-1(A5,D0.w),D0 ;D0[8:15] ist sicher 0 (wegen cmp #4)
                move.w  D0,pi3head(A5)  ;setze Auflösung
                move.w  D0,D1           ;Speichern
                move.b  #'P',(A4)+      ;"PIx",0 einsetzen
                move.b  #'I',(A4)+
                add.b   #'1',D0
                move.b  D0,(A4)+
                clr.b   (A4)

                add.w   D1,D1           ;*2
                move.w  pi123x(A5,D1.w),D0 ;Teste Auflösung
                cmp.w   vdi_w(A5),D0
                bne     badreso
                move.w  pi123y(A5,D1.w),D0
                cmp.w   vdi_h(A5),D0
                bne     badreso

                tst.b   forcesave
                bne.s   savecont        ;Immer sichern? Ja =>

                move.w  #$17,-(A7)      ;Alles, auch Ordner/Hidden gesucht
                pea     savename(A5)
                move.w  #$4E,-(A7)      ;Fsfirst()
                trap    #1
                addq.l  #8,A7

                moveq   #-33,D1         ;"Datei nicht gefunden"?
                cmp.l   D0,D1
                bne.s   saveerr3        ;Existiert schon oder Fehler =>

savecont:       clr.w   -(A7)           ;Normale Datei
                pea     savename(A5)    ;Dateiname
                move.w  #$3C,-(A7)      ;Fcreate()
                trap    #1
                addq.l  #8,A7
                move.l  D0,D3           ;Handle testen und sichern
                bmi.s   saveerr2

                pea     pi3head(A5)     ;Kennung und Palette schreiben
                moveq   #34,D4
                move.l  D4,-(A7)        ;34 Bytes Header
                move.w  D3,-(A7)        ;Handle
                move.w  #$40,-(A7)      ;Fwrite()
                trap    #1
                lea     12(A7),A7
                tst.l   D0              ;Harter Fehler: sofort abbrechen!
                bmi.s   saveerr2
                cmp.l   D0,D4           ;Disk voll?
                bne.s   saveerr

                move.l  screen(A5),-(A7) ;Bildadresse
                move.l  #DOOsize,D4     ;Bildgrösse
                move.l  D4,-(A7)
                move.w  D3,-(A7)        ;Handle
                move.w  #$40,-(A7)      ;Fwrite
                trap    #1
                lea     12(A7),A7
                tst.l   D0              ;Harter Fehler: sofort abbrechen!
                bmi.s   saveerr2
                cmp.l   D0,D4           ;Disk voll?
                bne.s   saveerr

                bsr.s   saveclos        ;Datei schliessen
                bmi.s   saveerr2        ;Fehler?
                bra     picmloop

saveerr:        bsr.s   saveclos        ;Datei schliessen
                bmi.s   saveerr2        ;Dann auch nicht löschen

                pea     savename(A5)    ;Dateiname
                move.w  #$41,-(A7)      ;Fdelete()
                trap    #1              ;Noch löschen, da sonst ein Dateirest
                addq.l  #6,A7           ;übrig bleibt.

saveerr2:       bsr     messagef
                bra     disppic

saveerr3:       bsr     messagee        ;"Existiert bereits!"
                bra     disppic

saveclos:       move.w  D3,-(A7)        ;Handle
                move.w  #$3E,-(A7)      ;Fclose()
                trap    #1
                addq.l  #4,A7
                tst.l   D0              ;Fehler? (z.B. Disk nicht im Laufwerk)
                rts

badreso:        lea     errreso(A5),A4  ;"In dieser Auflösung nicht möglich"
                bsr     messagek        ;"Taste drücken"
                bra     disppic

                ENDPART

********************************************************************************
*                            Anzeige von Bildern                               *
********************************************************************************

chktype:        >PART 'Bildformat feststellen'
                lea     filext+3(A5),A0
                movea.l fnameadr(A5),A3 ;Command Line
ctseocl:        tst.b   (A3)+           ;ChkType: Seek End of Command Line
                bne.s   ctseocl
                subq.l  #2,A3           ;Gehe an Beginn der Extension
                move.b  (A3),(A0)       ;Stelle Extension zusammen
                move.b  -(A3),-(A0)
                move.b  -(A3),-(A0)
                move.b  -(A3),-(A0)
                move.l  (A0),D6         ;Hole sie in den Vergleichsbuffer

                lea     picext(A5),A0
                lea     piclen(A5),A1
                lea     picadr(A5),A2
                lea     picreso(A5),A3
                moveq   #0,D1           ;Unsigned Extend
                move.l  d_len(A5),D4
ctloop:         move.l  (A0)+,D0
                move.w  (A1)+,D1
                move.l  (A2)+,D2
                move.w  (A3)+,D3
                beq.s   ctend           ;Ende der Liste erreicht
                cmp.l   D0,D6
                bne.s   ctloop
                and.w   v_planes(A5),D3 ;Bildformat für diese Anzahl Planes
                beq.s   ctloop          ;... möglich? Nein ->
                tst.l   D1
                beq.s   ctend
                cmp.l   D1,D4
                bne.s   ctloop
ctend:          move.l  D2,pictype(A5)
                bne.s   ctrts           ;Schon etwas gefunden?

                move.l  #stadmag1,D0    ;Sehr uneinheitliche Extension,
                movea.l filstrt(A5),A0  ;deshalb Extrawurst für STAD
                cmp.l   (A0),D0         ;Magic #1?
                beq.s   ctstad
                addq.l  #stadmag2-stadmag1,D0
                cmp.l   (A0),D0         ;Magic #2? (= Magic#1 + 1)
                bne.s   ctrts
ctstad:         lea     picpac(A5),A0
                move.l  A0,pictype(A5)
ctrts:          rts

                ENDPART

********************************************************************************

pichelp:        >PART 'Hilfe für Bilder' ;Fällt durch!
                lea     INVERTflag(A5),A0
                lea     htIp+1(A5),A1
                bsr     helpchk1        ;Haken setzen/löschen

                bsr     saveflag        ;Zwischenspeichern
                bsr     helptitl        ;Titel
                lea     hilfpic1(A5),A4 ;Hilfstext anzeigen
                bsr     print
                lea     hilfterm(A5),A4 ;Möglichkeiten zum Programmende
                bsr     helpbot
                bsr     restflag        ;Flags wieder holen (für Textmodus)
;                                        Fällt durch!
                ENDPART
disppic:        >PART 'Irgendein Bild anzeigen'
                st      beenhere(A5)
                bsr     clrEOFLF
                bsr     v_clrwk
                tst.w   vdihndl(A5)     ;Workstation da?
                bne.s   disppic1
                lea     errnovdi(A5),A4 ;"Keine VDI-Workstation!"
                bsr     messagek
                bra     disptext

disppic1:       movea.l pictype(A5),A0
                movea.l filstrt(A5),A1
                move.l  A0,D0
                beq.s   picunknown      ;Kein Bildformat festgestellt
                jmp     (A0)
                ENDPART
picunknown:     >PART 'Unbekanntes Bildformat'
                move.l  d_len(A5),D0
                divu    #80,D0          ;Konstante Breite von 80 Bytes
                move.w  D0,fd_h(A5)
                move.w  #640,fd_w(A5)
                move.w  #1,fd_nplanes(A5)
                move.l  filstrt(A5),fd_addr(A5)
                bra     pic_disp
                ENDPART

                >PART 'Degas-Dekompression'
picpc3:         btst    #7,(A1)+        ;Von Raymond Stofer
                beq     badpicf
                cmpi.b  #2,(A1)+
                bne     badpicf
                lea     32(A1),A1
                bsr     malloc32000
                beq     picnomem
                movea.l D0,A0           ;Speicher
picpc3_1:       movea.l A0,A2
                move.w  #399,D0
                moveq   #1,D4
                moveq   #1,D5
dec_pc3_1:      moveq   #79,D1
                bsr     dec_plane
                dbra    D0,dec_pc3_1
                movea.l picmem1(A5),A1
                bra     picpic          ;Bild anzeigen

picpc2:         btst    #7,(A1)+
                beq     badpicf
                cmpi.b  #1,(A1)+
                bne     badpicf
                bsr     malloc32000
                beq     picnomem
                movea.l D0,A0
                cmpi.w  #2,v_planes(A5) ;Mittlere Auflösung?
                beq.s   picpc2_1        ;Nein -> primitive Umwandlung
                lea     32(A1),A1
                bra.s   picpc3_1
picpc2_1:       move.l  A1,paletteptr(A5) ;Palette speichern
                lea     32(A1),A1
                move.w  #199,D0
                moveq   #1,D4
                moveq   #3,D5
dec_pc2_1:      lea     (A0),A2
                moveq   #79,D1
                bsr.s   dec_plane
                lea     2(A0),A2
                moveq   #79,D1
                bsr.s   dec_plane
                lea     160(A0),A0
                dbra    D0,dec_pc2_1
                move.l  picmem1(A5),fd_addr(A5) ;MFDB füllen
picmedres:      move.w  #640,fd_w(A5)
                move.w  #200,fd_h(A5)
                move.w  #2,fd_nplanes(A5)
                bra     pic_disp

picpc1:         btst    #7,(A1)+
                beq     badpicf
                tst.b   (A1)+
                bne     badpicf
                bsr     malloc32000
                beq     picnomem
                movea.l D0,A0
                lea     32(A1),A1
                move.w  #199,D0
                moveq   #1,D4
                moveq   #7,D5
dec_pc1_1:      lea     (A0),A2
                bsr.s   dec_plane0
                lea     2(A0),A2
                bsr.s   dec_plane0
                lea     4(A0),A2
                bsr.s   dec_plane0
                lea     6(A0),A2
                bsr.s   dec_plane0
                lea     160(A0),A0
                dbra    D0,dec_pc1_1
                movea.l picmem1(A5),A0  ;Bilddaten
                movea.l filstrt(A5),A1  ;Farbtabelle
                addq.l  #2,A1
                bra     piclowres

dec_plane0:     moveq   #39,D1
dec_plane:      moveq   #0,D2
                move.b  (A1)+,D2
                blt.s   dec_plane2
                sub.b   D2,D1
                bcs.s   dec_ret         ;Sollte nie vorkommen...
dec_plane1:     move.b  (A1)+,(A2)
                adda.w  D4,A2
                exg     D4,D5
                dbra    D2,dec_plane1
                dbra    D1,dec_plane
dec_ret:        rts

dec_plane2:     neg.b   D2
                move.b  (A1)+,D3
                sub.b   D2,D1
                bcs.s   dec_ret         ;Sollte nie vorkommen...
dec_plane3:     move.b  D3,(A2)
                adda.w  D4,A2
                exg     D4,D5
                dbra    D2,dec_plane3
                dbra    D1,dec_plane
                rts
                ENDPART
                >PART 'Monochrome Bilder' ;Fällt durch!
picpi3:         cmpi.w  #2,(A1)+        ;High Resolution?
                bne     badpicf
                lea     32(A1),A1

picpic:         move.l  A1,fd_addr(A5)  ;Bildadresse
                move.w  #640,fd_w(A5)   ;Bildbreite/-höhe
                move.w  #400,fd_h(A5)
                move.w  #1,fd_nplanes(A5) ;Planes ;fällt durch!
                ENDPART
pic_disp:       >PART 'Bild auf den Schirm bringen' ;Fällt durch!
                move.w  fd_w(A5),D0
                add.w   #15,D0          ;Aufrunden
                lsr.w   #4,D0           ;In Words verwandeln
                move.w  D0,fd_wdwidth(A5)
                clr.w   fd_stand(A5)    ;Nicht Standardformat

                bsr     calccoor        ;Mauskoordinaten -> Bildkoordinaten

                lea     ptsin(A5),A0    ;ptsin[] füllen
                move.w  vdi_w(A5),D0
                move.w  fd_w(A5),D1
                cmp.w   D0,D1           ;Bildbreite < Schirmbreite
                bcs.s   pic_disp1       ;D1 kleiner?
                move.w  D0,D1           ;Nein, D0 dorthin
pic_disp1:      subq.w  #1,D1
                bcs     picmloop        ;Zu klein -> nichts darstellen
                move.w  vdi_h(A5),D0
                move.w  fd_h(A5),D2
                cmp.w   D0,D2           ;Bildbreite < Schirmbreite
                bcs.s   pic_disp2       ;D1 kleiner?
                move.w  D0,D2           ;Nein, D0 dorthin
pic_disp2:      subq.w  #1,D2
                bcs.s   picmloop        ;Zu klein -> nichts darstellen

                move.w  piccurx(A5),D0  ;srcx1
                move.w  D0,(A0)+
                move.w  piccury(A5),D3  ;srcy1
                move.w  D3,(A0)+
                add.w   D1,D0
                move.w  D0,(A0)+        ;srcx2
                add.w   D2,D3
                move.w  D3,(A0)+        ;srcy2
                clr.l   (A0)+           ;dstx1, dsty1
                move.w  D1,(A0)+        ;dstx2
                move.w  D2,(A0)+        ;dsty2

                lea     contrl(A5),A0
                move.l  #(109<<16)+4,(A0)+ ;vro_cpyfm, 4 ptsin
                moveq   #1,D0
                move.l  D0,(A0)+        ;0 ptsout, 1 intin
                move.l  D0,(A0)+        ;0 intout, unused
                move.w  vdihndl(A5),(A0)+ ;handle
                move.l  #picmfdb,(A0)+  ;MFDBs einfüllen
                move.l  #screenmfdb,(A0)+

                tst.l   paletteptr(A5)  ;Muss die Palette gesetzt werden?
                beq.s   pic_disp3
                pea     setcolor(PC)
                move.w  #38,-(A7)       ;Supexec()
                trap    #14
                addq.l  #6,A7

pic_disp3:      cmpi.w  #1,fd_nplanes(A5) ;Monochromes Bild?
                beq.s   pic_vrt         ;Ja -> vrt_cpyfm()

pic_vro:        move.w  #3,intin(A5)    ;Überschreiben
                bsr     vdi
                bra.s   picmloop

pic_vrt:        move.w  #121,contrl(A5) ;vrt_cpyfm
                addq.w  #2,contrl+6(A5) ;3 intin
                lea     intin(A5),A0
                moveq   #1,D0
                move.w  D0,(A0)+        ;wr_mode=MD_REPLACE
                swap    D0
                move.l  D0,(A0)+        ;Farben Vordergrund=BLACK, H=WHITE
                bsr     vdi
                ENDPART
picmloop:       >PART 'Hauptschleife Bilder'
                bsr.s   getpickey
                tst.w   D3              ;Maus genügend bewegt?
                bne     pic_disp        ;Ja, neuzeichnen!
                tst.w   D0
                beq.s   picfkey         ;Funktionstaste
                lea     pkeytab(A5),A0
                lea     pjmptab(A5),A1
                bsr     keylist
                bra.s   picmloop

picfkey:        swap    D0
                lea     pkeytabf(A5),A0
                lea     pjmptabf(A5),A1
                bsr     fkeylist
                bra.s   picmloop

                ENDPART

getpickeyloop:  >PART 'Tastendruck/Mausbewegung'
                bsr.s   calccoor        ;Neue Koordinaten berechnen
                tst.l   D3
                bne.s   getpickeyret2   ;Zurück
                bsr     evnt_multi      ;ACCs ans Ruder lassen
                tst.l   D0              ;Taste gedrückt?
                bne.s   getpickeyret
getpickey:      bsr     testkey         ;Liegt eine Taste an? (Entry Point)
                beq.s   getpickeyloop   ;Nein, weiter warten
getpickeyret:   moveq   #0,D3           ;Bild nicht neuzeichnen
getpickeyret2:  rts
                ENDPART
calccoor:       >PART 'Koordinaten bestimmen'
                movea.l lineaptr(A5),A4
                moveq   #0,D3           ;Keine Koordinate geändert
                move.w  CUR_X(A4),D0
                move.w  vdi_w(A5),D1
                move.w  fd_w(A5),D2
                lea     piccurx(A5),A0
                bsr.s   calcone
                move.w  CUR_Y(A4),D0
                move.w  vdi_h(A5),D1
                move.w  fd_h(A5),D2
                lea     piccury(A5),A0  ;Fällt durch

calcone:        sub.w   D1,D2           ;Kleiner?
                bls.s   calcret         ;Ja -> weg
                mulu    D0,D2           ;Skalieren bis Bildbreite-Schirmbreite
                divu    D1,D2           ;Maus-X geht bis Bildbreite, nicht bis 1
                cmp.w   (A0),D2         ;Koordinate dieselbe?
                beq.s   calcret         ;Ja ->
                move.w  D2,(A0)         ;Nein, überschreiben
                addq.w  #1,D3           ;Und eine Koordinate geändert
calcret:        rts

                ENDPART

********************************************************************************

malloc32000:    >PART 'Alloziere für Puffer 1'
                move.l  picmem1(A5),D0  ;Speicher schon alloziert?
                bne.s   m32ret          ;Ja -> einfach zurück
                movem.l D1-D3/A0-A2,-(A7)
                move.l  #DOOsize,D3
                bsr.s   malloc
                move.l  D0,picmem1(A5)
                movem.l (A7)+,D1-D3/A0-A2 ;CCR bleibt erhalten
m32ret:         rts
                ENDPART
malloc:         >PART 'Alloziere Speicher'
                move.l  D3,-(A7)
                move.w  #$48,-(A7)      ;Malloc
                trap    #1
                addq.l  #6,A7
                rts
                ENDPART
picnomem:       lea     errnomem(A5),A4
                bsr     messagek        ;"Nicht genügend Speicher"
badpicf:        clr.l   pictype(A5)
                bra     disptext

********************************************************************************

picpac:         >PART '.PAC (STAD) anzeigen'
                bsr.s   malloc32000
                beq.s   picnomem
                movem.l D1-A6,-(A7)     ;Dekompression für STAD
                movea.l picmem1(A5),A2
                movea.l A2,A1
                movea.l filstrt(A5),A0

                cmpi.l  #stadmag2,(A0)  ;pM86
                bne.s   dchoriz
; vertikal auspacken
                addq.l  #4,A0
                move.b  (A0)+,D4
                clr.w   D6
                move.b  (A0)+,D6
                move.b  (A0)+,D5
                move.l  #32000,D2       ;zähler
                move.w  #400,D3         ;zeilen
dcvrl0:         clr.w   D7              ;kritisch da zähler
                move.b  (A0)+,D0
                cmp.b   D4,D0
                bne.s   dcvr1
                move.b  D6,D1
                bra.s   dcvr3
dcvr1:          cmp.b   D5,D0
                beq.s   dcvr2
                move.b  D0,(A1)
                clr.w   D7
                bra.s   dcvrall
dcvr2:          move.b  (A0)+,D1
                bne.s   dcvr3
                tst.b   (A0)
                beq.s   dcvrfin         ;D5 byte mit 2 nullen
dcvr3:          move.b  (A0)+,D7
dcvrloop:       move.b  D1,(A1)
dcvrall:        subq.w  #1,D2
                bmi.s   dcvrfin
                lea     80(A1),A1
                subq.w  #1,D3
                bne.s   dcvr0
                move.w  #400,D3
                addq.l  #1,A2
                movea.l A2,A1
dcvr0:          dbra    D7,dcvrloop
                bra.s   dcvrl0

; horiz auspacken
dchoriz:        cmpi.l  #stadmag1,(A0)  ;pM85
                bne.s   dcvrerr
                addq.l  #4,A0           ;Kennung pM85
                move.b  (A0)+,D4
                clr.w   D6
                move.b  (A0)+,D6
                move.b  (A0)+,D5
                move.l  #32000,D2
dchrl0:         clr.w   D7              ;kritisch da zähler
                move.b  (A0)+,D0
                cmp.b   D4,D0
                bne.s   dchr1
                move.b  D6,D1
                move.b  (A0)+,D7
                bra.s   dchrloop
dchr1:          cmp.b   D5,D0
                beq.s   dchr2
                move.b  D0,(A1)+        ;orig. byte
                subq.w  #1,D2
                bmi.s   dcvrfin
                bra.s   dchrl0
dchr2:          move.b  (A0)+,D1
                bne.s   dchr3
                tst.b   (A0)
                beq.s   dcvrfin         ;ende w.o. D5 byte mit 2 nullen
dchr3:          move.b  (A0)+,D7
dchrloop:       move.b  D1,(A1)+
                subq.w  #1,D2
                bmi.s   dcvrfin
                dbra    D7,dchrloop
                bra.s   dchrl0
dcvrfin:
dcvrerr:        movem.l (A7)+,D1-A6     ;Hier könnte ein Fehler zurückgemeldet werden
                movea.l picmem1(A5),A1
                bra     picpic
; (c) der obigen Routine: Peter Melzer, danke an Stefan Herzer

                ENDPART
picneo:         >PART '.NEO/.PI1 anzeigen'
                movea.l filstrt(A5),A1
                lea     128(A1),A0      ;Bildstart
                addq.l  #4,A1           ;Farbpalette
                bra.s   piclowres

picpi1:         movea.l filstrt(A5),A1
                tst.w   (A1)            ;Richtiges Format?
                bne     badpicf
                lea     34(A1),A0       ;Bildstart
                addq.l  #2,A1           ;Farbpalette
piclowres:      cmpi.w  #4,v_planes(A5) ;Lowres?
                bne.s   picerrdiff
                move.l  A0,fd_addr(A5)  ;MFDB füllen
                move.w  #320,fd_w(A5)
                move.w  #200,fd_h(A5)
                move.w  #4,fd_nplanes(A5)
                move.l  A1,paletteptr(A5)
                bra     pic_disp

picerrdiff:     tst.l   picmem2(A5)     ;Falls schonmal gemacht, dann
                bne.s   picerrdiff2     ;nicht nochmals errordiffundieren
                movem.l A0-A1,-(A7)     ;movem, da CCR nicht geändert wird
                lea     difftext(A5),A4 ;"Bitte warten"
                bsr     message
                move.l  picmem2(A5),D0  ;Speicher schon alloziert?
                bne.s   picerrdiff1
                move.l  #DOOsize,D3     ;32K allozieren
                bsr     malloc
                move.l  D0,picmem2(A5)
picerrdiff1:    movem.l (A7)+,A0-A1     ;movem, da CCR nicht geändert wird
                beq     picnomem        ;Muss bei aufgeräumtem Stack passieren

                move.l  A1,-(A7)        ;Farbpalette
                move.l  D0,-(A7)        ;Dest (picmem2)
                move.l  A0,-(A7)        ;Source
                bsr     errdiff
                lea     12(A7),A7
                bsr     v_clrwk         ;Infozeile löschen
picerrdiff2:    movea.l picmem2(A5),A1  ;Und Bild darstellen
                bra     picpic

                ENDPART
picpi2:         >PART '.PI2 anzeigen'
                cmpi.w  #1,(A1)+
                bne     badpicf
                move.l  A1,paletteptr(A5)
                lea     32(A1),A1
                move.l  A1,fd_addr(A5)  ;MFDB setzen
                bra     picmedres
                ENDPART
picimg:         >PART '.IMG anzeigen'
                movea.l filstrt(A5),A0
                cmpi.w  #1,N_PLANES(A0) ;Nur eine Plane?
                bne     badpicf
                move.w  IHEIGHT(A0),D0  ;Höhe des Bildes
                move.w  D0,fd_h(A5)
                move.w  IWIDTH(A0),D3   ;Breite des Bildes
                move.w  D3,fd_w(A5)
                add.w   #15,D3          ;Speicherplatz errechnen
                lsr.w   #4,D3           ;In Words wandeln
                add.w   D3,D3           ;Wieder in Bytes verwandeln
                move.w  D3,D4           ;Sichern
                mulu    D0,D3           ;Gesamthaft benötigte Bytes

                move.l  picmem2(A5),D0  ;Speicher schon alloziert?
                bne.s   picimg1
                bsr     malloc
                move.l  D0,picmem2(A5)
                beq     picnomem
picimg1:        move.l  D0,fd_addr(A5)
                move.w  #1,fd_nplanes(A5)

                movem.l D0-A6,-(A7)
                move.w  D4,-(A7)        ;Breite in Bytes
                move.l  D0,-(A7)        ;Destinationadresse
                move.l  filstrt(A5),-(A7)
                bsr.s   img_dec         ;Zerstört A5!
                lea     10(A7),A7
                movem.l (A7)+,D0-A6
                bra     pic_disp

                ENDPART
img_dec:        >PART '.IMG dekomprimieren'

;
; Decompress .IMG-Format: Das dekomprimierte Format wird in ein BREITE
; breites Feld dekomprimiert
;
;       VV          VV        11          222
;        VV        VV        111         22 22
;         VV      VV        1111        22   22
;          VV    VV        11 11            22
;           VV  VV            11           22
;            VVVV             11    ..    22
;             VV             1111   ..  22222222
;
; Aufruf aus C:
;
; int decomp2(source,destination,breite);
; char *source,*destination;
; int  breite;
;
; Rückgabewert: -1      = ok
;               0       = falsche Daten


; Registerbelegung:
; A0: Zeiger in die Source      A4: Zeiger in zu kopierende Struktur
; A1: Zeiger in das Bild        A5: Zeiger auf Scanline-Start (Multiple only)
; A2: Zeiger auf Zeilenwiederh. A6: Zeiger auf Ende der aktuellen Scanline
; A3: Zeiger auf Patternstart   A7: (Was wohl??)

; D0: Höhe (Zähler)             D4: Breite (Zähler)
; D1: Breite (Update-Reg.)      D5: Opcode
; D2: Pattern length-1 (U-R)    D6: Repeat Count (Multiple Scanlines)
; D3: Breitendifferenz          D7: Allerweltsregister

                movea.l 4(A7),A0        ;Source (zeigt (noch) auf Header)
                movea.l 8(A7),A1        ;Destination
                move.w  12(A7),D3       ;Breite
                cmpi.w  #1,N_PLANES(A0) ;Schwarzweissbild?
                bne     abort
                move.w  IHEIGHT(A0),D0
                move.w  IWIDTH(A0),D1   ;jetzt Pixel...
                addq.w  #7,D1
                lsr.w   #3,D1           ;...nun Bytes
                sub.w   D1,D3           ;Breitendifferenz
                move.w  PATLEN(A0),D2
                subq.w  #1,D2           ;DBRA-Zähler
                movea.l A1,A2
                moveq   #0,D7
                move.w  HDRLEN(A0),D7
                add.w   D7,D7
                adda.w  D7,A0           ;Zeigt jetzt auf START

nxtline:        moveq   #0,D6           ;Flag: Keine Wiederholung
                lea     0(A1,D1.w),A6
nxtbyte:        move.b  (A0)+,D5        ;Hole Opcode
                beq.s   oc_00           ;Auswahl je nach Opcode
                bpl.s   oc_0x
; Jetzt ist es negativ
                andi.b  #$7F,D5
                beq.s   oc_80


oc_8x:          subq.b  #1,D5           ;Solid Run of 1s
                ext.w   D5
oc_8xl:         st      (A1)+
                dbra    D5,oc_8xl
                bra.s   cont


oc_80:          move.b  (A0)+,D5        ;Bit Image String
                subq.b  #1,D5
                bcs     abort
                ext.w   D5
oc_80l:         move.b  (A0)+,(A1)+
                dbra    D5,oc_80l
                bra.s   cont

oc_0x:          subq.b  #1,D5           ;Solid Run of 0s
                ext.w   D5
oc_0xl:         sf      (A1)+
                dbra    D5,oc_0xl
                bra.s   cont


oc_00:          moveq   #0,D5           ;Für unsigned Extend
                move.b  (A0)+,D5
                beq.s   oc_multi
                subq.b  #1,D5           ;Run Pattern
                movea.l A0,A3
oc_00l:         movea.l A3,A0
                move.w  D2,D7
oc_00l1:        move.b  (A0)+,(A1)+
                dbra    D7,oc_00l1
                dbra    D5,oc_00l
                bra.s   cont


oc_multi:       cmpi.b  #$FF,(A0)+      ;Multiple Scanlines
                bne.s   abort
                moveq   #0,D6           ;Unsigned Extend
                move.b  (A0)+,D6
                movea.l A1,A5


cont:           cmpa.l  A6,A1           ;Ende der Scanline?
                bmi.s   nxtbyte         ;Nein, weiter
                bne.s   abort           ;Zeilenüberschreitung;nun kritischer
                subq.w  #2,D6           ;Scanline replication count?
; DBRA und Zeile schon einmal geschrieben (--> -2)
                bcs.s   tstnext         ;Nein, weiter
cpyline:        move.w  D3,D7
                beq.s   contcpy         ;Neu
                bmi.s   suboffs         ;Ebenfalls
                subq.w  #1,D7
addoffs:        clr.b   (A1)+
                dbra    D7,addoffs
contcpy:        move.w  D1,D7           ;Zeile byteweise kopieren
                subq.w  #1,D7
                movea.l A5,A4
cpybyte:        move.b  (A4)+,(A1)+
                dbra    D7,cpybyte
                subq.w  #1,D0           ;Neu
                dbcs    D6,cpyline      ;Neu, nicht mehr DBF
                bcs.s   imgdret         ;Ganz neu, sonst über 4MB heraus...

tstnext:        move.w  D3,D7
                ble.s   suboff2
                subq.w  #1,D7
addoff2:        clr.b   (A1)+
                dbra    D7,addoff2
dbnxtln:        dbra    D0,nxtline
imgdret:        rts


suboffs:        adda.w  D7,A1           ;D7 ist negativ: positioniert rückwärts
                bra.s   contcpy

suboff2:        adda.w  D7,A1
                bra.s   dbnxtln


abort:                                  ;moveq   #0,D0 ;Wird hier nicht benötigt
                rts

                ENDPART
piccrg:         >PART '.CRG anzeigen'
                movea.l filstrt(A5),A3
                cmpi.l  #'CALA',(A3)+
                bne     crgerrend
                cmpi.l  #'MUSC',(A3)+
                bne.s   crgerrend
                cmpi.w  #'RG',(A3)+
                bne.s   crgerrend
                lea     10(A3),A3

                tst.w   (A3)+           ;Breite (maximal 65535 Pixel)
                bne.s   crgerrend
                move.w  (A3)+,fd_w(A5)
                beq.s   crgerrend       ;mindestens aber 1 Pixel

                tst.w   (A3)+           ;Höhe (maximal 65535 Zeilen)
                bne.s   crgerrend
                move.w  (A3)+,D4
                beq.s   crgerrend       ;mindestens aber 1 Zeile
                move.w  D4,fd_h(A5)

                tst.w   (A3)+           ;Breite in Bytes
                bne.s   crgerrend
                move.w  (A3)+,D0
                beq.s   crgerrend       ;Dieselben Kriterien

                move.w  D4,D3
                mulu    D0,D3           ;Anzahl Bytes (Dest)

                move.l  picmem2(A5),D0  ;Speicher schon alloziert?
                bne.s   piccrg1
                bsr     malloc
                move.l  D0,picmem2(A5)
                beq     picnomem

piccrg1:        movea.l D0,A1           ;Hole Dest
                move.l  D0,fd_addr(A5)
                move.w  #1,fd_nplanes(A5)
                addq.l  #6,A3
                move.l  (A0)+,D4        ;Anzahl Bytes (Source, compressed)

crgloop:        subq.l  #1,D4           ;Noch Sourcebytes?
                bcs.s   crgende         ;Nein, fertig!
                move.b  (A0)+,D2
                bmi.s   crg_8x

crg_0x:         subq.l  #1,D4           ;Noch Platz in Source und Dest?
                bcs.s   crgerrend
                subq.l  #1,D3
                bcs.s   crgerrend
                move.b  (A3)+,(A1)+
                subq.b  #1,D2           ;Noch mehr kopieren?
                bcc.s   crg_0x
                bra.s   crgloop

crg_8x:         moveq   #0,D0
                move.b  (A3)+,D5
                subq.l  #1,D4
                bcs.s   crgerrend

crg8xloop:      move.b  D5,(A1)+
                subq.l  #1,D3
                blt.s   crgerrend
                subq.b  #1,D2
                bvc.s   crg8xloop
                bra.s   crgloop

crgerrend:      bra     badpicf

crgende:        rts
                ENDPART
errdiff:        >PART 'Errordiffusion'  ;KEINE (A5)-ADRESSIERUNG!
; CONVER5                                      Urs Müller      5. März 1988
;
; Konvertiert Farbbilder LowRes nach dem Error-Diffusion-
; Verfahren in Monochrom-Bilder.
;
; - 10.07.88 mw Modifiziert für variable Farbpalette


; Offsets im Stack
;register=0 ;.ds.l 15
vercount        EQU 60                  ;.ds.w 1 ;Verktikalzähler
retadr          EQU 62                  ;.ds.l 1
source          EQU 66                  ;.ds.l 1 ;Sourceadresse
dest            EQU 70                  ;.ds.l 1 ;Destinationadresse
colpal          EQU 74                  ;.ds.l 1 ;Adresse der Palette

; d0 = dummy
; d1 = dummy
; d2 = dummy
; d3 = dummy
; d4 = dummy
; D5 = # Bit im Outputbyte
; D6 = Pattern für Output
; d7 = Zähler

; a0 = dummy
; A1 = ^ Error obere Zeile /^ Farbpalette (mw)
; A2 = Error für nächstes Pixel
; A3 = ^input-picture
; A4 = ^Output-picture
; A5 = ^Zeilenpuffer
; a6 = zur Adressierung der Variablen

                suba.w  #retadr,A7
                movem.l D0-A6,(A7)      ;ehemals register(A7)
                movea.l A7,A6

                movea.l source(A6),A3   ;Bildadresse
                movea.l dest(A6),A4     ;Outputadresse

                movea.l colpal(A6),A0
                lea     colorbuf(PC),A1
                moveq   #15,D0
palloop:        moveq   #0,D1
                move.w  (A0)+,D1
                move.w  D1,D3           ;Blau
                and.w   #7,D3
                lsr.w   #4,D1           ;Grün
                move.w  D1,D2
                and.w   #7,D2
                add.w   D2,D3           ;dazuzählen
                lsr.w   #4,D1           ;Rot
                and.w   #7,D1
                add.w   D1,D3           ;Gesamtwert
                mulu    #183,D3         ;*183
                move.w  D3,(A1)+
                dbra    D0,palloop
; Die Farbwerte bewegen sich nun von $000(schwarz) bis und mit $f03(weiss)
; (Die Farbwerte der Originalroutine waren im Bereich $000 bis $f00)

                lea     diffbuf1(PC),A0
                move.w  #320,D7         ;642 Words löschen
                moveq   #0,D0
clrloop:        move.l  D0,(A0)+        ;clr
                dbra    D7,clrloop

                moveq   #15,D5
                move.w  #399,vercount(A6) ;Vertikalzähler setzen

verloop:        btst    #0,vercount+1(A6)
                beq.s   evenline

                bsr     evt_switch      ;Ab & zu ein Taskswitch

                lea     diffbuf(PC),A0
                moveq   #19,D7          ;20 Mal 4 Word konvertieren
convloop:       movem.w (A3)+,D0-D3
                lea     colorbuf(PC),A1
                moveq   #15,D6          ;16 Bit pro Word
bitloop:        clr.w   D4
                add.w   D0,D0
                roxr.b  #1,D4
                add.w   D1,D1
                roxr.b  #1,D4
                add.w   D2,D2
                roxr.b  #1,D4
                add.w   D3,D3
                roxr.b  #4,D4           ;Resultat als Index im Low-Byte

                move.w  0(A1,D4.w),(A0)+ ;Wert aus Farbtabelle

                dbra    D6,bitloop
                dbra    D7,convloop

evenline:       lea     diffbuf(PC),A5  ;^Bildpuffer
                lea     diffbuf1+2(PC),A1 ;^Errorbuffer (1 vor 1. Pixel)
                movea.w (A1),A2         ;Randproblem links
                clr.w   (A1)+           ;       "
; Jetzt zeigt A1 auf 1. Pixel
                clr.w   D6
                move.w  #319,D7

horloop:        move.w  (A5),D0         ;Pixelwert
                add.w   A2,D0           ;+ Errors
                cmpi.w  #$0780,D0       ;Schwelle = 1/2 Maximalwert
                bgt.s   lb1             ;weiss
                bset    D5,D6
                bra.s   lb2
lb1:            subi.w  #$0F00,D0       ;Error berechnen
lb2:            subq.w  #1,D5
                asr.w   #3,D0           ;div 8
                move.w  D0,D1
                add.w   D0,D1
                add.w   D0,D1           ;d1 = d0 x 3
                movea.w (A1),A2         ;Error v. oben für nächsten
                adda.w  D1,A2           ;3/8 für nächsten Pixel
                move.w  D0,(A1)+        ;1/8
                add.w   D1,-4(A1)       ;3/8
                add.w   D0,-6(A1)       ;1/8

; Nochmals dasselbe, aber mit (A5)+ und Test, ob D5>0 (mit DBF)
                move.w  (A5)+,D0        ;Pixelwert
                add.w   A2,D0           ;+ Errors
                cmpi.w  #$0780,D0
                bgt.s   lb3             ;weiss
                bset    D5,D6
                bra.s   lb4
lb3:            subi.w  #$0F00,D0       ;Error berechnen
lb4:            dbra    D5,lb5
                moveq   #15,D5
                move.w  D6,(A4)+
                clr.w   D6
lb5:            asr.w   #3,D0           ;div 8
                move.w  D0,D1
                add.w   D0,D1
                add.w   D0,D1           ;d1 = d0 x 3
                movea.w (A1),A2         ;Error v. oben für nächsten
                adda.w  D1,A2           ;3/8 für nächsten Pixel
                move.w  D0,(A1)+        ;1/8
                add.w   D1,-4(A1)       ;3/8
                add.w   D0,-6(A1)       ;1/8

                dbra    D7,horloop

                subq.w  #1,vercount(A6)
                bpl     verloop
                movem.l (A7),D0-A6      ;ehemals register(A7)
                lea     retadr(A7),A7
                rts

                ENDPART

********************************************************************************

gem_init:       >PART 'Beim GEM anmelden'
                linea   #10 [ Hidem ]   ;Maus ausschalten

                lea     contrl(A5),A0
                move.w  #10,(A0)+       ;appl_init()
                moveq   #1,D0
                move.l  D0,(A0)+        ;sintin=0, sintout=1
                clr.l   (A0)            ;saddrin, saddrout=0
                clr.w   ap_versi(A5)    ;Reagiert AES überhaupt?
                bsr     aes
                tst.w   intout(A5)
                bmi.s   vdiret

                lea     contrl(A5),A0
                move.w  #77,(A0)+       ;graf_handle()
                moveq   #5,D0
                move.l  D0,(A0)+        ;sintin=0, sintout=5
                clr.l   (A0)            ;saddrin, saddrout=0
                bsr     aes             ;intout[0] wird noch gebraucht...

                move.w  #4,-(A7)        ;Getrez()
                trap    #14
                addq.l  #2,A7
                move.w  D0,rez(A5)
                addq.w  #2,D0

                lea     intin(A5),A0
                move.w  D0,(A0)+        ;Device Id
                moveq   #8,D0
                moveq   #1,D1
vdi_fwi:        move.w  D1,(A0)+        ;Fülle work_in
                dbra    D0,vdi_fwi
                move.w  #2,(A0)         ;Raster Coordinates

                lea     contrl(A5),A0
                move.w  intout(A5),12(A0) ;handle von graf_handle() (intout[0])
                move.w  #100,(A0)+      ;Opcode
                clr.w   (A0)            ;sptsin
                move.w  #11,4(A0)       ;sintin
                bsr.s   vdi
                move.w  contrl+12(A5),vdihndl(A5)
                beq.s   vdiret

                lea     intout(A5),A0   ;Bildbreite/-höhe merken
                lea     vdi_w(A5),A1
                move.w  (A0)+,D0
                addq.w  #1,D0
                move.w  D0,(A1)+
                move.w  (A0)+,D0
                addq.w  #1,D0
                move.w  D0,(A1)+
vdiret:         rts

                ENDPART
gem_exit:       >PART 'und wieder abmelden'
                movea.l lineaptr(A5),A0
                movea.l INTIN(A0),A0    ;Hole Adresse des Linea-Intins
                move.w  #1,(A0)         ;Maus nur 1x einschalten
                linea   #9 [ Showm ]    ;do it!

                tst.w   ap_versi(A5)
                beq.s   v_clsvwk
                lea     contrl(A5),A0
                move.w  #19,(A0)+
                clr.w   (A0)
                clr.w   4(A0)
                bsr.s   aes

v_clsvwk:       tst.w   vdihndl(A5)
                beq.s   vdiret
                clr.w   vdihndl(A5)     ;Jetzt gibt es sie nicht mehr!
                lea     contrl(A5),A0
                move.w  #101,(A0)+      ;Opcode

vnopar:         clr.w   (A0)            ;sptsin
                clr.w   4(A0)           ;sintin

vdi:            move.l  #vdipb,D1
                moveq   #$73,D0
                trap    #2
                rts

aes:            move.l  #aespb,D1
                move.w  #$C8,D0
                trap    #2
                rts

********************************************************************************

v_clrwk:        lea     contrl(A5),A0
                move.w  #3,(A0)+        ;Opcode
                bra.s   vnopar          ;VDI, no Parameter

vst_heig:       lea     contrl(A5),A0   ;ptsin[1] enthält Höhe

                move.w  #12,(A0)+
                move.w  #1,(A0)
                clr.w   4(A0)
                bra.s   vdi

                ENDPART
evt_switch:     >PART 'Taskwechsel durchführen'
                subq.w  #1,switchcnt(A5) ;Zählen. Schon durch?
                bcc.s   evt_ret         ;Nein =>
                move.w  #forceswitch,switchcnt(A5) ;Wieder länger warten
                movem.l D0-D2/A0-A2,-(A7)
                clr.l   intin(A5)
                lea     contrl(A5),A0
                move.l  #$180002,(A0)+  ;Funktion 24, 2 Words intin
                move.w  #1,(A0)+        ;1 Word intout
                clr.l   (A0)+           ;Weder addrin noch addrout
                bsr.s   aes             ;AES aufrufen
                movem.l (A7)+,D0-D2/A0-A2
evt_ret:        rts

evnt_multi:     lea     intin(A5),A0
                move.w  #%100001,(A0)+  ;MU_KEYBD | MU_TIMER
                moveq   #8,D0
evnt_mloop:     clr.l   (A0)+           ;intin[] löschen
                dbra    D0,evnt_mloop
                move.w  evnt_delay(A5),intin+28(A5) ;Wartezeit setzen
                move.l  #msgbuff,addrin(A5) ;addrin[] füllen
                clr.w   intout(A5)      ;Sicherheitshalber
                lea     contrl(A5),A0
                move.l  #$190010,(A0)+  ;Funktion 25, 16 Words intin
                move.l  #$070001,(A0)+  ;7 Words intout, 1 Word addrin
                clr.w   (A0)+           ;kein addrout
                bsr     aes
                moveq   #0,D0           ;Default: Keine Taste gedrückt
                btst    #0,intout+1(A5) ;Taste gedrückt?
                beq.s   evt_ret

                move.l  #$0BFFFF,-(A7)  ;Kbshift(-1)
                trap    #13
                addq.l  #4,A7
                lsl.w   #8,D0           ;Untere Bits löschen, nach oben schieben
                move.b  intout+10(A5),D0 ;Scancode
                swap    D0
                move.b  intout+11(A5),D0 ;So, Tastencode zusammengestellt
                bra     key_finish      ;Nach gross wandeln und ausmaskieren
                ENDPART

********************************************************************************

; Eingabe: A4 = Zeiger in Metafile
; Ausgabe: D3 = Gelesenes Word (geswappt)
get_meta:       move.w  (A4)+,D3
                rol.w   #8,D3
                rts

********************************************************************************

picgem:         >PART 'Metafile darstellen'

;
;         VDI-Subroutinen und Metafile zeichnen
;
;         Idee und Algorithmus von Bernhard Bayer
;
;         Umsetzung in Assembler von Marcel Waldvogel
;

                tst.w   vdihndl(A5)
                beq     badpicf         ;Anzeigen nicht möglich
                bsr     v_clrwk         ;Bildschirm löschen
                movea.l filstrt(A5),A4
                movea.l A4,A0           ;Sichern
                cmpi.w  #-1,(A4)+       ;Kennung
                bne     badpicf         ;("MAGIC" kann man dem nicht sagen!)
                bsr.s   get_meta
                move.w  D3,D0           ;Headerlänge
                add.w   D3,D0           ;...in Words

                lea     20(A0),A4       ;Nach filstrt+20 (Koordinaten)
                bsr.s   get_meta
                move.w  D3,D4           ;x1
                bsr.s   get_meta
                move.w  D3,D5           ;y1
                bsr.s   get_meta
                move.w  D3,D6           ;x2
                bsr.s   get_meta
                move.w  D3,D7           ;y2
                bne.s   mnotall0
                tst.w   D6
                bne.s   mnotall0
                tst.w   D5
                bne.s   mnotall0
                tst.w   D4
                bne.s   mnotall0

                move.w  #32767,D6       ;Falls alle Koordinaten Null
                move.w  D6,D5

mnotall0:       lea     0(A0,D0.w),A4   ;Header überspringen
                sub.w   D7,D5           ;ydif
                sub.w   D4,D6           ;xdif

                move.w  vdi_h(A5),D0    ;Vergrösserungsfaktoren bestimmen.
                muls    D6,D0           ;Übers Kreuz multiplizieren ergibt
                move.w  vdi_w(A5),D1    ;dasselbe Verhältnis wie paarweise
                muls    D5,D1           ;zu dividieren

                lea     vdifakt(A5),A0
                cmp.l   D0,D1           ;Man nehme den kleineren -> Verhältinis
                bcc.s   mna1            ;bleibt und alles ist auf dem Schirm
                move.w  vdi_w(A5),(A0)+ ;Faktoren merken
                move.w  D6,(A0)
                bra.s   metaloop
mna1:           move.w  vdi_h(A5),(A0)+
                move.w  D5,(A0)

metaloop:       lea     contrl(A5),A1
                bsr.s   get_meta        ;Opcode
                move.w  D3,D6           ;sichern
                move.w  D3,(A1)+
                subq.w  #3,D3
                bmi     picmloop        ;Main Picture loop

                bsr     get_meta
                move.w  D3,D2
                move.w  D3,(A1)         ;sptsin
                bsr     get_meta
                move.w  D3,D1
                move.w  D3,4(A1)        ;sintin
                bsr     get_meta
                move.w  D3,8(A1)        ;esc (Subopcode)

                cmpi.w  #107,D6         ;vst_point?
                beq     vst_poin        ;vst_point!

* Führe VDI-Befehl aus
                subq.w  #1,D2
                bcs.s   mcopyint        ;Keine Punkte
                lea     ptsin(A5),A1
                cmpi.w  #11,D6          ;Opcode = 11
                bcs.s   mwithsub        ;<11?
                beq.s   mgdp            ;=11?
                cmpi.w  #113,D6
                bhi.s   mwithsub        ;>113?
mnosub:         bsr.s   metamul
                dbra    D2,mnosub
                bra.s   mcopyint

mwithsub:       bsr.s   metasub
                dbra    D2,mwithsub
                bra.s   mcopyint

mgdp:           subq.w  #2,D3           ;cmpi.w #2,esc
                bcs.s   mwithsub        ;<2?
                subq.w  #5,D3           ;cmpi.w #2+5,esc
                bls.s   msubmal2        ;<=7?
                subq.w  #3,D3           ;cmpi.w #2+5+3,esc
                bne.s   mwithsub        ;<>10?
msubmal2:       bsr.s   metasub         ;Höchstens der erste mit sub (Punkte)
                subq.w  #1,D2
                bcc.s   mnosub          ;Danach: ohne sub (Masse)

mcopyint:       subq.w  #1,D1
                bcs.s   vdiandbk
                lea     intin(A5),A1
mcpyloop:       bsr     get_meta
                move.w  D3,(A1)+
                dbra    D1,mcpyloop

vdiandbk:       bsr     vdi
                bra     metaloop

********************************************************************************

metamul:        bsr     get_meta
                lea     vdifakt(A5),A0
                muls    (A0)+,D3
                divs    (A0),D3
                move.w  D3,(A1)+        ;X-Koordinate

                bsr     get_meta
                lea     vdifakt(A5),A0
                muls    (A0)+,D3
                divs    (A0),D3
                move.w  D3,(A1)+        ;Y-Koordinate
                rts

********************************************************************************

metasub:        bsr     get_meta
                sub.w   D4,D3           ;-x1
                lea     vdifakt(A5),A0
                muls    (A0)+,D3
                divs    (A0),D3         ;evt. runden (vor divs: add (D5>>1),D3
                move.w  D3,(A1)+        ;X-Koordinate

                bsr     get_meta
                sub.w   D7,D3           ;-y2
                lea     vdifakt(A5),A0
                muls    (A0)+,D3
                divs    (A0),D3
                move.w  D3,(A1)+        ;Y-Koordinate
                rts

********************************************************************************

vst_poin:       bsr     get_meta
                muls    #c_scal,D3
                lea     vdifakt(A5),A0
                muls    (A0)+,D3
                divs    (A0),D3
                move.w  D3,ptsin+2      ;als Y-Koordinate
                bsr     vst_heig
                bra     metaloop

                ENDPART

********************************************************************************
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
********************************************************************************

                EVEN
                DATA
                EVEN

                >PART 'Konfigurationsdaten'
                DC.L magic
                DXSET 32,0
textedit:       DX.B 'D:\TC\TC.PRG'
grafedit:       DX.B 'E:\DEGAS\DEGELITE.PRG'
printercfg:     DX.B ''

                ENDPART
                >PART 'Bildformate und -help'

picext:         DC.B ".DOO",".PIC",".PC3",".PI3",".PI3"
                DC.B ".IMG",".PI1",".PI1",".NEO",".PC2"
                DC.B ".PI2",".PI2",".PC1",".GEM",".CRG"
piclen:         DC.W 32000,32000,0,32034,32066 ;0=beliebig
                DC.W 0,32034,32066,32128,0
                DC.W 32034,32066,0,0,0
picadr:         DC.L picpic,picpic,picpc3,picpi3,picpi3
                DC.L picimg,picpi1,picpi1,picneo,picpc2
                DC.L picpi2,picpi2,picpc1,picgem,piccrg,0 ;0=Ende
picreso:        DC.W -1,-1,-1,-1,-1     ;(picreso[i] & nplanes != 0) ? ok : !ok
                DC.W -1,-1,-1,-1,-1
                DC.W %10,%10,-1,-1,-1   ;-1=Alle Auflösungen (bis 32768 Planes)


hilfpic1:       DC.B LF
htIp:           DC.B TAB,"  I",TAB,TAB,TAB,"-",TAB,"Bildschirm invertieren",LF
                DC.B LF
                DC.B TAB,"  S",TAB,TAB,TAB,"-",TAB,"Speichern als .PI3",LF
                DC.B TAB,"  Ctrl-S",TAB,TAB,"-",TAB,"Speichern (überschreiben)",LF
                DC.B LF
                DC.B TAB,"  Alt-Help",TAB,TAB,"-",TAB,"Ausdruck (Hardcopy)",LF
                DC.B LF
                DC.B TAB,"  Tab",TAB,TAB,TAB,"-",TAB,"Textmodus",LF
                DC.B LF
                DC.B 0

                ENDPART
                >PART 'Helpseite'

gucktitl:       DC.B LF
                DC.B TAB,TAB,TAB,TAB,"    GUCK V1.7",LF
                DC.B TAB,TAB,TAB,"   ╜ 1988-1990 Marcel Waldvogel",LF
                DC.B TAB,TAB,TAB," Hägetstalstr. 37   CH-8610 Uster",LF
                DC.B LF,0
stern:          DC.B "*",0

hilftxt1:       DC.B LF
ht0:            DC.B TAB,"  0",TAB,TAB,TAB,"-",TAB,"NUL (ASCII) verändern",LF
htW:            DC.B TAB,"  W",TAB,TAB,TAB,"-",TAB,"1st Word ein/aus",LF
htD:            DC.B TAB,"  D",TAB,TAB,TAB,"-",TAB,"DUMP ein/aus",LF
htX:            DC.B TAB,"  X",TAB,TAB,TAB,"-",TAB,"Wechsel DUMP/XDUMP",LF
htIt:           DC.B TAB,"  I",TAB,TAB,TAB,"-",TAB,"Invertieren ein/aus",LF
                DC.B TAB,"  T",TAB,TAB,TAB,"-",TAB,"Tabulatorgrösse ( )",LF
htT:            DC.B TAB,"  Tab",TAB,TAB,TAB,"-",TAB,"Anzeige als Bild",LF
                DC.B TAB,"  G",TAB,TAB,TAB,"-",TAB,"Gehe zu Zeile/Byte",LF
                DC.B TAB,"  Ctrl-F, Ctrl-G",TAB,"-",TAB,"Suche/Suche nächsten",LF
                DC.B TAB,"  P, Ctrl-P",TAB,TAB,"-",TAB,"Datei drucken mit/ohne Zeichenwandlung",LF
                DC.B TAB,"  B",TAB,TAB,TAB,"-",TAB,"Block drucken mit Zeichenwandlung",LF
                DC.B TAB,"  Ctrl-L",TAB,TAB,"-",TAB,"Blatt auswerfen, Form Feed",LF
hilfterm:       DC.B TAB,"  Ctrl-E",TAB,TAB,"-",TAB,"Editoraufruf",LF
                DC.B TAB,"  N",TAB,TAB,TAB,"-",TAB,"Nächste Datei",LF
                DC.B TAB,"  Q, Ctrl-Q, Esc, Undo",TAB,"-",TAB,"Programmende",LF
                DC.B LF,0

hilfweiter:     DC.B "*******  Weiter  ",0

hilftxt2:       DC.B LF
                DC.B TAB,TAB,TAB,"Cursorsteuerung",LF
                DC.B LF
                DC.B TAB,"  +------+------+------+",TAB,"Weitere Möglichkeiten:",LF
                DC.B TAB,"  | 7",TAB," | 8",TAB,"| 9    |",TAB,"Textanfang:",TAB,"Home",LF
                DC.B TAB,"  |",TAB," |",TAB,"|      |",TAB,"Textende:",TAB,"Shift-/Ctrl-Home, Alt-E",LF
                DC.B TAB,"  | Home | ",TAB,"| PgUp |",TAB,"Seite ab:",TAB,"Shift-/Ctrl-, Ctrl-D",LF
                DC.B TAB,"  +------+------+------+",TAB,"Seite auf:",TAB,"Shift-/Ctrl-, Ctrl-U",LF
                DC.B TAB,"  | 4",TAB," | 5",TAB,"| 6    |",TAB,"Zeile ab:",TAB,"Return",LF
                DC.B TAB,"  |",TAB," |",TAB,"|      |",TAB,"20 Zeilen ab:",TAB,"Space",LF
                DC.B TAB,"  | ",TAB," |",TAB,"|     |",TAB,"20 Zeilen auf:",TAB,"Backpace",LF
                DC.B TAB,"  +------+------+------+",LF
                DC.B TAB,"  | 1",TAB," | 2",TAB,"| 3    |",TAB,"Maustasten:",LF
                DC.B TAB,"  |",TAB," |",TAB,"|      |",TAB,"Links",TAB,"wie",TAB,"",LF
                DC.B TAB,"  | End  | ",TAB,"| PgDn |",TAB,"Rechts",TAB,"wie",TAB,"",LF
                DC.B TAB,"  +------+------+------+",TAB,"Beide",TAB,"wie",TAB,"Esc",LF
crlf:           DC.B LF
zero:           DC.B 0

                ENDPART
                >PART 'Fehlermeldungen'

errnoeditor:    DC.B "Kein Editor definiert!",0

errnofil:       DC.B "Keine Datei angegeben!",0

errcancfg:      DC.B "Kann "            ;Fällt durch!
errcfg:         DC.B "Druckertreiber ",0

errtoobig:      DC.B " ist zu gross!",0

errbadformat:   DC.B " hat ein falsches Format!",0

errfile:        DC.B "Kann Datei ",0

errfound:       DC.B " nicht finden!",0

erropen:        DC.B " nicht öffnen!",0

errread:        DC.B " nicht lesen!",0

errtlong:       DC.B " nicht lesen! "   ;Fällt durch!
errnomem:       DC.B "Zuwenig Speicher!",0

errafile:       DC.B "Datei ",0
errexist:       DC.B " existiert bereits!",0

errreso:        DC.B "Speichern ist in dieser Auflösung nicht möglich!",0

errnovdi:       DC.B "VDI-Fehler!",0

errwrite:       DC.B " nicht schreiben!" ;Fällt durch!
taste:          DC.B "     Taste drücken...",0

                ENDPART
                >PART 'Sonstige Texte'
prtretry:       DC.B "Drucker reagiert nicht! Abbruch mit <Esc>, "
                DC.B "weiter mit sonstiger Taste.",0

infotext:       DC.B "Datei: ",0
                DC.B ", ",0
                DC.B " Bytes, Zeile ",0
                DC.B " von ",0

dumpinfo:       DC.B ", Byte ",0
                DC.B " von ",0

tausdump:       DC.B "Drucke Byte",0
tausdruk:       DC.B "Drucke Zeile"
tausabbr:       DC.B TAB,TAB,"Abbruch mit <Esc>",0

difftext:       DC.B "Bild wird umgewandelt, bitte warten...",0

gotolinetxt:    DC.B "Gehe Zeile:"
space:          DC.B " ",0

gotobytetxt:    DC.B "Gehe Byte: ",0

findtxt:        DC.B "Suche: ",0

                ENDPART
                >PART 'Tastaturtabelle'

* Jeweils ?keytab? und ?jmptab? gehören zusammen
* Tabelle, falls geshiftet
keytabs:        DC.B "782",0

* Tabelle, falls nicht eine der oberen
keytab:         DC.B CTRLD,TAB,CTRLE,CTRLF,CTRLG,CTRLH
                DC.B CTRLL,CR,CTRLP,CTRLQ,CTRLU,ESC
                DC.B " 0123789"
                DC.B "BDGINPQTWX"
                DC.B 0

* Tabelle für Bildmodus
pkeytab:        DC.B CTRLE,TAB,CTRLQ,CTRLS,ESC,"INQS"
                DC.B 0

                EVEN
* Funktionstastentabelle
keytabf:        DC.W HOME,UP,CTRLUP,CTRLHOME
                DC.W DOWN,CTRLDOWN,ALTE
pkeytabf:       DC.W HELP,UNDO          ;kommen in beiden vor
                DC.W 0


                EVEN
                BASE DC.W,keylist
jmptabs:        DC.W bottom,pageup,pagedown

jmptab:         DC.W pagedown,disppic,exectext,find,findsame,up20
                DC.W formfeed,onedown,filprtdirect,term,pageup
                DC.W term,down20,chNUL,bottom,onedown,pagedown,top,oneup,pageup
                DC.W blkprt,chDUMP,goto,invertt,next,filprt,term,chTAB,chWP,chXDUMP

pjmptab:        DC.W execgraf,disptext,term,save1,term,invertp,next,term,save

                BASE DC.W,fkeylist
jmptabf:        DC.W top,oneup,pageup,bottom
                DC.W onedown,pagedown,bottom
                DC.W help,term

pjmptabf:       DC.W pichelp,term
                BASE DC.W,OFF

                ENDPART
                >PART 'Konversionstabellen'
;Tabellen, mit denen von einer Tabulatorweite zur nächsten gesprungen wird
;$FF=ungültig (wird nie referenziert)
;Alte Breite:         0   1   2   3   4   5   6  7    8
TABflagtab:     DC.B $02,$FF,$04,$FF,$08,$FF,$FF,$FF,$00 ;Neue Breite
;Text zur aktuellen Tabulatorbreite
TABcnttab:      DC.B "-",$FF,"2",$FF,"4",$FF,$FF,$FF,"8"

                EVEN
numbers:        DC.L 1000000000,100000000,10000000,1000000,100000
                DC.L 10000,1000,100,10,0

; Diese Labels dürfen höchstens 128 Bytes vom Beginn des BSS-Segmentes weg sein,
; da sie mit pi123(A5,Dn) adressiert wird.

pi123:          DC.B 2,1,-1,0           ;Planes -> Auflösung (-1: Ungültig)
pi123x:         DC.W 320,640,640        ;Auflösung -> Breite, Höhe
pi123y:         DC.W 200,200,400

                ENDPART

; GEM-Parameter
vdipb:          DC.L contrl,intin,ptsin,intout,ptsout
aespb:          DC.L contrl,global,intin,intout,addrin,addrout

********************************************************************************
*   Hier beginnen diejenigen Daten, die sich im Programmverlauf verändern...   *
********************************************************************************

                EVEN
                BSS
                EVEN
databss:                                ;Für kurze Referenzen via (A5)

                >PART 'Flags'

ctrlz:          DS.B 1                  ;Flag, ob EOF (Ctrl-Z) am Fileende gelöscht wurde
ctrlj:          DS.B 1                  ;Flag, ob LF (Ctrl-J) angehängt wurde
beenhere:       DS.B 1                  ;Schon einmal dargestellt?
endfound:       DS.B 1                  ;findend schon einmal aufgerufen?

flag:
NULflag:        DS.B 1                  ;Flag, ob M.S.-NUL (=-1) oder M.W.-NUL (=0)
WPflag:         DS.B 1                  ;Flag, ob WordPlus-Format
DUMPflag:       DS.B 1                  ;Flag, ob CR/LF interpretiert werden sollen
INVERTflag:     DS.B 1                  ;Flag, ob Bildschirm invertiert ist
TABflag:        DS.B 1                  ;Flag, ob TAB als Uhr oder als mehrere Spaces
TABmask:        DS.B 1                  ;AND-Maske für Tabulatorgrössen
printMEM:       DS.B 1                  ;Flag, ob geladener Text gedruckt wird
                EVEN
fsavarea:
                DS.B fsavarea-flag      ;Zwischenspeicher für obige Flags

                ENDPART
                >PART 'Cursorposition'
                EVEN                    ;Um beide gleichzeitig zu adressieren
crspos:
crslin:         DS.B 1
crscol:         DS.B 1
maxpos:
maxlin:         DS.B 1
maxcol:         DS.B 1

                ENDPART

********************************************************************************

rptcount:       DS.W 1                  ;Wiederholparameter für mainloop
rptadr:         DS.L 1                  ;Was wiederholen?
pictype:        DS.L 1                  ;Adresse der Bildroutine

********************************************************************************

maxsave:        DS.W 1                  ;Speicher für "Bildschirmgrösse"
alnatcrs:       DS.W 1                  ;Cursorposition (x,y) von alnat
alnatpos:       DS.L 1                  ;Memoryposition von alnat

numlines:       DS.L 1                  ;Anzahl der Zeilen
nowline:        DS.L 1                  ;Aktuelle Zeilennummer
savnowln:       DS.L 1                  ;Speichern (während filprt/blkprt)

                >PART 'Screen/Font'

fontadr:        DS.L 1
screen:         DS.L 1
cursor:         DS.L 1
lineaptr:       DS.L 1                  ;Zeiger auf die Line-A-Variablen
v_planes:       DS.W 1                  ;Anzahl Planes: Line-A-INQ_TAB[4]
v_planes_1:     DS.W 1
v_planes__2:    DS.W 1                  ;Anzahl Planes*2
v_cel_ht:       DS.W 1                  ;Höhe eines Zeichens
v_cel_ht_1:     DS.W 1
v_cel_w:        DS.W 1                  ;Maximale Cursorposition (X)
v_cel_w_1:      DS.W 1
v_cel_h:        DS.W 1                  ;Maximale Cursorposition (Y)
v_cel_h_1:      DS.W 1
v_cel_wr:       DS.W 1                  ;[V_CEL_HT]*[BYTES_LIN]
bytes_lin:      DS.W 1                  ;Bytes pro Pixelzeile
bytes_lin_1:    DS.W 1

                ENDPART

                >PART 'Bildinformation/-speicher'
pi3head:        DS.W 1                  ;1 Wort (Auflösungskennung für DEGAS)
pi3col:         DS.W 16

colorsav:       DS.W 16                 ;Farben vor dem Eintritt in GUCK

picmfdb:                                ;MFDB für das Bild
fd_addr:        DS.L 1                  ;Zeiger auf die Bilddaten
fd_w:           DS.W 1                  ;Breite und Höhe des Bildes
fd_h:           DS.W 1
fd_wdwidth:     DS.W 1                  ;Breite in Words
fd_stand:       DS.W 1                  ;Standard?
fd_nplanes:     DS.W 1                  ;Anzahl Planes
                DS.W 3                  ;reserviert

screenmfdb:     DS.W 10                 ;MFDB für den Bildschirm

picmem1:        DS.L 1                  ;Zeiger auf allfälligen allozierten
picmem2:        DS.L 1                  ;...Bildspeicher

piccurxy:                               ;Zum Zugriff auf beide
piccurx:        DS.W 1                  ;aktuelle x/y-Positionen
piccury:        DS.W 1

paletteptr:     DS.L 1
                ENDPART

                >PART 'Editor'
gotobuf:        DS.B GOTOlen+1
findbuf:        DS.B FINDlen+1

editnum:        DS.B 1
noupcase:       DS.B 1
                EVEN
kbdtimeout:     DS.L 1
editmax:        DS.W 1
editpos:        DS.W 1
editbuf:        DS.L 1
editcurs:       DS.L 1

                ENDPART

                >PART 'Druckertreiber'
cfgmem:         DS.L 1
cfgptr1:        DS.L 1
cfgptr2:        DS.L 1

                ENDPART

consav:         DS.B 1

clearbuf:       DS.B 1                  ;Tastaturpuffer löschen
redrawit:       DS.B 1                  ;Gesetzt während Neuzeichnen des Schirms
infoline:       DS.B 180                ;Absolut maximale Zeilenlänge (126 Bytes
;                                        Kommandozeile, 3x10 Stellen Zahl und
;                                        noch einige Bytes hausgemachten Text)
alnat:          DS.B 11                 ;Actual Line Number As Text
savename:       DS.B 128                ;Dateiname des abzuspeichernden Bildes
forcesave:      DS.B 1                  ;Flag, ob unbedingt gesichert werden muss
                EVEN
filext:         DS.B 4                  ;Extension (z.B. ".TXT")


                EVEN
                >PART 'Speicher/Datei'
basepage:       DS.L 1

memfil:         DS.L 1                  ;Start des Speicherblockes für die Datei

filstrt:        DS.L 1                  ;Start of File
filend:         DS.L 1                  ;End of File

filpos1:        DS.L 1                  ;Top Position
filpos2:        DS.L 1                  ;Bottom Position of Displayed Area
savfpos1:       DS.L 1                  ;Save Top Position

fnameadr:       DS.L 1                  ;Adresse des Filenamens

fnamebuf:       DS.B 128                ;Buffer für den Dateinamen

                ENDPART
                EVEN
dta:            >PART 'DTA (Was denn sonst?)'
                DS.B 21                 ;Reserved
d_attrib:       DS.B 1                  ;Dateiattribut
d_time:         DS.W 1                  ;Zeit
d_date:         DS.W 1                  ;Datum
d_len:          DS.L 1                  ;Länge
d_name:         DS.B 14                 ;Name

                ENDPART

ioreck:         DS.L 1                  ;Adresse des IOREC für Tastatur

                >PART 'Errordiffusion/Farben'
diffbuf:        DS.W 320                ;Zeilenpuffer
                DS.W 1                  ;dummy
diffbuf1:       DS.W 641                ;Errorpuffer
                DS.W 1                  ;dummy

rez:            DS.W 1                  ;Auflösung
colorbuf:       DS.W 16                 ;Farbhelligkeit

                ENDPART
                >PART 'AES/VDI'
contrl:         DS.W 12
intin:          DS.W 128
ptsin:          DS.W 256
intout:         DS.W 128
ptsout:         DS.W 256

; AES
global:
ap_versi:       DS.W 1
ap_count:       DS.W 1
ap_id:          DS.W 1
ap_priva:       DS.L 1
ap_ptree:       DS.L 1
ap_resvd:       DS.W 30                 ;Vielleicht etwas gross...

addrin:         DS.L 64
addrout:        DS.L 64

msgbuff:        DS.W 8

vdihndl:        DS.W 1
vdi_w:          DS.W 1
vdi_h:          DS.W 1
vdifakt:        DS.W 2                  ;1. Word für MULS, 2. Word für DIVS
switchcnt:      DS.W 1                  ;Wann wieder auf alle Fälle geswitcht wird
evnt_delay:     DS.W 1                  ;Wartezeit für evnt_multi()

                ENDPART
                >PART 'Stack'
; Stack
stackbottom:    EVEN
                DS.B stacksiz
stack:          DS.L 1
                ENDPART

                END
