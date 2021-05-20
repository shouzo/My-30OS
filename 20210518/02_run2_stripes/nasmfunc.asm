; naskfunc
; TAB=4

; ===========================================
section .text
    GLOBAL	io_hlt
	GLOBAL	write_mem8
; ===========================================


; ===========================================
io_hlt:	; void io_hlt(void);
		HLT
		RET
; ===========================================


write_mem8:    ; void write_mem8(int addr, int data);
        MOV     ECX, [ESP+4]    ; 因為在 [ESP+4] 裡有 addr，所以將該值讀入到 ECX
        MOV     AL, [ESP+8]     ; 因為在 [ESP+8] 裡有 data，所以將該值讀入 AL
        MOV     [ECX], AL
        RET
