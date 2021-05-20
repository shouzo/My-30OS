; haribote-ipl
; TAB=4

        CYLS    EQU     10          ;   讀取 10 次 (磁柱的份量)


		ORG		0x7c00              ;   指定從 0x7c00 開始執行	

;   以下是為了標準 FAT12 格式的軟式磁碟片的記述

		JMP		entry
		DB		0x90
		DB		"HARIBOTE"		
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
		DB		"HARIBOTEOS "	
		DB		"FAT12   "		
		RESB	18				




;   程式碼本身

entry:
		MOV		AX,0                ;   暫存器初始化
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX


;   ---- 20210517 新增的部份 (START) ----
		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0                ;   磁柱0			
		MOV		DH,0			    ;   磁頭0
		MOV		CL,2			    ;   磁區2


readloop:
        MOV     SI,0                ;   計算失敗次數的暫存器


retry:
		MOV		AH,0x02             ;   AH=0x02：讀入磁碟片			
		MOV		AL,1			    ;   1個磁區
		MOV		BX,0
		MOV		DL,0x00			    ;   A磁碟機
		INT		0x13			    ;   呼叫磁碟片 BIOS
        JNC     fin                 ;   如果出現錯誤就到 fin
        ADD     SI,1                ;   SI 加 1
        CMP     SI,5                ;   SI 與 5 做比較
        JAE     error                ;   如果 SI >= 5，就到 error
        MOV     AH,0x00
        MOV     DL,0x00             ;   A磁碟機
        INT     0x13                ;   磁碟機的重設
        JMP     retry


next:
        MOV     AX,ES               ;   位址前進到 0x200
        ADD     AX,0x0020
        MOV     ES,AX               ;   因為沒有 "ADD    Es,0x020" 的命令，所以才如此執行
        ADD     CL,1                ;   CL 加 1
        CMP     CL,18               ;   CL 與 18 做比較
        JBE     readloop            ;   若是 CL <= 18 就到 readloop
        MOV     CL,1
        ADD     DH,1
        CMP     DH,2
        JB      readloop            ;   若是 DH < 2 就到 readloop
        MOV     DH,0
        ADD     CH,1
        CMP     CH,CYLS
        JB      readloop            ;   若是 CH < CYLS 就到 readloop
;   ---- 20210517 新增的部份 (END) ----




fin:
		HLT					        ;   直到有了某個物件就將 CPU 停止	
		JMP		fin				    ;   無限迴圈

error:
		MOV		SI,msg
putloop:
		MOV		AL,[SI]
		ADD		SI,1			
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			
		MOV		BX,15			
		INT		0x10			
		JMP		putloop
msg:
		DB		0x0a, 0x0a		    ;   連續兩個換行
		DB		"load error"
		DB		0x0a			    ;   換行
		DB		0

		;   RESB	0x7dfe-$		;   此行編譯無法通過，故修改成 "TIMES 510-($-$$)   DB  0"
        
        TIMES 510-($-$$)    DB      0
        ;   '$' 代表目前行的位址，'$$' 為目前 section 的位址。(TIMES 意思為重複，先確定次數再確定重複的內容)

		DB		0x55, 0xaa
