TITLE Program Composite     (Composite.asm)

; Author: Connor Pacala
; CS271 / Project 2                 Date: 11/8/2015
; Desc: prompts user to enter number between 1-400 inclusive. Calculates and outputs user number of composite numbers

INCLUDE Irvine32.inc

;//constant
UPPER_LIMIT = 400

.data

	intro		BYTE "Composite Numbers     Programmed by Connor Pacala",0
	instruct1		BYTE "Enter the number of composite numbers you would like to see [1-",0
	instruct2		BYTE	"] inclusive.",0
	errRange		BYTE "Out of range.",0
	inputPrompt1	BYTE "Enter the number of composites to display [1-",0
	inputPrompt2	BYTE "] inclusive: ",0
	goodbye		BYTE "Goodbye!",0
	itemTab		BYTE "     ",0

	userVal		DWORD 0
	count		DWORD 3
	currVal		DWORD 3
	numVal		DWORD 0

.code
main PROC
	call dispIntro
	call dispInstruct
	call	userInput
	call	dispComposite
	call	dispGoodbye
	exit	; exit to operating system
main ENDP

;//dispIntro outputs the intro message
dispIntro PROC
	mov	edx, OFFSET intro
	call	WriteString
	call	CrLf
	call	CrLf
	ret
dispIntro ENDP

;//dispInstruct displays the longer instruction prompt
dispInstruct PROC
	mov	edx, OFFSET instruct1
	call	WriteString
	mov	eax, UPPER_LIMIT
	call	WriteDec
	mov	edx, OFFSET instruct2
	call	WriteString
	call	CrLf
	call	CrLf
	ret
dispInstruct ENDP

;//userInput displays a short prompt, validates that entered input >=1 and <= 400, outputs
;//error message otherwise. Loops until user enters valid input.
userInput PROC

	L1:
		call	dispPrompt
		call	ReadInt
		cmp	eax, 1
		jl	errIn
		cmp	eax, UPPER_LIMIT
		jg	errIn
		mov	userVal, eax
		jmp	endInput

	errIn:
		mov	edx, OFFSET errRange
		call	WriteString
		call	CrLf
		jmp	L1
		
	endInput:
		ret
userInput ENDP

;//displays the short prompt asking a user to input a value
dispPrompt PROC
	mov	edx, OFFSET inputPrompt1
	call	WriteString
	mov	eax, UPPER_LIMIT
	call	WriteDec
	mov	edx, OFFSET inputPrompt2
	call	WriteString
	ret
dispPrompt ENDP

;//calculates and displays the number of composite numbers the user requested
dispComposite PROC
	mov	ecx, userVal

	L2:
		;//check if currVal is even
		inc	currVal
		mov	eax, currVal
		mov	edx, 0
		mov	ebx, 2
		div	ebx
		cmp	edx, 0
		je	outComp

		;//if currVal not even, check if it is divisible by any odd number between 1 and currVal exclusive
		mov	ebx, count
		L3:
			cmp	ebx, currVal
			jge	L2
			mov	eax, currVal
			mov	edx, 0
			div	ebx
			cmp	edx, 0
			je	outComp
			add	ebx, 2
			jmp	L3

	;//outputs composites, 10 per line with 5 spaces between each item (single item printed at a time)
	outComp:
		mov	eax, currVal
		call	WriteDec
		mov	eax, numVal
		inc	eax
		mov	numVal, eax
		mov	edx, 0
		mov	ebx, 10
		div	ebx
		cmp	edx, 0
		je	newLine
		
		mov	edx, OFFSET itemTab
		call	WriteString
		loop	L2
		jmp	endComp
	newLine:
		call	CrLf
		loop	L2

	endComp:
		call	CrLf
		ret
dispComposite ENDP

;//displays the goodbye text
dispGoodbye PROC
	mov	edx, OFFSET goodbye
	call WriteString
	call	CrLf
	ret
dispGoodbye ENDP


END main