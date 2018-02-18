;---------------------------------------------------------------------------------------;
;	GrapeSodaOS									;
;	(C) Copyright All GrapeSodaOS Contributors - See LICENSE.TXT			;
;											;
;	Licensed under the Apache License, Version 2.0 (the "License")			;
;	you may not use this file except in compliance with the License.		;
;	You may obtain a copy of the License at						;
;											;
;		http://www.apache.org/licenses/LICENSE-2.0				;
;											;
;	Unless required by applicable law or agreed to in writing, software		;
;	distributed under the License is distributed on an "AS IS" BASIS,		;
;	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.	;
;	see the License for the specific language governing permissions and		;
;	limitations under the License.							;
;---------------------------------------------------------------------------------------;
	
	[BITS 16]									; The BIOS boots us in 16-bit real mode
	[ORG 0x0]									; We will set segments later

	jmp GrapeSodaBoot								; Start booting
	
	_helloworld		db 'Hello, World! - GrapeSodaOS', 0			; Hello, world message
	
	PrintString:									; Our print string routine
		pusha									; Save our registers
		mov ah, 0Eh								; Int 10h - Function 0Eh - Print Char
	PSLoop:										; Here we will loop through all the chars until the end of the string
		lodsb									; Load one char from the string
		cmp al, 0								; Is the char 0?
		je PSDone								; If so, end the loop
		int 10h									; Otherwise print the char,
		jmp PSLoop								; And keep looping
	PSDone:										; If we are here, we are at the end of the string
		popa									; Restore the registers
		ret									; Return to where we were called

	GrapeSodaBoot:									; Here is our main routine
		cli									; Clear the interrupts
		mov ax, 0								; Stack segment = 0
		mov ss, ax								; We can't move it direcly into ss, so move it into ax, then ss
		mov sp, 0xFFFF								; Stack pointer = 0xFFFF
		sti									; Restore the interrupts

		mov ax, 0x07C0								; We are setting up the segments now
		mov ds, ax								; Repeatedly move it into ds, es, fs, gs
		mov es, ax
		mov fs, ax
		mov gs, ax
		
		mov si, _helloworld							; Time to print "Hello, World!"
		call PrintString							; Print the string
		
		cli									; Clear the interrupts
		hlt									; Halt the system

	times 510-($-$$) db 0								; Pad out the remainder of the sector
	dw 0xAA55									; The standard pc boot signature - compatible with all x86 pcs