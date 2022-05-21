
.data

.alias nametable!mask_x		%00000011
.alias nametable!mask_y		%00001100

.alias nametable!zero_x		%11111100
.alias nametable!zero_y		%11110011

.alias nametable!left		%00000001
.alias nametable!right		%00000010
.alias nametable!up		%00000100
.alias nametable!down		%00001000

.space nametable!id		1
.space nametable!x		1
.space nametable!y		1

.space nametable!row 		1
.space nametable!column 	1

.space nametable!index		2
.space nametable!counter	1

.space nametable!op		1
.space nametable!state		1

.space attribute!id		1
.space attribute!row		1
.space attribute!column		1
.space attribute!index		1
.space attribute!counter	1

.text

; **************************************************
; *  macro
; **************************************************

.macro attribute@generate_index

	lda #$00
	sta attribute!index
	sta attribute!index+$01

	lda attribute!column
	beq _@2
	
	ldy #$00
	
	clc
_@1:	rol
	rol attribute!index+$01
	
	iny
	cpy #$03
	bne _@1
	
_@2:	clc
	adc attribute!row
	sta attribute!index
	
	lda attribute!index+$01
	adc #$00
	sta attribute!index+$01

.macend

; **************************************************
; *  method : a,x
; **************************************************

attribute@generate_pointer:
.scope

	`attribute@generate_index

	lda nametable!id
	asl
	asl
	
	clc
	adc #$23

	clc
	adc attribute!index+$01
	sta attribute!pointer+$01
	
	clc
	lda attribute!index
	adc #$c0
	sta attribute!pointer
	
	lda #$23
	ldx #$c0
	
	rts

.scend

; **************************************************
; *  method
; **************************************************

attribute@update_row:
.scope

	lda #%00000000
	sta $2000

	lda #$00
	sta attribute!counter
	
_@1:	jsr attribute@generate_pointer

	sta $2006
	stx $2006
	
	ldx attribute!row
	ldy attribute!counter
	
_@2:	lda $2007
	sta horizontal!attribute, y
	
	inx
	iny
	
	cpy #$08
	bcs _@3
	
	cpx #$08
	bne _@2

	ldx #$00
	stx attribute!row
	sty attribute!counter
	
	lda nametable!id
	eor #$01
	sta nametable!id
	
	jmp _@1
	
_@3:	rts	
	
.scend

; **************************************************
; *  macro
; **************************************************

.macro nametable@get_nametable_id

	lda matrix!x+$01
	and #$01
	sta nametable!id

.macend

; **************************************************
; *  component
; **************************************************

.macro nametable@get_cell_row

	lda viewport!x
	sta matrix!x
	sta nametable!x
	
	lda viewport!x+$01
	sta matrix!x+$01
	
	`nametable@get_nametable_id
	jsr matrix@initialize
	
	jsr table@get_row
	jsr cell@get_row
	
	lda nametable!id
	ldx nametable!row
	ldy nametable!column
	
	sta horizontal!id
	stx horizontal!row
	sty horizontal!column

.macend

; **************************************************
; *  component
; **************************************************

.macro nametable@get_cell_column

	lda viewport!y
	sta matrix!y
	
	lda viewport!y+$01
	sta matrix!y+$01
	
	lda viewport!local_y
	sta nametable!y

	`nametable@get_nametable_id
	jsr matrix@initialize

	jsr table@get_column
	jsr cell@get_column
	
	lda nametable!id
	ldx nametable!row
	ldy nametable!column
	
	sta vertical!id
	stx vertical!row
	sty vertical!column
	
.macend

; **************************************************
; *  macro
; **************************************************

.macro nametable@validate_x

	lda nametable!op
	and #nametable!mask_x
	beq _@direction_left
	
	jmp _@return

_@direction_left:
	
	lda nametable!state
	and #nametable!left
	beq _@direction_right
	
	lda viewport!x
	sta matrix!x
	sta nametable!x

	lda viewport!x+$01
	sta matrix!x+$01
	
	jmp _@update_column

_@direction_right:
	
	lda nametable!state
	and #nametable!right
	beq _@return
	
	lda viewport!x
	clc
	adc #$f8
	sta matrix!x
	sta nametable!x

	lda viewport!x+$01
	adc #$00
	sta matrix!x+$01
	
_@update_column:

	`nametable@get_cell_column

	lda #nametable!mask_x
	ora nametable!op
	sta nametable!op

_@return:
.macend

; **************************************************
; *  macro
; **************************************************

.macro nametable@validate_y

	lda nametable!op
	and #nametable!mask_y
	beq _@direction_up
	
	jmp _@return
	
_@direction_up:
	
	lda nametable!state
	and #nametable!up
	beq _@direction_down
	
	lda viewport!y
	sta matrix!y
	
	lda viewport!y+$01
	sta matrix!y+$01

	lda viewport!local_y
	sta nametable!y
	
	jmp _@update_row
	
