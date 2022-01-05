AS=nasm
ASFLAGS=-f bin

BOOT_PROGRAM=hello-boot

BOOT_PROGRAM_SRC=\
	boot.asm

all: $(BOOT_PROGRAM)

run:
	qemu-system-i386 -drive file=hello-boot,format=raw

$(BOOT_PROGRAM): $(BOOT_PROGRAM_SRC)
	$(AS) $(ASFLAGS) -o $@ $^

clean:
	-rm -f $(BOOT_PROGRAM)


.PHONY: all clean
