core@header:
.scope

	_!identifier:	.byte "NES", $1a

	_!prg:		.byte $01
	_!chr:		.byte $01

	_!mirrioring:	.byte $01
	_!mapper:	.byte $00

	_!data:		.word $0000, $0000
			.word $0000, $0000

.scend

.data
.org $0300

.space core!delay	2

.text
.org $c000

; **************************************************
; *  macro
; **************************************************

.macro core@initialize

	sei
	cld

	ldx #$ff
	txs

.macend

; **************************************************
; *  macro
; **************************************************

.macro core@disable_audio

	lda #$40
	ldx #$00
	
	sta $4017
	stx $4010

.macend

; **************************************************
; *  macro
; **************************************************

.macro core@disable_video

	lda #$00

	sta $2000
	sta $2001

.macend

; ************************************************************
; * macro
; ************************************************************

.macro core@vertical_interval

_@1:	bit $2002
	bpl _@1

.macend

; ************************************************************
; * macro
; ************************************************************

.macro core@initialize_memory

	tax

_@1:	sta $0000, x		
	sta $0100, x
	sta $0200, x
	sta $0300, x
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x

	inx
	bne _@1

.macend

; **************************************************
; *  method
; **************************************************

.macro core@set_palette_table

	lda $2002

	lda #$3f
	ldx #$00

	sta $2006
	stx $2006

	ldx #$00

_@1:	lda core@palette_table, x
	sta $2007

	inx

	cpx #$20
	bne _@1
	
.macend

; **************************************************
; *  method
; **************************************************

.macro core@set_attribute_table

	lda $2002

	lda #$23
	ldx #$c0

	sta $2006
	stx $2006

	ldx #$00

_@1:	lda #$00
	sta $2007
	
	inx
	
	cpx #$40
	bne _@1
	
.macend

; **************************************************
; *  method
; **************************************************

core@reset:
.scope

	`core@initialize
	`core@disable_audio
	`core@disable_video
	
	`core@vertical_interval
	`core@initialize_memory
	`core@vertical_interval
	
	`core@set_palette_table
	`core@set_attribute_table
	
	lda #%10010000
	ldx #%00011110

	sta $2000
	stx $2001
	
.scend

; **************************************************

	lda #$00
	sta viewport!x
	
	lda #$00
	sta viewport!y
	sta viewport!local_y
	
	lda #$00
	sta viewport!y+$01
	
	lda #$00
	sta viewport!x+$01
	
; **************************************************
	
	lda #<matrix01!vector
	ldx #>matrix01!vector
	
	sta matrix!pointer
	stx matrix!pointer+$01
	
	lda #<matrix01!attribute_vector
	ldx #>matrix01!attribute_vector
	
	sta matrix!attribute_pointer
	stx matrix!attribute_pointer+$01
	
	lda #$04
	sta matrix!width
	lda #$02
	sta matrix!height

@delay: lda nametable!op
	bne @delay
	
_@99:   lda $05
	and #$01
	beq _@100

	lda #$01
	jsr viewport@decrement_x
	
_@100:	lda $05
	and #$02
	beq _@101
	
	lda #$01
	jsr viewport@increment_x
	
_@101:	lda $06
	and #$01
	beq _@102

	lda #$01
	jsr viewport@decrement_y

_@102:	lda $06
	and #$02
	beq _@103
	
	lda #$01
	jsr viewport@increment_y
	
_@103:
	jsr nametable@update
	
	jmp @delay

; **************************************************
; *  method
; **************************************************

.macro core@get_input
	
	lda #$01
	sta $4016
	lda #$00
	sta $4016
	
	lda #$00
	sta $05
	sta $06

get_input_up:

	lda $4016
	lda $4016
	lda $4016
	lda $4016

	lda $4016
	and #%00000001
	beq get_input_down

	lda #$01
	sta $06

get_input_down:

	lda $4016
	and #%00000001
	beq get_input_left

	lda #$02
	sta $06

get_input_left:

	lda $4016
	and #%00000001
	beq get_input_right

	lda #$01
	sta $05

get_input_right:

	lda $4016
	and #%00000001
	beq _@1

	lda #$02
	sta $05
	
_@1:

.macend
	
; **************************************************
; *  method
; **************************************************

core@nonmaskable_interrupt:
.scope

	pha
	txa
	pha
	tya
	pha
	php
	
	jsr nametable@process
	`core@get_input
	
	plp
	pla
	tay
	pla
	tax
	pla

	rti
	
.scend

; **************************************************
; *  data
; **************************************************

.include "matrix.asm"
.include "table.asm"
.include "cell.asm"
.include "nametable.asm"
.include "viewport.asm"

.advance $e000

.include "matrix-structure.asm"

core@palette_table:

	.byte $21,$30,$22,$0F,  $23,$24,$25,$0F,  $26,$27,$28,$0F,  $29,$2a,$2b,$0F
	.byte $30,$31,$32,$0F,  $33,$34,$35,$0F,  $36,$37,$38,$0F,  $39,$3a,$3b,$0F
	
.advance $fffa

	.word core@nonmaskable_interrupt, core@reset, $0

.org $0000

.incbin "chrsegment.bin"