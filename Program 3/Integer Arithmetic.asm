TITLE Program Template     (template.asm)

; Author: Connor Pacala
; CS271 / Project 2                 Date: 10/17/2015
; Desc: Accepts integer input from -100 to -1. Outputs the sum and average of the valid integers.
;  exits when user inputs non-negative number.

INCLUDE Irvine32.inc

;//constants
LOWER_LIMIT = -100
UPPER_LIMIT = -1

.data

	intro		BYTE "Integer Sum and Average     Programmed by Connor Pacala",0
	ec1			BYTE "**EC: Number the lines during user input",0
	ec2			BYTE "**EC: Calculate and display the average as a floating-point number, rounded to the nearest .001.",0
	namePrompt	BYTE "What's your name? ",0
	hello		BYTE "Hello, ",0
	instruct		BYTE "Please enter integers between -100 and -1 inclusive to find the sum and average of. Enter a non-negative number to exit.",0
	error		BYTE "Error, input less than -100, please input numbers between -1 and -100 inclusive.",0
	errNoVal		BYTE "No valid integers were entered!",0
	termPrompt	BYTE ". Please enter an integer: ",0
	sumLabel		BYTE "The sum is: ",0
	avgLabel		BYTE "The average is: ",0
	goodbye		BYTE "Goodbye, ",0
	decimal		BYTE ".",0

	username		BYTE 32 DUP(0)

	lineNum		DWORD 1
	numVal		DWORD 0
	sum			SDWORD 0
	avg			SDWORD 0
	remain		DWORD 0

.code
main PROC

;//introduction
	mov	edx, OFFSET intro
	call	WriteString
	call	CrLf
	call	CrLf

	;//display EC messages
	mov	edx, OFFSET ec1
	call	WriteString
	call	CrLf
	mov	edx, OFFSET ec2
	call	WriteString
	call	CrLf
	call	CrLf

;//greeting, get and display user's name
	mov	edx, OFFSET namePrompt
	call	WriteString

	mov	edx, OFFSET username
	mov	ecx, SIZEOF username
	call	ReadString

	;// greets user by name
	mov	edx, OFFSET hello
	call	WriteString
	mov	edx, OFFSET username
	call WriteString
	call	CrLf

;// User instructions and input
	mov	edx, OFFSET instruct
	call	WriteString
	call CrLf

L1:
	;//prompt user to enter a number
	mov	eax, lineNum
	call	WriteDec
	inc	eax
	mov	lineNum, eax
	mov	edx, OFFSET termPrompt
	call	WriteString

	;//read user input, print error if num <-100 and exit loop if num >= 0
	call	ReadInt
	cmp	eax, LOWER_LIMIT
	jl	notValid
	cmp	eax, UPPER_LIMIT
	jg	exitL1
	
	;//if valid input, add new value to sum, increment numVal, and return to start of loop
	add	eax, sum
	mov	sum, eax
	mov	eax, numVal
	inc	eax
	mov	numVal, eax
	jmp	L1

notValid:
	;//print error message (input < -100) and return to the start of the input loop (L1)
	mov	edx, OFFSET error
	call	WriteString
	jmp	L1


;//calculate sum and average and output
exitL1:
	;//print sum if there was at least 1 valid input
	mov	eax, numVal
	cmp	eax, 0
	jle	noVal
	mov	edx, OFFSET sumLabel
	call	WriteString
	mov	eax, sum
	call	WriteInt
	call	CrLf

	;//calculate average and display it
	mov	edx, OFFSET avgLabel
	call	WriteString
	mov	eax, sum
	cdq
	idiv	numVal
	mov	avg, eax

	;//round number down if twice remainder less than or equal to divisor (round down if decimal < -0.5)
	neg	edx
	mov	remain, edx
	add	edx, edx
	cmp	edx, numVal
	jle	dispAvg
	mov	eax, avg
	dec	eax
	mov	avg, eax
	
dispAvg:
	;//calculate decimal value from remainder
	mov	eax, remain
	mov	ebx, 1000
	mul	ebx
	mov	ebx, numVal
	div	ebx
	mov	remain, eax

	;//output average
	mov	eax, avg
	call	WriteInt
	mov	edx, OFFSET decimal
	call	WriteString
	mov	eax, remain
	call	WriteDec
	jmp	endProg

noVal:
	;//no valid input entered, no sum or avg calculated, print error
	mov	edx, OFFSET errNoVal
	call	WriteString
	call	CrLf

;//goodbye
endProg:
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