; **************************************************
; *  cell
; **************************************************

.data

.space tile!row				1
.space tile!column			1

.space cell!row				1
.space cell!column			1

.space cell!index			1
.space cell!counter			1

.text

; **************************************************
; *  macro
; **************************************************

.macro cell@set_pointer

	asl
	
	tay
	lda cell!vector, y
	sta cell!pointer
	
	iny
	lda cell!vector, y
	sta cell!pointer+$01

.macend

; **************************************************
; *  macro
; **************************************************

.macro cell@generate_index

	lda cell!column
	
	asl
	asl

	clc
	adc cell!row
	sta cell!index
	
.macend


; **************************************************
; *  macro
; **************************************************

.macro cell@increment_row

	inc cell!row
	inc cell!index

.macend

; **************************************************
; *  macro
; **************************************************

.macro cell@increment_column

	inc cell!column
	
	lda cell!index
	clc
	adc #$04
	sta cell!index

.macend

; **************************************************
; *  macro
; **************************************************

.macro cell@get_value

	ldy cell!index
	lda (cell!pointer), y

.macend

; **************************************************
; *  method
; **************************************************

cell@get_row:
.scope

	lda #$00
	
	sta table!counter
	sta cell!counter

_@1:	ldy table!counter
	lda table!array, y

	`cell@set_pointer
	`cell@generate_index
	
_@2:	`cell@get_value

	ldy cell!counter
	sta horizontal!array, y
	
	`cell@increment_row
	inc cell!counter
	
	lda cell!counter
	cmp #$20
	bcs _@3
	
	lda cell!row
	cmp #$04
	bcc _@2
	
	lda #$00
	sta cell!row
	
	inc table!counter
	lda table!counter
	
	cmp #$0a
	bcc _@1

_@3:	rts

.scend

; **************************************************
; *  method
; **************************************************

cell@get_column:
.scope

	lda #$00
	
	sta table!counter
	sta cell!counter

_@1:	ldy table!counter
	lda table!array, y

	`cell@set_pointer
	`cell@generate_index
	
_@2:	`cell@get_value
	ldy cell!counter
	sta vertical!array, y
	
	`cell@increment_column
	inc cell!counter
	
	lda cell!counter
	cmp #$20
	bcs _@3
	
	lda cell!column
	cmp #$04
	bcc _@2
	
	lda #$00
	sta cell!column
	
	inc table!counter
	lda table!counter
	
	cmp #$0a
	bcc _@1

_@3:	rts

.scend
