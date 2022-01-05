bits 16

%define VGA_TB_GREEN 0xa
%define VGA_TEXT_BUFFER 0xb8000

;   Putting everything that's comes below at the offset 0x7c00 (
;   The address where the BIOS will search for the Bootloader)
org 0x7c00

; Everything starts here
boot_entry:
    ; Cleaning GPR (Initializing segment registers)
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; Going to VGA mode
    mov ax, 0x3
    int 0x10
    
    ; Loading the GDT
    cli
    lgdt [gdt_location]

    mov eax, cr0
    or eax, 1
    mov cr0, eax
    ; Landing to protected mode
    jmp CODE_SEG:land_to_protected_mode

; GDT Segment
gdt_start:
    ; Nullable structure
    dq 0
code_segment:
    ; Code segment structure data
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
data_segment:
    ; Data segment structure data
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:

gdt_location:
    dw gdt_end - gdt_start
    dd gdt_start

CODE_SEG equ code_segment - gdt_start
DATA_SEG equ data_segment - gdt_start

bits 32
land_to_protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; EDX -> Number of times to print the same string (Int)
    ; EDI -> String size (int)
    ; ESI -> String pointer (char*)

    mov edi, hello_world
    call write

    ;   Disabling all INT and making the CPU wait for the next INT
    ;   (This will cause a infinite loop)
    cli
    hlt

write:
    ; The instruction 'lodsb' prefer the string pointer at the register (ESI)
    mov esi, edi

    mov ebx, VGA_TEXT_BUFFER
    mov ch, VGA_TB_GREEN
.write_LOOP:
    lodsb
    cmp al, 0
    ; We have arrived to the 0 byte, going out :)
    je .write_done
    or ax, cx
    mov word [ebx], ax
    add ebx, 2
    jmp .write_LOOP
.write_done:
    ret

hello_world: db "Hello World", 0
; hello_len equ - hello_world

times 510 -($-$$) db 0

dw 0xaa55
