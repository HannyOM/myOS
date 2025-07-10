;A simple boot sector program that loops forever

;loop:
;    jmp loop;
;times 510-($-$$) db 0
;dw 0xaa55



;A simple boot sector program that prints "Hello World!"

bits 16				; Tells "NASM" that we are generating a 16-bit real mode machine code (this matches what the "BIOS" expects when it loads the boot sector).
org 0x7c00			; Ensures all the label addresses ("start", "print_word" and "end") match the "0x7c00" address, which is where the boot sector will be loaded into.

start:				; "Label address" marking where execution begins.
	mov si, message		; Points the "Source Index(SI) register" to the address of our message, allowing "lodsb" to read every character of our message.

print_word:			; "Label address" that lets us jump back to process the next character.
	lodsb			; Loads a byte from address "DS:SI" into "AL" and increments "SI", which lets us iterate through the string.
	mov ah, 0x0E		; Prepares the "BIOS interrupt 0x10 teletype function number" (AH = 0x0E), which when used with "int 0x10", print a character in "AL" on screen. 
	int 0x10		; "BIOS video interrupt", which when used with "AH = 0x0E", prints a character in "AL" to the screen.
	cmp al, 0		; Checks "AL" to see if the "null character" (0) has been reached.
	je end			; Jumps to the "end" label address if the "null character" (0) has been reached (ends the "print_word" loop).
	jmp print_word		; Jumps back to the beginning of the "print_word" loop to print the next character if the "null character" (0) has not been reached (ensures the "print_word" loop continues until the condition has been met).

end:				; "Label address" that we jump to when the last character has been printed (the "null character" (0) has been reached).
	cli			; Disables "Interrupts".
	hlt			; Halts the CPU.
	jmp end			; Jumps back to the beginning of the "end" loop forever (Infinite loop after halting).

message db "Hello World!", 0	; Presents the string data to be printed, with the "null terminator" (0) at the end which to detect its end.

times 510 - ($ - $$) db 0	; Pads the file with zeros until the we hit "byte 510".
dw 0xaa55			; Defines the last two bytes of the "512-byte sector" as "0xaa55" ("the boot sector signature"), ensuring the "BIOS" boots this as a valid sector. 
