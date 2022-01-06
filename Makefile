AS=nasm
ASFLAGS=-f bin

BOOT_PROGRAM=hello-boot

BOOT_PROGRAM_SRC=\
	boot.asm

all: $(BOOT_PROGRAM)

run: $(BOOT_PROGRAM)
	qemu-system-i386 -drive file=$(BOOT_PROGRAM),format=raw

$(BOOT_PROGRAM): $(BOOT_PROGRAM_SRC)
	$(AS) $(ASFLAGS) -o $@ $^

clean:
	-rm -f $(BOOT_PROGRAM)


.PHONY: all clean
