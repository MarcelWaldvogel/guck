********************************************************************************
*                                                                              *
*                               A U S G U C K   V 1 . 5 a                      *
*                                                                              *
********************************************************************************
*                                                                              *
*                          Nur-Lese-Ramdisk, die schon GUCK enthält            *
*                                                                              *
********************************************************************************

magic       equ 'AgK0'

etv_critic  equ $0404
hdv_bpb     equ $0472
hdv_rw      equ $0476
hdv_medi    equ $047E

_nflops     equ $04A6
drvbits     equ $04C2


maxdrv      equ 15              ; Höchste Laufwerksnummer


BEL         equ 7
LF          equ 10
CR          equ 13
ESC         equ 27


            output 'D:\GUCK\GUCK\AUSGUCK.PRG'
            opt F+
            default 2

;
; Erzeugt Programmheader wie folgt:
; bra.s start
; dc.b  "$Header: <prog>, <version>, <date> <time> mw$",0
; even
;
            bra.s   start
            dc.b "$header: AusGUCK, V1.5a, "
dummy       set ^^DATE&$1F      ; Tag
            dc.b (dummy/10)+'0',(dummy%10)+'0','.'
dummy       set (^^DATE>>5)&$0F ; Monat
            dc.b (dummy/10)+'0',(dummy%10)+'0','.'
dummy       set (^^DATE>>9)&$7F+80 ; Jahr
            if dummy>=100
            dc.b '20'           ; Jahr 2000 etc.
dummy       set dummy-100
            else
            dc.b '19'           ; Jahr 1900 etc.
            endc
            dc.b (dummy/10)+'0',(dummy%10)+'0',' '

dummy       set (^^TIME>>11)&$1F ; Stunde
            dc.b (dummy/10)+'0',(dummy%10)+'0',':'
dummy       set (^^TIME>>5)&$3F ; Minute
            dc.b (dummy/10)+'0',(dummy%10)+'0',':'
dummy       set (^^TIME<<1)&$3F ; Sekunde
            dc.b (dummy/10)+'0',(dummy%10)+'0'

            dc.b " mw$",0
            even


start:      movea.l 4(A7),A5
            movea.w #$0100,A6
            adda.l  12(A5),A6
            adda.l  20(A5),A6
            adda.l  28(A5),A6           ; Platz im Speicher

            pea     init(PC)
            move.w  #38,-(A7)           ; Supexec
            trap    #14
            addq.l  #6,A7

            tst.b   erfolg
            beq.s   abort

            pea     oktext
            move.w  #9,-(A7)            ; Printline
            trap    #1
            addq.l  #6,A7

            clr.w   -(A7)
            move.l  A6,-(A7)
            move.w  #49,-(A7)           ; Ptermres
            trap    #1

abort:      pea     errtext
            move.w  #9,-(A7)            ; Printline
            trap    #1
            addq.l  #6,A7

            move.w  #-2,-(A7)           ; Fehler ("Drive not Ready")
            move.w  #76,-(A7)
            trap    #1

********************************************************************************

init:       move.l  drvbits.w,D0
            move.w  driveno,D1
            add.b   D1,errdrv
            cmp.w   #1,D1               ; Soll AusGUCK Drive B werden?
            bne.s   nxtdrv
            cmpi.w  #2,_nflops.w        ; Und gibt es den nicht wirklich?
            bne.s   foundb              ; Ja, wir haben es! (auch vormerken!)
nxtdrv:     bset    D1,D0               ; Z-Bit = Status VORHER!!
            beq.s   found
            addq.w  #1,D1
            cmpi.w  #maxdrv,D1
            bls.s   nxtdrv
            sf      erfolg
            rts

foundb:
*           move.w  #2,_nflops.w        ; Vorsichtshalber ausmaskiert
found:      move.l  D0,drvbits.w
            move.w  D1,driveno
            add.b   D1,oktxtdrv
            st      erfolg
            move.w  #2,defmed           ; Diskette sicher gewechselt

            move.l  hdv_bpb.w,bpbvec    ; In die Vektoren einhängen!
            move.l  #bpb,hdv_bpb.w
            move.l  hdv_rw.w,rwvec
            move.l  #rw,hdv_rw.w
            move.l  hdv_medi.w,medivec
            move.l  #medi,hdv_medi.w

            rts

********************************************************************************


            dc.l 'XBRA',magic
bpbvec:     dc.l 0
bpb:        move.w  driveno,D0
            cmp.w   4(A7),D0
            beq.s   bpb1
            movea.l bpbvec(PC),A0
            jmp     (A0)

bpb1:       clr.w   defmed              ; Hier mediachange-Status zurücksetzen
            move.l  #bpbtab,D0
            rts

********************************************************************************

            dc.l 'XBRA',magic
medivec:    dc.l 0
medi:       move.w  driveno,D0
            cmp.w   4(A7),D0
            beq.s   med1
            movea.l medivec(PC),A0
            jmp     (A0)

med1:       move.w  defmed,D0
            rts

********************************************************************************

            dc.l 'XBRA',magic
rwvec:      dc.l 0
rw:         move.w  driveno,D0
            cmp.w   14(A7),D0
            beq.s   rw1
            movea.l rwvec(PC),A0
            jmp     (A0)

rw1:        tst.l   6(A7)               ; Media-Change-Status setzen?
            bne.s   rw2                 ; Nein, normal
            move.w  10(A7),defmed       ; Ja, Media-Change-Status übernehmen...
            rts

