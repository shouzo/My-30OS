; hello-os
; TAB=4

ORG		0x7c00			    ;   指定從 0x7c00 開始執行

;   以下是為了標準 FAT12 格式的軟式磁碟片的記述

    JMP		entry
    DB		0x90
    DB		"HELLOIPL"		
    DW		512				
    DB		1				
    DW		1				
    DB		2				
    DW		224				
    DW		2880			
    DB		0xf0			
    DW		9				
    DW		18				
    DW		2				
    DD		0				
    DD		2880			
    DB		0,0,0x29		
    DD		0xffffffff		
    DB		"HELLO-OS   "	
    DB		"FAT12   "		
    RESB	18				




; 程式碼本身

entry:
    MOV		AX,0			;   暫存器初始化
    MOV		SS,AX
    MOV		SP,0x7c00
    MOV		DS,AX
    MOV		ES,AX

    MOV		SI,msg


putloop:
    MOV		AL,[SI]
    ADD		SI,1			;   在 SI 加 1
    CMP		AL,0
    JE		fin
    MOV		AH,0x0e			;   一個文字表示功能
    MOV		BX,15			;   顏色代碼 (color code)
    INT		0x10			;   呼叫視訊 BIOS
    JMP		putloop


fin:
    HLT						;   直到有了某個物件就將 CPU 停止
    JMP		fin				;   無限迴圈


msg:
    DB		0x0a, 0x0a		;   連續兩個換行
    DB		"hello, world"
    DB		0x0a			;   換行 
    DB		0

    ;   RESB	0x7dfe-$	;   此行編譯無法通過，故修改成 "TIMES 510-($-$$)      DB      0"
    TIMES 510-($-$$)    DB      0   ;   '$' 代表目前行的位址，'$$' 為目前 section 的位址。(TIMES 意思為重複，先確定次數再確定重複的內容)

    DB		0x55, 0xaa
