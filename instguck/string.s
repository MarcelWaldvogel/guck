                EXPORT strcat

strcat:         move.l  A0,D0
sc_l1:          tst.b   (A0)+
                bne.b   sc_l1
                subq.w  #1,A0
sc_l2:          move.b  (A1)+,(A0)+
                bne.b   sc_l2
                movea.l D0,A0
                rts

********************************************************************************
                EXPORT strcmp

strcmp:         move.b  (A0)+,D0
                beq.b   sc_eos2         ;Stringende? Ja =>
                cmp.b   (A1)+,D0
                beq.b   strcmp          ;Gleich => weiter
                bcs.b   sc_retless      ;Kleiner =>
                moveq   #1,D0
                rts
sc_eos2:        tst.b   (A1)            ;Beide zuende?
                bne.b   sc_retless      ;Nein => kleiner
                moveq   #0,D0           ;Ja, gleich
                rts
sc_retless:     moveq   #-1,D0
                rts

********************************************************************************
                EXPORT strcpy

strcpy:         move.l  A0,D0
sc_l3:          move.b  (A1)+,(A0)+
                bne.b   sc_l3
                movea.l D0,A0
                rts

********************************************************************************
                EXPORT strlen

strlen:         move.l  A0,D0           ;start sichern
sl_l1:          tst.b   (A0)+
                bne.b   sl_l1
                sub.l   A0,D0           ;diff = start - (ende + 1)
                not.l   D0              ;diff = (ende + 1) - start - 1
                rts                     ;diff = ende - start

