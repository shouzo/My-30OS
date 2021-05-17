; asmhead
; TAB=4

; BOOT_INFO 資訊
CYLS	EQU		0x0ff0			; 設定開機磁區
LEDS	EQU		0x0ff1
VMODE	EQU		0x0ff2			; 與色彩有關的資訊。表示顏色所會使用到的位元數
SCRNX	EQU		0x0ff4			; X 方向的解析度 (screen x)
SCRNY	EQU		0x0ff6			; Y 方向的解析度 (screen y)
VRAM	EQU		0x0ff8			; 圖形緩衝區 (Graphic Buffer) 的開始位址

		ORG		0xc200			; 這個程式碼是要讀進去那裡

		MOV		AL,0x13			; VGA 圖形、320 x 200 x 8bit 彩色
		MOV		AH,0x00
		INT		0x10
		MOV		BYTE [VMODE],8	; 記錄畫面模式
		MOV		WORD [SCRNX],320
		MOV		WORD [SCRNY],200
		MOV		DWORD [VRAM],0x000a0000

; 從 BIOS 告知鍵盤的 LED 狀態

		MOV		AH,0x02
		INT		0x16 			; keyboard BIOS
		MOV		[LEDS],AL

fin:
		HLT
		JMP		fin
