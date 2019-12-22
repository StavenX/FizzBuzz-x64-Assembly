;; build instructions on linux: 
;; 1: nasm -f elf64 -o fb.o fb.asm
;; 2: ld -o fb fb.o
;; 3: ./fb

.data:							
	name db 'FizzBuzz Demo',0x0	
	f db 'Fizz', 0x0				
	b db 'Buzz', 0x0				
	n db 0xA, 0x0            	

	; Macro to calculate string length and print to stdout
	%macro printStr 1
		;; Store previous data
		push rax
		push rbx
		push rcx
		push rdx
		push rdi
		push rsi

		;; Move first arg to rax
		mov rax, %1
		;; push rax to stack
		push rax
		;; move 0 to rbx for loop counter
		mov rbx,0
		;; counts letters
		%%printLoop:
			inc rax
			inc rbx
			mov cl,[rax]
			cmp cl,0
			jne %%printLoop
			;; sys_write
			mov rax,1
			mov rdi,1
			pop rsi
			mov rdx,rbx
			syscall

		;; pop values back to registers

		pop rsi
		pop rdi
		pop rdx
		pop rcx
		pop rbx
		pop rax

	%endmacro

	%macro printStrLF 1
		push rax
		mov rax, %1
		printStr rax ; print argument passed
		printStr newline ; print n
		pop rax
	%endmacro

	%macro printInt 1
		push    rax
		push    rcx
		push    rdx
		push    rsi

		mov rax, %1
		mov     rcx, 0

		%%divideLoop:
			inc     rcx
			mov     rdx, 0
			mov     rsi, 10
			idiv    rsi
			add     rdx, 48
			push    rdx
			cmp     rax, 0
			jnz     %%divideLoop

		%%printLoop:
			dec     rcx
			mov     rax, rsp
			printStr rax
			pop     rax
			cmp     rcx, 0
			jnz     %%printLoop

		pop     rsi
		pop     rdx
		pop     rcx
		pop     rax

	%endmacro

	%macro printIntLF 1
		push rax
		mov rax, %1
		printInt rax
		printStr n
		pop rax
	%endmacro

	%macro exit 1
		mov rax, 60
		mov rdi, %1
		syscall
	%endmacro

.text:
	global _start				
_start:
	printStr name				
	printStr n					
	mov rcx, 0 					
	mov rsi, 0 					
	mov rdi, 0 					

    mov r12, 0  				
    mov r13, 0  				

loop:
	inc rcx						

check_fizz:     				
	mov rdx, 0
	mov rax, rcx
	mov rbx, 3
	div rbx
	mov rsi, rdx
	cmp rsi, 0
	jne check_bang				
	printStr f					
    inc r12						

check_bang:     				
	mov rdx, 0
	mov rax, rcx
	mov rbx, 5
	div rbx
	mov rdi, rdx
	cmp rdi, 0
	jne check_int				
	printStr b					
    inc r13						

check_int:
	cmp rsi, 0					
	je cont						
	cmp rdi, 0					
	je cont						
	printInt rcx				

cont:           				
	printStr n					
	cmp rcx, 19					
	jle loop					

    printInt r12				
    printStr n					
    printInt r13				
    printStr n					
	
	exit 0						
                        