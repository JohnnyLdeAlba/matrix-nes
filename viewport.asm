; **************************************************
; *  viewport
; **************************************************

.data

.space viewport!id			1

.space viewport!x			2
.space viewport!y			2
.space viewport!local_y			1

.text

; **************************************************
; *  macro
; **************************************************

.macro viewport@increment_local_y

	.alias _!result $24
	
	lda _!result
	clc
	adc viewport!local_y
	
	cmp #$f0
	bcc _@1
	
	and #$0f
_@1:	sta viewport!local_y

.macend

; **************************************************
; *  macro
; **************************************************

.macro viewport@decrement_local_y

	.alias _!result $24

	lda viewport!local_y
	sec
	sbc _!result
	
	cmp #$f0
	bcc _@1
	
	and #$ef
_@1:	sta viewport!local_y

.macend

; **************************************************
; *  macro
; **************************************************

.macro viewport@invalidate_left

	lda viewport!x
	and #%00000111
	bne _@1
	
	lda nametable!state
	ora #nametable!left
	sta nametable!state
	
_@1:

.macend

; **************************************************
; *  macro
; **************************************************

.macro viewport@invalidate_right

	lda viewport!x
	and #%00000111
	bne _@1
	
	lda nametable!state
	ora #nametable!right
	sta nametable!state
	
_@1:

.macend

; **************************************************
; *  macro
; **************************************************

.macro viewport@invalidate_up

	lda viewport!y
	and #%00000111
	bne _@1
	
	lda nametable!state
	ora #nametable!up
	sta nametable!state
	
_@1:

.macend

; **************************************************
; *  macro
; **************************************************

.macro viewport@invalidate_down

	lda viewport!y
	and #%00000111
	bne _@1
	
	lda nametable!state
	ora #nametable!down
	sta nametable!state
	
_@1:

.macend

; **************************************************
; *  method
; **************************************************

viewport@increment_x:
.scope

	.alias _!result $20
	.alias _!width $21

	sta _!result
	
	ldx matrix!width
	dex
	sta _!width
	
	lda viewport!x+$01
	cmp _!width
	beq _@2	;	bcs
	
	lda viewport!x
	clc
	adc _!result
	sta viewport!x
	
	bcc _@1

	inc viewport!x+$01
	
_@1:	`viewport@invalidate_right
_@2:	rts

.scend

; **************************************************
; *  method
; **************************************************

viewport@decrement_x:
.scope

	.alias _!result $20
	sta _!result
	
	lda viewport!x+$01
	bne _@1

	lda viewport!x
	beq _@3

_@1:	lda viewport!x
	sec
	sbc _!result
	sta viewport!x
	
	bcs _@2
	
	lda viewport!id
	eor #$01
	sta viewport!id
	
	dec viewport!x+$01
	
_@2:	`viewport@invalidate_left
_@3:	rts

.scend

; **************************************************
; *  method
; **************************************************

viewport@increment_y:
.scope

	.alias _!result $24
	.alias _!height $25

	sta _!result
	
	ldx matrix!height
	dex
	sta _!height
	
	lda viewport!y+$01
	cmp _!height
	beq _@2		; bcs
	
	lda viewport!y
	clc
	adc _!result
	sta viewport!y
	
	bcc _@1
	
	inc viewport!y+$01
	
_@1:	`viewport@increment_local_y
	`viewport@invalidate_down
	
_@2:	rts

.scend

; **************************************************
; *  method
; **************************************************

viewport@decrement_y:
.scope

	.alias _!result $24
	sta _!result
	
	lda viewport!y+$01
	bne _@1

	lda viewport!y
	beq _@3
	
_@1:	lda viewport!y
	sec
	sbc _!result
	sta viewport!y
	
	bcs _@2
	
	dec viewport!y+$01
	
_@2:	`viewport@decrement_local_y
	`viewport@invalidate_up
	
_@3:	rts

.scend