_@direction_down:

	lda nametable!state
	and #nametable!down
	beq _@return
	
	lda viewport!y
	clc
	adc #$e8
	sta matrix!y

	lda viewport!y+$01
	adc #$00
	sta matrix!y+$01
	
	lda #$e8
	`nametable@increment_y
	
_@update_row:	

	`nametable@get_cell_row

	lda #nametable!mask_y
	ora nametable!op
	sta nametable!op
	
_@return:
.macend

; **************************************************
; *  macro (a)
; **************************************************

.macro nametable@increment_y

	clc
	adc viewport!local_y
	bcc _@1

	clc
	adc #$10
	
	jmp _@2
	
_@1:	cmp #$f0
	bcc _@2
	
	sec
	sbc #$f0
	
_@2:	sta nametable!y

.macend

; **************************************************
; *  macro (a)
; **************************************************

.macro nametable@decrement_y

	sec
	sbc viewport!local_y
	
	cmp #$f0
	bcc _@1
	
	sec
	sbc #$f0
_@1:	sta nametable!y

.macend

; **************************************************
; *  macro
; **************************************************

.macro nametable@translate_y

	lda nametable!y
	
	lsr
	lsr
	lsr
	
	sta nametable!column
	
.macend

; **************************************************
; *  macro
; **************************************************

.macro nametable@update_position

	lda $2002

	lda viewport!x
	ldx viewport!local_y
	
	sta $2005
	stx $2005

.macend

; **************************************************
; *  macro
; **************************************************

.macro nametable@generate_index

	lda #$00
	sta nametable!index
	sta nametable!index+$01

	lda nametable!column
	beq _@2
	
	ldy #$00
	
	clc
_@1:	rol
	rol nametable!index+$01
	
	iny
	cpy #$05
	bne _@1
	
_@2:	clc
	adc nametable!row
	sta nametable!index
	
	lda nametable!index+$01
	adc #$00
	sta nametable!index+$01

.macend

; **************************************************
; *  method
; **************************************************

nametable@update:
.scope

	`nametable@validate_x
	`nametable@validate_y

	rts
	
.scend

; **************************************************
; *  method : a,x
; **************************************************

nametable@generate_pointer:
.scope

	`nametable@generate_index

	lda nametable!id
	asl
	asl
	
	clc
	adc #$20

	clc
	adc nametable!index+$01
	sta nametable!pointer+$01
	
	lda nametable!index
	sta nametable!pointer
	
	lda nametable!pointer+$01
	ldx nametable!pointer
	
	rts

.scend

; **************************************************
; *  method
; **************************************************

nametable@set_row:
.scope

	lda #%00000000
	sta $2000

	lda #$00
	sta nametable!counter

	lda horizontal!id
	ldx horizontal!row
	ldy horizontal!column
	
	sta nametable!id
	stx nametable!row
	sty nametable!column
	
_@1:	jsr nametable@generate_pointer

	sta $2006
	stx $2006
	
	ldx nametable!row
	ldy nametable!counter
	
_@2:	lda horizontal!array, y
	sta $2007
	
	inx
	iny
	
	cpy #$20
	bcs _@3
	
	cpx #$20
	bne _@2

	ldx #$00
	stx nametable!row
	sty nametable!counter

	lda nametable!id
	eor #$01
	sta nametable!id
	
	jmp _@1
	
_@3:	rts	
	
.scend

; **************************************************
; *  method
; **************************************************

nametable@set_column:
.scope

	lda #%00000100
	sta $2000

	lda #$00
	sta nametable!counter

	lda vertical!id
	ldx vertical!row
	ldy vertical!column
	
	sta nametable!id
	stx nametable!row
	sty nametable!column

_@1:	jsr nametable@generate_pointer

	sta $2006
	stx $2006
	
	ldx nametable!column
	ldy nametable!counter
	
_@2:	lda vertical!array, y
	sta $2007
	
	inx
	iny
	
	cpy #$1e
	bcs _@3
	
	cpx #$1e
	bne _@2

	ldx #$00
	stx nametable!column
	sty nametable!counter
	
	jmp _@1
	
_@3:	rts	
	
.scend

; **************************************************
; *  method
; **************************************************

nametable@process:
.scope

	lda #$00
	
	sta $2000
	sta $2001

	lda nametable!op
	beq _@return
	
_@validate_x:	

	lda nametable!op
	and #nametable!mask_x
	beq _@validate_y
	
	jsr nametable@set_column
	
	
_@validate_y:

	lda nametable!op
	and #nametable!mask_y
	beq _@return

	; jsr attribute@update_row
	jsr nametable@set_row
	
_@return:

	`nametable@update_position

	lda #$00
	sta nametable!op
	sta nametable!state

	lda viewport!x+$01
	and #%00000001
	
	ora #%10010000
	sta $2000
	
	lda #%00011110
	sta $2001

	rts
	
.scend