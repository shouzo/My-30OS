OSNAME := haribote

.DEFAULT_GOAL : all
.PHONY : all
all : img
DEBUG_DIR := ./debug
OBJDUMP_FLAGS := --full-contents --all-headers --target=binary --architecture=i386:intel --disassemble-all


#===============================================================================
ipl10.bin    : ipl10.asm
asmhead.bin  : asmhead.asm
nasmfunc.o   : nasmfunc.asm

%.bin : %.asm 
	@make make-debug-dir
	nasm $^ -o $@ -l ${DEBUG_DIR}/$*.lst

%.o : %.asm
	@make make-debug-dir
	nasm -f elf $^ -o $@ -l ${DEBUG_DIR}/$*.lst

BOOTPACK_FILES := bootpack.c nasmfunc.o
bootpack.hrb : ${BOOTPACK_FILES} os.lds
	@make make-debug-dir
		
	gcc -march=i486 -m32 -nostdlib -g -O0 \
		-T os.lds \
		-o $@ \
		-fno-pie\
		${BOOTPACK_FILES}


	objdump ${OBJDUMP_FLAGS} $@ > ${DEBUG_DIR}/$@.dasm


${OSNAME}.sys : asmhead.bin bootpack.hrb
%.sys :
	@make make-debug-dir
	cat $^ > $@
	
	objdump ${OBJDUMP_FLAGS} $@ > ${DEBUG_DIR}/$@.dasm



${OSNAME}.img : ipl10.bin ${OSNAME}.sys

# ================方法 1======================
	mformat -f 1440 -C -B ipl10.bin -i $@ ::
	mcopy -i $@ ${OSNAME}.sys ::
# ============================================

# ================方法 2======================
	# dd if=/dev/zero of=${OSNAME}.img bs=512 count=2880
	# dd if=ipl10.bin of=${OSNAME}.img conv=notrunc
	# mcopy -i $@ ${OSNAME}.sys ::
# ============================================


#===============================================================================


.PHONY : asm
asm :
	make ipl10.bin

.PHONY : img
img :
	make ${OSNAME}.img 

.PHONY : run
run :
	make img
	qemu-system-i386 -fda ${OSNAME}.img

.PHONY : make-debug-dir
make-debug-dir :
	@if [ ! -d ${DEBUG_DIR} ]; then mkdir ${DEBUG_DIR}; fi


#===============================================================================


.PHONY : clean
clean :
	@rm *.img *.bin *.sys *.hrb *.o

.PHONY : debug
debug:
	make img
	qemu-system-i386 -fda haribote.img -gdb tcp::10000 -S

