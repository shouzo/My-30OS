/* 告知C語言編譯器，有使用其他檔案所製作的函數 */

void io_hlt(void);
void write_mem8(int addr, int data);
/* 雖然是函數的宣告，卻沒有 {}，而且馬上就以; 字元結束。
   這是表示它存在於其他的檔案裡，請到該處去進行讀取。 */

void HariMain(void)
{
    int i;  /* 宣告變數。稱為 i 的變數是 32 位元的整數型別 */

    for (i = 0xa0000; i <= 0xaffff; i++) {
        write_mem8(i, 15);      // 螢幕會顯示白色
        // write_mem8(i, i & 0x0f);     // 螢幕會顯示條紋色
    }

    for (;;) {
        io_hlt(); /* 這樣在 nasmfunc.nas 的 io_hlt 將會執行 */
    }	
}
