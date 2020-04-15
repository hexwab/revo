in = $80
count = $82

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

MACRO set_timer n
	lda #<(n-2)
	sta $fe66
	lda #>(n-2)
	sta $fe67
ENDMACRO

MACRO PAGE_ALIGN_FOR_SIZE n
;FIXME
ENDMACRO

	ORG $1e00
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
	
        lda $204
        sta oldirq+1
        lda $205
        sta oldirq+2
        lda #<irq
        sta $204
        lda #>irq
        sta $205
        lda #$7f ; all interrupts off
        sta $fe6e
        lda #$40 ; enable continuous interrupts for ut1
        sta $fe6b
        lda #1 ; start soon
        sta $fe64
        sta $fe65
        ;lda $fe68 ; clear ut2

	; enable timer
	lda #$c0 ; uservia_timer1
	sta $fe6e
	jsr init
	cli
	rts

.init
	lda #0
	sta in
	lda #$20
	sta in+1
	lda #67
	sta count
	set_timer 1e6*181/12000
	rts
	
.irq
        lda $fe6d
        bmi uservia
.oldirq
        jmp $eeee

.uservia
	and $fe6e
        and #$40
	beq oldirq
	lda $fe64 ;clear

	stx xtmp+1
	sty ytmp+1
.do_squirt
	; send 256 writes, 128 bytes, 85.33 samples
	ldy #255
    	sty &fe43
.lastx	ldx #0
	iny
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
	bpl loop2 ;3

	stx lastx+1
	lda in
	eor #$80
	sta in
	bne noinc
	inc in+1
.noinc
	ldx count
	cpx #52
	bne notweak
	set_timer 1e6*162/12000
.notweak
	dex
	stx count
	bne ret

.done
IF 1 ; loop?
	jsr init
ELSE
	lda #$40
	sta $fe6e
	sta $fe6d ;clear
ENDIF	
.ret
.xtmp	ldx #0
.ytmp	ldy #0
	lda $fc
	rti
.loop2
	nop
	jmp loop


PAGE_ALIGN_FOR_SIZE 3
.mask
	equb $d0,$b0,$90
PAGE_ALIGN_FOR_SIZE 3
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
;INCBIN "rev.pcmenc"
INCBIN "rev12.nogaps.wav.pcmenc"
PUTFILE "/home/HEx/ClockSp","ClockSp",$ff0e00,$ff8023	
.end
SAVE "revo",play,end
