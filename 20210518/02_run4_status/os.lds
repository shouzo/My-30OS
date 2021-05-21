OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

SECTIONS {
     .head 0x0 :
     {
         LONG((ADDR(.bss) + SIZEOF(.bss) + 0xfff) & ~ 0xfff)
         BYTE(0x4f) BYTE(0x53) BYTE(0x4c) BYTE(0x69)
         LONG(0x0)
         LONG(ADDR(.data))
         LONG(SIZEOF(.data))
         LONG(LOADADDR(.data))
         LONG(0xe9000000)
         LONG(HariMain - 0x20)
         LONG((ADDR(.bss) + SIZEOF(.bss) + 0xf) & ~ 0xf)
     }

     .text ADDR(.head) + SIZEOF(.head) :
         SUBALIGN (1)
     {
         *(.text)
     }

     .data 0x00000400 :
         AT ( LOADADDR(.text) + SIZEOF(.text) ) SUBALIGN (4)
     {
         *(.data)
         *(.rodata*)
     }

     .bss  :
         AT ( LOADADDR(.data) + SIZEOF(.data) ) SUBALIGN (4)
     {
        *(.bss)
     }

     /DISCARD/ : { *(*) }
}
