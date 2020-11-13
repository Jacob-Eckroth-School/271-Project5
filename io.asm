.386
.model flat,stdcall
.stack 4096

INCLUDE Irvine32.inc
INCLUDE algs.inc
INCLUDE io.inc
.const
;Limits DEFINED AS CONSTANTS
max = 256
min = 16


.code

;-----------------------------------------------------
; Name: introduction
; Description: Prints the program title, and description
; Receives: Offset of intro message in [ebp+8] and offset of description message in [ebp+12]
; Returns/registers changed: N/A
; Preconditions: intro and description messages are defined.
;-----------------------------------------------------
introduction PROC
	push	ebp
	mov		ebp, esp

	push	edx							;Saves registers changed

	mov		edx, [ebp + 8]				;Prints Intro Message
	call	WriteString

	call	crlf

	mov		edx, [ebp + 12]				;Prints Program Description
	call	WriteString


	pop		edx
	pop		ebp
    ret		8							;Cleans up the stack
introduction ENDP




.const
requestParameter EQU [ebp + 8]
howManyParameter EQU [ebp+12]
okPrompt EQU [ebp+16]
invalidPrompt EQU [ebp+20]

.code
;-----------------------------------------------------
; Name: getData
; Description: gets input into requestParameter from user, in the range between min and max constants
; Receives: offset of request in [ebp+8], offset of ow many prompt string in [ebp+12], ok string offest in [ebp+16], invalid prompt offset in [ebp+20]
; Returns/registers changed: updates the request parameter to hold the value entered by the user.
; Preconditions: all strings are defined, and min and max constants are set
;-----------------------------------------------------
getData PROC
	push	ebp
	mov		ebp, esp

	push	eax
	push	ebx
	push	edx
	

getDataAgain:

	mov		edx, howmanyParameter		;Asks how many numbers the user wants to view
	call	WriteString

	call	ReadDec

	cmp		eax, min					;Checks to make sure that the user entered value is in the right range, if not loop again
	jl		invalid
	cmp		eax, max
	jg		invalid
	jmp		valid
invalid:
	mov		edx, invalidPrompt
	call	WriteString

	jmp		getDataAgain
valid:
	mov		edx, okPrompt
	call	WriteString

	
	mov		ebx, requestParameter		;RequestParameter holds the offset.
	mov		[ebx], eax					;EBX allows us to move something into the address of the offset

	pop		edx
	pop		ebx
	pop		eax

	pop		ebp
	ret		16
getData ENDP


;-----------------------------------------------------
; Name: displayList
; Description: Displays a title of an array, then displays all the numbers in the array, 5 per line, with spaces in between
; Receives: offset of array title in [ebp+16], amount of numbers in array in [ebp+8], and array offset in [ebp+12]
; Returns/registers changed: N/A
; Preconditions: array has at least [ebp+8] values in it, and all strings are defined.
;-----------------------------------------------------
displayList PROC
	push	ebp
	mov		ebp, esp

	push	eax
	push	ebx
	push	ecx

	mov		edx, [ebp+16]
	call	WriteString

	mov		ecx, [ebp+8]
	
	mov		ebx, [ebp+12]				;EBX holds our array
	
	mov		eax, 0						;EAX keeps track of how many numbers we've printed per line.
printLoop:

	push	eax

	mov		eax, [ebx]
	call	WriteDec
	
	mov		al,	32						;Prints a space
	call	WriteChar
	

	pop		eax
	inc		eax
	cmp		eax, 5						;If we've printed 5 numbers, make a new line
	jne		noNewLine
	call	crlf
	mov		eax, 0

noNewLine:
	
	add		ebx, 4
	loop	printLoop


	pop		ecx
	pop		ebx
	pop		eax

	pop		ebp
	ret		12
displayList ENDP




.const
numbersInArray EQU [ebp + 8]
array EQU [ebp+12]
averagePrompt EQU [ebp+16]
.code
;-----------------------------------------------------
; Name: displayAverage
; Description: Displays the average number of an array, rounded
; Receives: Amount of numbers in array in [ebp+8], offset of array in [ebp+12], averageMessage in [ebp+16]
; Returns/registers changed: Prints average
; Preconditions: Array is filled with random numbers, and the amount of numbers is the same as [ebp+8]
;-----------------------------------------------------
displayAverage PROC

	call	crlf

	push	ebp
	mov		ebp, esp
	
	push	eax
	push	edx
	
	mov		edx, averagePrompt
	call	WriteString
	

	push	array
	push	numbersInArray
	call	calculateAverage				;Returns the average number in eax
	
	call	writeDec


	mov		al, 46							;Period Character
	call	WriteChar
	call	crlf

	pop		edx
	pop		eax

	
	pop		ebp
	ret		12
displayAverage ENDP


.const
numbersInArray EQU [ebp + 8]
array EQU [ebp+12]
medianPrompt EQU [ebp+16]
.code
;-----------------------------------------------------
; Name: displayMedian
; Description: Displays the median number of an array, if there are 2 middle numbers, it averages them and rounds.
; Receives: Amount of numbers in array in [ebp+8], offset of array in [ebp+12], median message in [ebp+16]
; Returns/registers changed: Prints median, registers saved
; Preconditions: Array is filled with random numbers, and the amount of numbers is the same as [ebp+8]
;-----------------------------------------------------
displayMedian PROC
	push	ebp
	mov		ebp, esp	


	push	eax
	push	edx

	mov		edx, medianPrompt
	call	WriteString

	push	array
	push	numbersInArray
	call	calculateMedian					;Calculates the median and stores in eax
	call	writeDec

	mov		al, 46							;Period Character
	call	WriteChar

	call	crlf
	call	crlf

	pop		edx
	pop		eax


	pop		ebp
	ret		12

displayMedian ENDP

END