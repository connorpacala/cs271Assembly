TITLE Program LowLevelIO     (LowLevelIO.asm)

;// Author: Connor Pacala
;// CS271	Project 6A                 Date: 12/3/2015
;// Desc:	prompts user to input 10 unsigned ints, outputs list, sum, and average of ints

INCLUDE Irvine32.inc

;//constants
NUM_VAL = 10


;//macros

;//----------------------------------------------------------------------------
;//getString Macro 
;//reads string from user input
;//Receives: string address, SIZEOF string
;//Returns: nothing
;//----------------------------------------------------------------------------
getString MACRO varName, varSize
	push	edx
	push	ecx
	mov	edx, varName
	mov	ecx, varSize
	call	ReadString
	pop	ecx
	pop	edx
ENDM

;//----------------------------------------------------------------------------
;//displayString Macro 
;//outputs passed string to console
;//Receives: string address
;//Returns: nothing
;//----------------------------------------------------------------------------
displayString MACRO buffer
	push	edx
	mov	edx, buffer
	call	WriteString
	pop	edx
ENDM

;//----------------------------------------------------------------------------
;//addArrayVal Macro 
;//adds a value to an array index
;//Receives: address of array, index to add value to, value to add to array
;//Returns: nothing
;//----------------------------------------------------------------------------
addArrayVal MACRO arrAddress, index, value
	push	eax
	push	esi
	
	mov	esi, arrAddress
	add	esi, index
	mov	eax, value
	mov	[esi], eax

	pop	esi
	pop	eax
ENDM


.data
intro		BYTE	"Lab 6A: Low-level I/O procedures			By Connor Pacala",0
instruct		BYTE "This program accepts 10 unsigned 32 bit integers as input and outputs a list, the sum, and the average of the integers.",0
prompt		BYTE "Please enter an unsigned integer: ",0
errInvalid	BYTE	"Error, invalid input.",0
label1		BYTE "You entered the following numbers:",0
label2		BYTE "The sum is: ",0
label3		BYTE "The average is: ",0
comma		BYTE ", ",0

userInput		BYTE 16 DUP(0)
valList		DWORD NUM_VAL DUP(0)
currIndex		DWORD 0
currVal		DWORD 0

.code
main PROC
	
	;//intro
	displayString OFFSET intro
	call CrLf
	call CrLf

	;//instructions
	displayString OFFSET instruct
	call CrLf
	call CrLf

;//get user input
	mov	ecx, NUM_VAL
L1:
	push	OFFSET errInvalid
	push	OFFSET prompt
	push	(SIZEOF userInput) - 1
	push	OFFSET currVal
	push OFFSET userInput
	call	ReadVal

	;//add value to end of array and clear current value
	addArrayVal OFFSET valList, currIndex, currVal
	add	currIndex, TYPE DWORD
	mov	currVal, 0

	loop	L1

;//display contents of valList
	displayString OFFSET label1
	call	CrLF
	mov	ecx, NUM_VAL
	mov	esi, OFFSET valList
L2:
	mov	eax, [esi]
	push	OFFSET userInput
	push	eax
	call	WriteVal
	add	esi, TYPE DWORD
	displayString OFFSET comma
	loop	L2
	call	CrLf

;//display sum and average
	push OFFSET userInput
	push	OFFSET label2	;//sum label
	push	OFFSET label3	;//avg label
	push	OFFSET valList
	push	NUM_VAL
	call DispSumAvg
	call	CrLf

	exit	;//exit to operating system
main ENDP


;//----------------------------------------------------------------------------
;//readVal
;//reads 32 bit unsigned int from user input
;//Receives: string address to store user input, string address of user prompt
;//Returns: nothing
;//----------------------------------------------------------------------------
ReadVal PROC
	push	ebp
	mov	ebp, esp
	push	eax
	push	ebx
	push	ecx
	push	edx

