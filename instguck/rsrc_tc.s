;
; Resourcen einbinden
;
; Version für TurboC
;
; Assemblerversion: Marcel Waldvogel
; Idee: mrsrc_load aus Laser C
;
; 08.02.90 mw Angepasst an _GemParBlk-Struktur des TC 2.0
; 20.07.90 mw Aufgeteilt in mrsrc_load und mrsrc_install
; 12.08.90 mw mrsrc_gaddr() eingeführt, Relozierfehler behoben
;
; Aufrufe: (Parameter je in A0)
;
; void mrsrc_load(int rsc_buffer[], int fontw, int fonth);
; void mrsrc_gaddr(void *rsc, int type, int index, void **ptr);
;

		.xdef mrsrc_load, mrsrc_gaddr

		.xref graf_handle, rsrc_gaddr
		.xref _GemParBlk
		.xref rsc_loaded


global		= 30 ; Offset des global-Arrays relativ zu _GemParBlk
		;TC 1.0: 22, TC 2.0: 30

		;rsrc_gaddr()-Opcodes
R_TREE		= 0
R_STRING	= 5

		;Der Resource-Header besteht aus:
rsh_vsrn	= 0
rsh_object	= 2
rsh_tedinfo	= 4
rsh_iconblk	= 6
rsh_bitblk	= 8
rsh_frstr	= 10
rsh_string	= 12
rsh_imdata	= 14
rsh_frimg	= 16
rsh_trindex	= 18
rsh_nobs	= 20
rsh_ntree	= 22
rsh_nted	= 24
rsh_nib 	= 26
rsh_nbb 	= 28
rsh_nstring	= 30
rsh_nimages	= 32
rsh_rssize	= 34

		;Ein Objekt besteht aus:
ob_next 	= 0
ob_first	= 2
ob_last 	= 4
ob_type 	= 6
ob_flags	= 8
ob_state	= 10
ob_spec 	= 12	;LONG!!
ob_x		= 16
ob_y		= 18
ob_width	= 20
ob_height	= 22

		;******************************************************************

mrsrc_gaddr:	moveq	#0,D2
		cmp.l	D2,A0			;Eigener Baum angegeben?
		beq	go_rsrc_gaddr		;Nein ->
		move.w	rsh_trindex(A0),D2	;Default
		tst.w	D0			;R_TREE
		beq	getitem
		move.w	rsh_frstr(A0),D2	;Default
		cmp.w	#R_STRING,D0
		bne	ret			;Ja, R_STRING!

getitem:	adda.l	D2,A0			;Zum Baumanfang
		lsl.w	#2,D1			;4*index
		adda.w	D1,A0
		move.l	(A0),(A1)		;Zeiger zurückgeben
ret:		rts

go_rsrc_gaddr:	move.l	A1,A0			;Rückgabewert
		jmp	rsrc_gaddr

**********************************************************************

mrsrc_load:	movem.l d5-d7/a5,-(a7)	;Sichern
		movea.l a0,a5		;Bufferadresse
		move.w	d0,d5		;Zeichenbreite
		move.w	d1,d6		;Zeichenhöhe

		;******************************************************************

rel_tree:	moveq.l #0,d0 			;Unsigned Extend
		move.w	rsh_trindex(a5),d0
		lea	0(a5,d0.l),a0		;Adresse der Baumtabelle
		move.w	rsh_ntree(a5),d7
		subq.w	#1,d7
		bcs	rel_obj
		move.l	a5,d0
treeloop:	add.l	d0,(a0)+
		dbf	d7,treeloop

		;******************************************************************

rel_frstr:	moveq.l #0,d0 			;Unsigned Extend
		move.w	rsh_frstr(a5),d0
		lea	0(a5,d0.l),a0		;Adresse der Stringtabelle
		move.w	rsh_nstring(a5),d7
		subq.w	#1,d7
		bcs	rel_obj
		move.l	a5,d0
strloop:	add.l	d0,(a0)+
		dbf	d7,strloop

		;******************************************************************

rel_obj:	moveq.l #0,d0
		move.w	rsh_object(a5),d0
		lea	0(a5,d0.l),a0
		move.w	rsh_nobs(a5),d7
		subq.w	#1,d7
		bcs	rel_ted
		moveq.l #0,d0
objloop:	move.w	ob_type(a0),d0

; Bytevergleiche wegen Extended Object Types
		cmpi.b	#21,d0	;21-23
		bcs	norelobspec
		cmpi.b	#23,d0
		bls	relobspec

		cmpi.b	#26,d0	;26
		beq	relobspec

		cmpi.b	#28,d0	;28-32
		bcs	norelobspec
		cmpi.b	#32,d0
		bhi	norelobspec

relobspec:	move.l	a5,d0
		add.l	d0,ob_spec(a0)

norelobspec:	lea	ob_x(a0),a1
		move.w	d5,d0
		bsr	obfix

		lea	ob_y(a0),a1
		move.w	d6,d0
		bsr	obfix

		lea	ob_width(a0),a1
		move.w	d5,d0
		bsr	obfix

		lea	ob_height(a0),a1
		move.w	d6,d0
		bsr	obfix

		lea	24(a0),a0
		dbf	d7,objloop

		;******************************************************************

rel_ted:	moveq.l #0,d0
		move.w	rsh_tedinfo(a5),d0
		lea	0(a5,d0.l),a0
		move.w	rsh_nted(a5),d7
		subq.w	#1,d7
		bcs	rel_ib
tedloop:	move.l	a5,d0
		add.l	d0,(a0)+
		add.l	d0,(a0)+
		add.l	d0,(a0)
		lea	28-8(a0),a0	;Insgesamt pro Durchgang +28
		dbf	d7,tedloop

rel_ib: 	moveq.l #0,d0
		move.w	rsh_iconblk(a5),d0
		lea	0(a5,d0.l),a0
		move.w	rsh_nib(a5),d7
		subq.w	#1,d7
		bcs	rel_bb
		move.l	a5,d0
ibloop: 	add.l	d0,(a0)+
		add.l	d0,(a0)+
		add.l	d0,(a0)
		lea	34-8(a0),a0
		dbf	d7,ibloop

rel_bb: 	moveq.l #0,d0
		move.w	rsh_bitblk(a5),d0
		lea	0(a5,d0.l),a0
		move.w	rsh_nbb(a5),d7
		subq.w	#1,d7
		bcs	mrl_ret
		move.l	a5,d0
bbloop: 	add.l	d0,(a0)
		lea	14(a0),a0
		dbf	d7,bbloop

mrl_ret:	movem.l (a7)+,d5-d7/a5
		rts	

		;******************************************************************

		;Subroutine "obfix": multipliziert das, wohin A1 zeigt, mit D0
		;(ändert D0/D1)
obfix:		move.w	(a1),d1
		ext.w	d1		;Nur Low-Byte (Zeichenposition)
		muls.w	d0,d1 		;Mal Zeichengrösse
		move.b	(a1),d0		;Nur High-Byte (Pixeloffset)
		ext.w	d0		;...als Word
		add.w	d0,d1 		;...als Offset
		move.w	d1,(a1)		;...und alles zusammen zurück
		rts

