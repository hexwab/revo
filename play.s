in = $80
	ORG $1f00
MACRO strobe
{
	ora mask,X ;4
	sta &fe4f  ;4
    	lda #0     ;2
    	sta &fe40  ;4
	lda inc,X  ;4
	tax 	   ;2
    	lda #8	   ;2
FOR i,0,2
	nop
NEXT
	sta &fe40  ;4
}
ENDMACRO

.play
	sei
	lda #255
    	sta &fe43
	ldx #3
.initloop
	lda mask,X
	eor #$11
	jsr strobe2
	lda #0
	jsr strobe2
	dex
	bpl initloop
	
	lda #0
	sta in
	lda #$20
	sta in+1
	ldx #0
	ldy #0
.loop2
	nop
	nop
	nop
	nop
.loop
	lda (in),Y ;5 
	lsr a      ;8
	lsr a
	lsr a
	lsr a
	strobe ; 44
	lda (in),Y ;5
	and #$0f   ;8
	nop
	nop
	nop
	strobe ; 44
	iny ;2
	bne loop2 ;3
	inc in+1 ;5
	lda in+1 ;3
	cmp #<$60 ;2
	bne loop ;3
	cli
	rts

.mask
	equb $d0,$b0,$90
.inc
	equb 1,2,0
.strobe2
	sta $fe4f
	lda #0
	sta $fe40
	php
	plp
	lda #8
	sta $fe40
	rts

ORG $2000
INCBIN "rev.pcmenc"
.end
SAVE "revo",play,end
