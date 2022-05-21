; **************************************************
; *  matrix
; **************************************************

.data

.alias nametable!pointer		$90
.alias attribute!pointer		$92

.alias matrix!pointer			$94
.alias matrix!attribute_pointer		$96

.alias table!pointer			$98
.alias table!attribute_pointer		$9a

.alias cell!pointer			$9c

.alias table!array			$a0

.alias horizontal!attribute		$aa
.alias vertical!attribute		$b4

.alias horizontal!array			$c0
.alias vertical!array			$e0

.space matrix!x				2
.space matrix!y				2
.space matrix!width			1
.space matrix!height			1
.space matrix!index			1

.space horizontal!id			1
.space horizontal!row 			1
.space horizontal!column 		1

.space vertical!id			1
.space vertical!row 			1
.space vertical!column 			1

.text

; **************************************************
; *  macro
; **************************************************

.macro matrix@translate_x

	.alias _!result $20

	clc
	lda matrix!x
	
	lsr
	lsr
	lsr
	
	sta tile!row
	sta nametable!row
	
	and #%11111100
	sta _!result
	
	lsr
	lsr

	sta table!row
	sta attribute!row

	lda tile!row
	sec
	sbc _!result
	sta cell!row
	
.macend

; **************************************************
; *  macro
; **************************************************

.macro matrix@translate_y

	.alias _!result $20

	clc
	lda matrix!y
	
	lsr
	lsr
	lsr
	
	sta tile!column
	
	and #%11111100
	sta _!result
	
	lsr
	lsr

	sta table!column
	sta attribute!column

	lda tile!column
	sec
	sbc _!result
	sta cell!column
	
.macend

; **************************************************
; *  macro
; **************************************************

.macro matrix@generate_index

	lda matrix!y+$01
	beq _@2

	lda #$00
	ldx #$00
	
	clc
_@1:	adc matrix!width

	inx
	cpx matrix!y+$01
	bne _@1
	
_@2:	clc
	adc matrix!x+$01
	sta matrix!index

.macend

; **************************************************
; *  macro
; **************************************************

.macro matrix@increment_row

	lda #$00
	sta matrix!x

	inc matrix!x+$01
	inc matrix!index
	
.macend
	
; **************************************************
; *  macro
; **************************************************

.macro matrix@increment_column

	lda #$00
	sta matrix!y

	inc matrix!y+$01
	
	lda matrix!index
	clc
	adc matrix!width
	sta matrix!index
	
.macend

; **************************************************
; *  method
; **************************************************

matrix@initialize:
.scope

	`matrix@translate_x
	`matrix@translate_y
	`matrix@generate_index

	`nametable@translate_y
	
	rts
	
.scend