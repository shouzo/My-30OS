; ipl-os
; TAB=4

		ORG		0xc200      ;   這個程式碼是要讀進去那裡

		MOV		AL,0x13	    ;   VGA 圖形、320 x 200 x 8bit 彩色
		MOV		AH,0x00
		INT		0x10
fin:
		HLT
		JMP		fin
