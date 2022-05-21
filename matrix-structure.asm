; **************************************************
; *  matrix00
; **************************************************

matrix00!default:

	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00

; **************************************************
; *  matrix01
; **************************************************
	
matrix01!vector:

	.word matrix01!table01, matrix01!table01
	.word matrix01!table01, matrix01!table01
	
	.word matrix01!table02, matrix01!table02
	.word matrix01!table02, matrix01!table02
	
matrix01!table00:

	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	
matrix01!table01:

	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$01,$00,$00,$00,$01,$00,$00
	.byte $00,$00,$06,$01,$00,$00,$00,$01
	.byte $00,$00,$00,$00,$06,$00,$00,$00
	.byte $00,$00,$01,$00,$00,$01,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$01,$00,$01,$00,$00,$01,$00
	
matrix01!table02:

	.byte $00,$01,$00,$00,$00,$01,$00,$00
	.byte $00,$00,$01,$00,$01,$00,$01,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$01,$00,$00,$00,$01,$00,$01
	.byte $00,$00,$00,$01,$00,$00,$01,$00
	.byte $00,$02,$07,$02,$07,$02,$00,$04
	.byte $03,$03,$03,$03,$03,$03,$03,$03
	.byte $03,$03,$03,$03,$03,$03,$03,$03
	
matrix01!table03:

	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00

matrix01!attribute_vector:

	.word matrix01!attribute00, matrix01!attribute01
	.word matrix01!attribute02, matrix01!attribute03
	
matrix01!attribute00:
	
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	
matrix01!attribute01:
	
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	
matrix01!attribute02:
	
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	
matrix01!attribute03:
	
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	
; **************************************************
; *  cell
; **************************************************
	
cell!vector:

	.word cell!table00, cell!table01, cell!table02
	.word cell!table03, cell!table04, cell!table05, cell!table06, cell!table07

cell!table00:

	.byte $24,$24,$24,$24
	.byte $24,$24,$24,$24
	.byte $24,$24,$24,$24
	.byte $24,$24,$24,$24

cell!table01:

	.byte $24,$36,$37,$24
	.byte $35,$25,$25,$38
	.byte $39,$3a,$3b,$3c
	.byte $24,$24,$24,$24

cell!table02:

	.byte $24,$24,$24,$24
	.byte $24,$24,$24,$24
	.byte $25,$31,$32,$25
	.byte $30,$26,$34,$33
	
cell!table03:

	.byte $b4,$b5,$b4,$b5
	.byte $b6,$b7,$b6,$b6
	.byte $b4,$b5,$b4,$b5
	.byte $b6,$b7,$b6,$b6
	
cell!table04:

	.byte $24,$c6,$c7,$24
	.byte $24,$c8,$c9,$24
	.byte $24,$ca,$cb,$24
	.byte $24,$cc,$cd,$24

cell!table05:

	.byte $24,$c6,$c7,$24
	.byte $24,$c8,$c9,$24
	.byte $24,$ca,$cb,$24
	.byte $24,$cc,$cd,$24
	
cell!table06:

	.byte $24,$24,$24,$24
	.byte $24,$b0,$b2,$24
	.byte $24,$b1,$b3,$24
	.byte $24,$24,$24,$24
	
cell!table07:

	.byte $24,$24,$24,$24
	.byte $24,$53,$54,$24
	.byte $24,$55,$56,$24
	.byte $24,$24,$24,$24