input:
	;//prompt user to enter integer and read user input
	displayString [ebp + 20]
	getString [ebp + 8], [ebp + 16]

	;//check if entered integer is >10 char (larger than 32 bit integer)
	cmp	eax, 10
	jg	invalidIn

	;//set up loop counter
	mov	ecx, eax

	;//clear eax and edx
	XOR	eax, eax
	XOR	edx, edx

	;//move OFFSET userVal to esi for use with lodsb in loop
	mov	esi, [ebp + 8]
	cld

;//loop through string
strLoop:
	;//multiply current value by 10
	mov	ebx, [ebp + 12]
	mov	eax, [ebx]
	mov	ebx, 10
	mul	ebx
	mov	ebx, [ebp + 12]
	mov	[ebx], eax

	;//move next char into al using lodsb
	lodsb

	;//subtract 48 (ASCII offset) from al
	sub	al, 48

	;//check to make sure value is between 0 and 9
	cmp	al, 0
	jl	invalidIn
	cmp	al, 9
	jg	invalidIn

	;//add and loop
	mov	ebx, [ebp + 12]
	add	[ebx], al
	loop	strLoop

	jmp endReadVal

;//error message if invalid input
invalidIn:
	displayString [ebp + 24]
	call	CrLf
	jmp	input

endReadVal:
	pop	edx
	pop	ecx
	pop	ebx
	pop	eax
	pop	ebp
	ret	20
ReadVal ENDP


;//----------------------------------------------------------------------------
;//WriteVal
;//reads 32 bit unsigned int from user input
;//Receives: @string to store converted integer, integer to write
;//Returns: nothing
;//----------------------------------------------------------------------------
WriteVal PROC
	push	ebp
	mov	ebp, esp
	push	eax
	push	ebx
	push	ecx
	push	edx

	mov	ecx, 0
	mov	eax, [ebp + 8]
	mov	ebx, 10
;//loop until eax empty
L1:
	;//clear edx register
	xor	edx, edx

	;//divide passed integer by 10
	div	ebx

	;//convert edx to ASCII
	add	edx, 48
	push	edx	;//push to stack to easily reverse later
	inc	ecx	;//count of # items pushed to stack

	cmp	eax, 0
	jg	L1

	mov	edi, [ebp + 12]
	cld

;//pop numbers off stack to create string in correct order
reverse:
	pop	eax
	stosb
	loop	reverse

	mov	eax, 0
	stosb

	displayString [ebp + 12] ;//display integer

	pop	edx
	pop	ecx
	pop	ebx
	pop	eax
	pop	ebp
	ret	8
WriteVal ENDP


;//----------------------------------------------------------------------------
;//DispSumAvg
;//reads 32 bit unsigned int from user input
;//Receives: @string to store converted integer, @label for sum value,
;//	@label for avg, @array of values, and num values in array
;//Returns: nothing
;//----------------------------------------------------------------------------
DispSumAvg PROC
	push	ebp
	mov	ebp, esp
	push	eax
	push	ebx
	push	ecx
	push	esi

;//calculate and display sum
	mov	esi, [ebp + 12] ;//@array of values to sum
	mov	ecx, [ebp + 8]	 ;//SIZEOF array
	mov	ebx, TYPE DWORD
	mov	eax, 0
sumLoop:
	add	eax, [esi]
	add	esi, ebx
	loop sumLoop

;//display sum
	displayString [ebp + 20]
	push	[ebp + 24]	;//address of string to write
	push	eax			;//sum
	call WriteVal
	call	CrLf

;//display avg
	displayString[ebp + 16]
	XOR	edx, edx
	mov	ebx, [ebp + 8]
	div	ebx
	push	[ebp + 24]
	push	eax
	call	WriteVal
	call	CrLf

	pop	esi
	pop	ecx
	pop	ebx
	pop	eax
	pop	ebp
	ret	20
DispSumAvg ENDP

END main