rw2:        move.w  4(A7),D0
            btst    #0,D0               ; Schreiben?
            bne.s   errwrit             ; nicht möglich!
            tst.w   defmed              ; Media Change?
            beq.s   rw3                 ; Nein, dann lesen!
            btst    #1,D0               ; Ignore Media Change?
            bne.s   rw3                 ; Ja, dann eben lesen!
            moveq   #-14,D0             ; Sonst Fehler!
            rts

rw3:        moveq   #0,D0
            move.w  12(A7),D0           ; Sektor #
            subq.w  #4,D0
            bcc.s   rwguck              ; Sektor >= 4
            lsl.w   #2,D0               ; x4
            lea     secttblx,A0
            movea.l 0(A0,D0.w),A0       ; Hole Adresse des Sektors
            bra.s   rwboth

rwguck:     lea     guck,A0
            lsl.l   #8,D0               ; x512
            add.l   D0,D0               ; "
            adda.l  D0,A0

rwboth:     move.w  10(A7),D0           ; Anzahl Sektoren
            subq.w  #1,D0
            movea.l 6(A7),A1            ; Destination

rwl1:       move.w  #511,D1             ; kopiere "Sektor(en)"
rwl2:       move.b  (A0)+,(A1)+
            dbra    D1,rwl2
            dbra    D0,rwl1
*            cmpa.l  #guckx,A0           ; Vorsichtshalber ausmaskiert
*            bcs.s   rwok                ; Kleiner, also normal beenden
*            move.w  #2,defmed           ; Sonst Media Change setzen...

rwok:       moveq   #0,D0               ; No error
            rts


errwrit:    moveq   #-13,D0             ; "Diskette schreibgeschützt"
            movem.l D2-D7/A2-A6,-(A7)
            move.w  driveno,-(A7)
            move.w  #-13,-(A7)          ; Write-Protect
more_e:     movea.l etv_critic.w,A0
            jsr     (A0)                ; etv_critic aufrufen
            cmp.l   #$010000,D0         ; WEITER angeklickt?
            beq.s   more_e              ; dann nochmal diesen Alert
            addq.l  #4,A7
            movem.l (A7)+,D2-D7/A2-A6
            rts

********************************************************************************

            even
            data
            even

            dc.l magic
driveno:    dc.w 15             ; Drive P


oktext:     dc.b CR,LF," AusGUCK als Laufwerk "
oktxtdrv:   dc.b "A: installiert!",CR,LF,0

errtext:    dc.b CR,LF,BEL," Wunschlaufwerk "
errdrv:     dc.b "A: und alle darüber besetzt!",CR,LF,0

*exittext:   dc.b CR,LF,BEL," AusGUCK wieder entfernt!",CR,LF,0

*badtext:    dc.b CR,LF,BEL,ESC,'p'," FATALER FEHLER! ",ESC,'q'
*            dc.b CR,LF,BEL," AusGUCK-Vektoren korrupt!",CR,LF,0


            even
bpbtab:
recsiz:     dc.w 512
clsiz:      dc.w 2
clsizb:     dc.w 1024
rdlen:      dc.w 1
fsiz:       dc.w 1
fatrec:     dc.w 2
datrec:     dc.w 4
numcl:      dc.w guckclus
flags:      dc.w 0              ; RAMdisk wäre eigentlich 8, aber...
;                                 (z.B. TURBODOS und CHKDISK)

secttbl:    dc.l bootsect,fatsect,fatsect,dirsect
secttblx:

********************************************************************************

bootsect:   dc.b 0,0
            dc.b "Loader"
            opt W-
            dc.b "mw!"          ;Serial
            opt W+
            dc.b 0,2            ;BPS
            dc.b 2              ;SPC
            dc.b 1,0            ;RES
            dc.b 2              ;FAT
            dc.b 16,0           ;DIR
            dc.b (2*guckclus)&$FF+4,(2*guckclus)>>8 ; SEC
            dc.b 0              ;MEDIA
            dc.b 1,0            ;SPF
            dc.b 9,0            ;SPT
            dc.b 2,0            ;SIDE
            dc.b 0,0            ;HID

            even

* Diese Daten ab hier ...
fatsect:    dc.b $F7,$FF,$FF,$03,$40,$00,$05,$60
            dc.b $00,$07,$80,$00,$09,$A0,$00,$0B
            dc.b $F0,$FF,$00,$00,$00,$00,$00,$00

            even

            opt W-
dirsect:    dc.b "G","U","C","K"," "," "," "," " ; "filename"
            dc.b "T","T","P",$01,$00,$00,$00,$00 ; "ext" und Attribut (R/O)
            dc.b $00,$00,$00,$00,$00,$00 ; reserved for future use...
            dc.b ^^TIME&$FF,^^TIME>>8 ; Zeit und ...
            dc.b ^^DATE&$FF,^^DATE>>8 ; ... Datum (8088)
            dc.b $02,$00        ; Starting Cluster (8088)
            dc.b gucks&$FF,gucks>>8,gucks>>16,gucks>>24 ; Grösse (8088)
            opt W+

            dcb.b 32            ; End of Directory

            even
guck:       ibytes 'C:\UTIL\GUCK.TTP'
guckx:
gucks       equ guckx-guck
guckclus    equ (gucks+1023)>>10

********************************************************************************

            even
            bss
            even

erfolg:     ds.b 1              ; Installieren geglückt?

            even
bpbsave:    ds.l 1
rwsave:     ds.l 1
medisave:   ds.l 1

defmed:     ds.w 1              ; Default-Media-Change-Status
            end
