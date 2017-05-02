TITLE Program Template     (template.asm)

; Author: Connor Pacala
; CS271 / Project 2                 Date: 10/17/2015
; Description: Displays between 1 and 46 Fibonacci numbers. Number of terms to display input by user.

INCLUDE Irvine32.inc

;//constants
LOWER_LIMIT = 1
UPPER_LIMIT = 46

.data

	intro		BYTE "Fibbonacci Number     Programmed by Connor Pacala",0
	name_prompt	BYTE "What's your name? ",0
	hello		BYTE "Hello, ",0
	instruct		BYTE "Enter the number of Fibonacci terms to be displayed.",0
	error		BYTE "Error, out of range.",0
	term_prompt	BYTE "How many Fibonacci terms do you want? ",0
	out1			BYTE "Enter an integer between ",0
	out2			BYTE " and ",0
	out3			BYTE " inclusive.",0
	spacing		BYTE "     ",0
	goodbye		BYTE "Goodbye, ",0

	username		BYTE 32 DUP(0)

	numTerms		DWORD 0
	currValue		DWORD 1
	prevValue		DWORD 0
	count		DWORD 0

.code
main PROC

;//introduction
	mov	edx, OFFSET intro
	call	WriteString
	call	CrLf
	call	CrLf

;//greeting, get and display user's name
	mov	edx, OFFSET name_prompt
	call	WriteString

	mov	edx, OFFSET username
	mov	ecx, SIZEOF username
	call	ReadString

	;// greets user by name
	mov	edx, OFFSET hello
	call	WriteString
	mov edx, OFFSET username
	call WriteString
	call	CrLf

;// User instructions and input
	mov	edx, OFFSET instruct
	call	WriteString
	call CrLf

L1:
	;//display instructions for valid range of terms
	mov	edx, OFFSET out1
	call WriteString
	mov	eax, LOWER_LIMIT
	call	WriteDec
	mov	edx, OFFSET out2
	call	WriteString
	mov	eax, UPPER_LIMIT
	call WriteDec
	mov	edx, OFFSET out3
	call	WriteString
	call CrLf
	mov	edx, OFFSET term_prompt
	call	WriteString

	;//get number of terms from user (check for valid range)
	call	ReadDec
	cmp	eax, UPPER_LIMIT
	jg	notValid
	cmp	eax, LOWER_LIMIT
	jl	notValid
	jmp	valid


notValid:
	;//print error message and return to the start of the input loop (L1)
	mov	edx, OFFSET error
	call	WriteString
	jmp	L1

valid:
	;//Store the number of terms input by user.
	call	CrLf
	mov	numTerms, eax

;//calculate fibonacci numbers
	mov ecx, numTerms
L2:
	;//displays the current value
	mov	eax, currValue
	call	WriteDec
	mov	edx, OFFSET spacing
	call	WriteString

	;//calculates the next fibonacci term and replaces the previous value with the current
	mov	ebx, prevValue
	mov	prevValue, eax
	add	eax, ebx
	mov	currValue, eax

	;//line break every 5 terms output
	mov	eax, count
	inc	eax
	cmp	eax, 5
	jl	L3
	mov	eax, 0
	call	CrLf

L3: 
	mov	count, eax
	loop L2

;//goodbye
	call	CrLf
	call	CrLf
	mov	edx, OFFSET goodbye
	call	WriteString
	mov	edx, OFFSET username
	call	WriteString
	call	CrLf
	call	CrLf

	exit	; exit to operating system
main ENDP

END main