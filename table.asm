; **************************************************
; *  table
; **************************************************

.data

.space table!row		1
.space table!column		1
.space table!index		1
.space table!counter		1

.text

; **************************************************
; *  macro
; **************************************************

.macro table@generate_index

	lda table!column
	beq _@1
	
	asl
	asl
	asl
	
_@1:	clc
	adc table!row
	sta table!index

.macend

; **************************************************
; *  macro
; **************************************************

.macro table@increment_row 

	inc table!row
	inc table!index

.macend

; **************************************************
; *  macro
; **************************************************

.macro table@increment_column 

	inc table!column
	
	lda table!index
	clc
	adc #$08
	sta table!index
	
.macend

; **************************************************
; *  method
; **************************************************

table@set_pointer:
.scope

	lda matrix!x+$01
	cmp matrix!width
	bcs _@1	

	lda matrix!y+$01
	cmp matrix!height
	bcc _@2

_@1:	lda #<matrix00!default
	ldx #>matrix00!default

	sta table!pointer
	stx table!pointer+$01
	
	sta table!attribute_pointer
	stx table!attribute_pointer+$01
	
	rts

_@2:	lda matrix!index
	asl
	
	tay
	lda (matrix!pointer), y
	sta table!pointer
	
	lda (matrix!attribute_pointer), y
	sta table!attribute_pointer
	
	iny
	lda (matrix!pointer), y
	sta table!pointer+$01

	lda (matrix!attribute_pointer), y
	sta table!attribute_pointer+$01
	
	rts
	
.scend

; **************************************************
; *  method
; **************************************************

table@get_row:
.scope

	lda #$00
	sta table!counter

_@1:	jsr table@set_pointer
	`table@generate_index
	
_@2:	ldy table!index
	lda (table!pointer), y
	
	pha
	lda (table!attribute_pointer), y

	ldy table!counter
	; sta horizontal!attribute, y
	
	pla
	sta table!array, y
	
	`table@increment_row
	
	inc table!counter
	lda table!counter
	cmp #$0a
	bcs _@3
	
	lda table!row
	cmp #$08
	bcc _@2
	
	lda #$00
	sta table!row
	
	`matrix@increment_row
	jmp _@1
	
_@3:	rts

.scend

; **************************************************
; *  method
; **************************************************

table@get_column:
.scope

	lda #$00
	sta table!counter

_@1:	jsr table@set_pointer
	`table@generate_index
	
_@2:	ldy table!index
	lda (table!pointer), y
	
	pha
	lda (table!attribute_pointer), y

	ldy table!counter
	; sta vertical!attribute, y
	
	pla
	sta table!array, y
	
	`table@increment_column
	
	inc table!counter
	lda table!counter
	cmp #$0a
	bcs _@3
	
	lda table!column
	cmp #$08
	bcc _@2
	
	lda #$00
	sta table!column
	
	`matrix@increment_column
	jmp _@1
	
_@3:	rts

.scend