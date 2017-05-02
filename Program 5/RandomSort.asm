TITLE Program Composite     (Composite.asm)

; Author: Connor Pacala
; CS271 / Project 2                 Date: 11/8/2015
; Desc: prompts user to enter number between 1-400 inclusive. Calculates and outputs user number of composite numbers

INCLUDE Irvine32.inc

;//constant
MIN = 10
MAX = 200
LO = 100
HI = 999
MAX_SIZE = 200

.data

intro		BYTE	"Random Number Generator and Sorter	By Connor Pacala",0
instruct1		BYTE "This program generates a list of random numbers in the range [",0
instruct2		BYTE "], displays the list, sorts it, displays the median, then displays the sorted list.",0
prompt1		BYTE "How many numbers do you want to generate? [",0
prompt2		BYTE "]: ",0
to			BYTE " to ",0
errInvalid	BYTE	"Error, invalid input.",0
label1		BYTE "The Unsorted Array:",0
label2		BYTE "The Sorted Array:",0
label3		BYTE "The median is: ",0

userVal		DWORD 0
valArray		DWORD MAX_SIZE DUP(?)

.code
main PROC
	call	Randomize

	;//intro
	push	OFFSET intro
	call	dispIntro

	;//instructions
	push	OFFSET instruct1
	push	LO
	push	OFFSET to
	push	HI
	push	OFFSET instruct2
	call	dispInstruct

	;//get user input
	push	OFFSET userVal
	push	OFFSET errInvalid
	push	OFFSET prompt1
	push	OFFSET MIN
	push	OFFSET to
	push	OFFSET MAX
	push	OFFSET prompt2
	call	getData

	;//generate array of random values
	push OFFSET valArray
	push	userVal
	call	fillArray

	;//display array
	push	OFFSET label1
	push	OFFSET valArray
	push	userVal
	call	dispArray

	;//sort array
	push	OFFSET valArray
	push userVal
	call sortArray


	;//calculate and display median
	push	OFFSET label3
	push	OFFSET valArray
	push	userVal
	call	dispMedian

	;//display sorted array
	push	OFFSET label2
	push	OFFSET valArray
	push	userVal
	call	dispArray


	exit	; exit to operating system
main ENDP

;//----------------------------------------------------------------------------
;//dispIntro
;//outputs the intro message
;//Receives: string address for intro message
;//Returns: nothing
;//----------------------------------------------------------------------------
dispIntro PROC
	push	ebp
	mov	ebp, esp

	mov	edx, [ebp + 8]
	call	WriteString
	call	CrLf
	call	CrLf

	pop	ebp
	ret	4
dispIntro ENDP


;//----------------------------------------------------------------------------
;//dispInstruct
;//Prints string to console with range of values.
;//Receives: string address for instruct up to low range, low range value, string
;//	address for instruct between low and high range values, high range value, and
;//	string address for instruct following range values.
;//Returns: nothing
;//----------------------------------------------------------------------------
dispInstruct PROC
	push	ebp
	mov	ebp, esp
	push	eax
	push	edx

	;//display beginning of prompt
	mov	edx, [ebp + 24]
	call	WriteString

	;//display range of numbers generated
	mov	eax, [ebp + 20]
	call	WriteDec
	mov	edx, [ebp + 16]
	call	WriteString
	mov	eax, [ebp + 12]
	call	WriteDec

	;//display end of prompt
	mov	edx, [ebp + 8]
	call	WriteString
	call	CrLf
	call	CrLf

	pop	edx
	pop	eax
	pop	ebp
	ret	20
dispInstruct ENDP


;//getData
;//----------------------------------------------------------------------------
;//getData
;//calls dispPrompt for user to enter values in range of MIN to MAX and validates
;//input
;//Receives: address of value to store user input, address of error message string
;//	address of 3 strings for prompt.
;//Returns: nothing
;//----------------------------------------------------------------------------
getData	PROC
	push ebp
	mov	ebp, esp
	push	eax
	push	edx
L1:
	call	dispPrompt ;//display prompt to enter values to user
	call	ReadInt
	
	;//check if user input between MIN and MAX	
	cmp	eax, MIN
	jl	error
	cmp	eax, MAX
	jle	valid	

error: ;//invalid input
	mov	edx, [ebp + 28]
	call	WriteString
	call	CrLf
	jmp	L1

valid: ;//input valid, store input value address of passed value
	mov	ebx, [ebp + 32] 
	mov	[ebx], eax

	pop	edx
	pop	eax
	pop	ebp
	ret	20
getData	ENDP

;//----------------------------------------------------------------------------
;//dispPrompt
;//displays a prompt for the user. does not modify the system stack.
;//Receives: address of 3 strings for prompt.
;//Returns: nothing
;//----------------------------------------------------------------------------
dispPrompt	PROC
	;//display beginning of prompt
	mov	edx, [ebp + 24]
	call	WriteString

	;//display range of numbers generated
	mov	eax, [ebp + 20]
	call	WriteDec
	mov	edx, [ebp + 16]
	call	WriteString
	mov	eax, [ebp + 12]
	call	WriteDec

	;//display end of prompt
	mov	edx, [ebp + 8]
	call	WriteString

	ret
