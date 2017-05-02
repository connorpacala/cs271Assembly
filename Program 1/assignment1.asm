TITLE Assignment1	(assignment1.asm)

;// Author: Connor Pacala
;// CS271					Date: 10/11/2015
;// Desc: Prompts user to enter 2 positive numbers, prints the sum, difference, product, quotient,
;//		and remainder. Repeat until player chooses to exit, catches if second number less than the first.

INCLUDE Irvine32.inc

.data
intro		BYTE	"Arithmetic     by Connor Pacala",0
extra_credit	BYTE "**EC: program verifies 2nd number less than 1st and repeats until user quits.",0
prompt_inst	BYTE "Please enter two numbers:",0
prompt_num1	BYTE "First number: ",0
prompt_num2	BYTE "Second number: ", 0
prompt_err	BYTE "The Second Number Must be Less Than the First!",0
goodbye		BYTE "Goodbye!",0

exit_prompt	BYTE "Press 'q' to exit, 'enter' to continue."
buffer		BYTE 2 DUP(0)

prompt_sum	BYTE "Sum: ",0
prompt_diff	BYTE "Difference: ",0
prompt_prod	BYTE "Product: ",0
prompt_quot	BYTE "Quotient: ",0
prompt_remain	BYTE "Remainder: ",0

num_1		DWORD 0
num_2		DWORD 0
sum			DWORD 0
diff			DWORD 0
product		DWORD 0
quotient		DWORD 0
remain		DWORD 0

.code
main PROC

	;// display program title and author name (intro)
	mov		edx, OFFSET intro
	call		WriteString
	call		CrLf

	;//display EC info
	mov		edx, OFFSET extra_credit
	call		WriteString
	call		CrLf
	call		CrLf

	;// display user instructions (prompt_1)
	mov		edx, OFFSET prompt_inst
	call		WriteString
	call		CrLf
	call		CrLf

input:
	;// prompt user for first number and read value into num_1, 
	mov		edx, OFFSET prompt_num1
	call		WriteString
	call		ReadDec
	mov		num_1, eax

	;// prompt user for second number and read value into num_2
	mov		edx, OFFSET prompt_num2
	call		WriteString
	call		ReadDec
	mov		num_2, eax
	call		CrLf

	;// compare num_1 and num_2 to make sure num_2 is less than num_1
	mov		eax, num_1
	cmp		eax, num_2
	jge		calculate
	mov		edx, OFFSET prompt_err
	call		WriteString
	call		CrLf
	call		CrLf
	jmp		input

calculate:
	;// calculates the sum and sets the value of "sum" to the sum
	mov		eax, num_1
	add		eax, num_2
	mov		sum, eax

	;// calculates the difference and sets the value of "diff" to the difference
	mov		eax, num_1
	sub		eax, num_2
	mov		diff, eax

	;// calculates the product and sets the value of "product" to the product
	mov		eax, num_1
	mov		ebx, num_2
	mul		ebx
	mov		product, eax

	;// calculates the quotient and sets the value of "quotient" to the quotient
	;// and the value of "remain" to the remainder
	mov		eax, num_1
	mov		ebx, num_2
	div		ebx
	mov		quotient, eax
	mov		remain, edx

;// display the results
	;// display the sum
	mov		edx, OFFSET prompt_sum
	call		WriteString
	mov		eax, sum
	call		WriteDec
	call		CrLf

	;// display the difference
	mov		edx, OFFSET prompt_diff
	call		WriteString
	mov		eax, diff
	call		WriteDec
	call		CrLf

	;// display the product
	mov		edx, OFFSET prompt_prod
	call		WriteString
	mov		eax, product
	call		WriteDec
	call		CrLf

	;// display the quotient
	mov		edx, OFFSET prompt_quot
	call		WriteString
	mov		eax, quotient
	call		WriteDec
	call		CrLf

	;// display the remainder
	mov		edx, OFFSET prompt_remain
	call		WriteString
	mov		eax, remain
	call		WriteDec
	call		CrLf
	call		CrLf

	;//prompt user to enter 'q' to exit or 'enter' to enter more numbers to compare.
	mov		edx, OFFSET exit_prompt
	call		WriteString
	call		CrLf
	mov		edx, OFFSET buffer
	mov		ecx, SIZEOF buffer
	call		ReadString
	mov		al, buffer
	cmp		al, 'q'
	jne		input

	;// display terminating message
	mov		edx, OFFSET goodbye
	call		WriteString
	call		CrLf

	exit
main ENDP

END MAIN