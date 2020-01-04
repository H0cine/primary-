; Home assignment
; Hocine Gasmi 
; rmNonPrime sets nonPrimary to 0 bye index
; input sets is_p to 0 (30h) or 1 (31h) depending on what it find on the list pr
; 31/12/2019
; nasm -f elf primes.asm && ld -m elf_i386 primes.o && ./a.out

SECTION .bss
     pr: resb 100
     nums: resb 100
     is_p: resb 1
section .data
     l db 100
SECTION .text            ; code section
     global _start       ; make label available to linker 


rmNonPrime:
     push ebp
     mov ebp, esp
     mov eax, [ebp+12]        ; index
     mov ebx, [ebp+8]         ; pr, the list
     mov esi, eax
     add esi, esi
     cmp eax, [l]
     jge fin
     cmp esi, [l]
     jg fin
rm:  
     add eax, [ebp+12]
     mov byte [ebx+eax], 30h
     cmp eax, [l]
     jle rm
fin:
     pop ebp
     ret 8

done:
     pop ebp
     ret 8
; -------------------------------
input:
     push ebp
     mov ebp, esp
     mov eax, [ebp+8]
     mov ebx, [ebp+12]
     mov byte [ebx], 30h
     cmp byte [pr+eax], 30h
     je not_p
     mov byte [ebx], 31h
not_p:
     pop ebp
     ret 8
;-------------------------------
; standard  gcc  entry point
_start:                    
     mov esi, 0
     mov bl, 0
a:   ; initialeze pr element with ones
     mov [nums+esi], bl
     mov byte [pr+esi], 31h
     inc esi
     inc bl
continue:
     cmp esi, [l]
     jle a
; starting with 2...
     mov ecx, 2
run:
     mov al, [nums+ecx] ; using (bl) 8bit regester (pr is resb)
     push eax
     push pr
     call rmNonPrime    
     inc ecx
     cmp ecx, [l]
     jle run            ; jumping to run l times, the length nums
     mov eax, 11         ; Number input  
     push is_p          ; if is_p equals 1; the number is primary, 0 if not
     push eax
     call input
     ;mov edx, [l]       ; return number of chars in eax
     mov edx, 1          ; return number of chars in eax
                         ; edx, lgth of numsing to print 
     ;mov  ecx, pr          ; pointer to numsing
     mov  ecx, is_p          ; pointer to numsing
     mov  ebx,1          ; where to write, 1 = screen
     mov  eax,4          ; write sysout command to int 80 hex
     int  0x80           ; interrupt 80 hex, call kernel
     
     mov  ebx,0          ; exit code, 0=normal
     mov  eax,1          ; exit command to kernel
     int  0x80           ; interrupt 80 hex, call kernel