dispPrompt	ENDP

;//----------------------------------------------------------------------------
;//fillArray
;//fills an array with a sequence of random numbers between LO and HI
;//Receives: address of DWORD array, number of items to place in array
;//Returns: nothing
;//----------------------------------------------------------------------------
fillArray	PROC
	push	ebp
	mov	ebp, esp
	push	ecx
	push	edi

	;//loop counter in ecx and array base index in edi
	mov	ecx, [ebp + 8]
	mov	edi, [ebp + 12]

fLoop: ;//generate random number between HI and LO
	mov	eax, HI
	sub	eax, LO
	inc	eax

	call	RandomRange ;//generate value between 0 and eax - 1
	add	eax, LO

	;//move to next array index and loop
	mov	[edi], eax
	add	edi, TYPE DWORD
	loop fLoop

	pop	edi
	pop	ecx
	pop	ebp
	ret	8
fillArray	ENDP

;//----------------------------------------------------------------------------
;//dispArray
;//writes an array to the screen, 10 items to a line
;//Receives: string address, DWORd array address, number of valid items in array
;//Returns: nothing
;//----------------------------------------------------------------------------
dispArray	PROC
	push ebp
	mov	ebp, esp
	push	eax
	push	esi
	push	ecx
	push	edx
	push	ebx
	
	;//display array label
	call	CrLf
	mov	edx, [ebp + 16]
	call	WriteString
	call	CrLf

	;//move array index to esi and number of valid items in array to ecx
	mov	esi, [ebp + 12]
	mov	ecx, [ebp + 8]

dLoop: ;//line break every 10 items
	mov	eax, ecx
	mov	edx, 0
	mov	ebx, 10
	div	ebx
	cmp	edx, 0
	jne	cont	;//not the 10th item
	call	CrLf

cont: ;//write array value at current index to console with tab after every item
	mov	eax, [esi]
	call	WriteDec
	add	esi, TYPE DWORD
	mov	al, TAB
	call	WriteChar
	loop	dLoop

	call	CrLf

	pop	ebx
	pop	edx
	pop	ecx
	pop	esi
	pop	eax
	pop	ebp
	ret	12
dispArray	ENDP

;//----------------------------------------------------------------------------
;//sortArray
;//sorts an array in decreasing order using BubbleSort.
;//Receives: pointer to DWORD array, array size
;//Returns: nothing
;//----------------------------------------------------------------------------
sortArray PROC
	push	ebp
	mov	ebp, esp
	push	ecx
	push	eax
	push	esi

	mov	ecx, [ebp + 8]	;//number of valid items in array
	dec	ecx

L1: 
	push	ecx ;//save value of ecx for outer loop
	mov	esi, [ebp + 12] ;//point to base index of array

L2:
	mov	eax, [esi]
	cmp	[esi + 4], eax
	jl	L3 ;//index already greater than or equal to following index
	;//exchange array indices
	xchg	eax, [esi + 4] 
	mov	[esi], eax
L3:
	add	esi, TYPE DWORD ;//esi points to next item in array
	loop	L2

	pop	ecx
	loop	L1

	pop	esi
	pop	eax
	pop	ecx
	pop	ebp
	ret	8
sortArray ENDP


;//----------------------------------------------------------------------------
;//dispMedian
;//Calculates and displays the median of an array of sorted integers
;//Receives: pointer to string, pointer to DWORD array, number of valid items in array
;//Returns: nothing
;//----------------------------------------------------------------------------
dispMedian PROC
	push	ebp
	mov	ebp, esp
	push	eax
	push	ebx
	push	edx

	mov	esi, [ebp + 12]

	;//display median is: message
	call	CrLf
	mov	edx, [ebp + 16]
	call	WriteString

	;//find middle of array
	mov	eax, [ebp + 8]
	mov	edx, 0
	mov	ebx, 2
	div	ebx
	;//find correct offset for index number of middle index of array
	mov	ebx, TYPE	DWORD
	mul	ebx
	mov	ebx, eax ;//ebx has offset for middle index (or if even the upper middle index)
	cmp	edx, 0
	jne	odd ;//array has odd number of values, ebx contains offset for middle index

	;//array has even number of values, find average of middle indices
	mov	eax, [esi + ebx] ;//store one middle address in eax
	sub	ebx, TYPE DWORD
	;//add second middle address to first and find average
	add	eax, [esi + ebx]
	mov	ebx, 2
	div	ebx
	jmp	finish

odd:
	mov	eax, [esi + ebx] ;//value stored in middle of array

finish:
	;//display median
	call	WriteDec
	call	CrLf
	call	CrLf

	pop	edx
	pop	ebx
	pop	eax
	pop	ebp
	ret	12
dispMedian ENDP


END main