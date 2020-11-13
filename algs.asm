
.386
.model flat,stdcall
.stack 4096

INCLUDE Irvine32.inc
INCLUDE algs.inc

.const
hi = 1024
lo = 64


.code



;-----------------------------------------------------
; Name: fillArray
; Description: Fills a given array passed by reference with random numbers between the constants lo and hi.
; Receives: the amount of numbers to be generated in [ebp+8], and the offset of the array to fill in [ebp+12]
; Returns/registers changed: updates the array held in [ebp+12] to hold "request" amount of random values.
; Preconditions: request is a number less than 256, because that is how much space is allocated for the array.
;-----------------------------------------------------
fillArray PROC
	
	
	push	ebp
	mov		ebp, esp

	push	eax					;Saves the general purpose registers we'll be using
	push	ebx
	push	ecx



	mov		ecx, [ebp+8]		;Moves the amount of numbers to be generated into ecx
	mov		ebx, [ebp+12]
fillNumberLoop:

	mov		eax, hi
	sub		eax, lo				;Sets the range from 0 to hi-1, but we increase hi by 1.
	inc		eax
	call	RandomRange
	add		eax, lo				;Add low so the range goes from lo-hi
		
	 
	mov		[ebx], eax

	add		ebx, 4
	loop	fillNumberLoop



	pop		ecx
	pop		ebx
	pop		eax
	pop		ebp

	ret		8
fillArray ENDP



.const
j EQU [ebp - 4]
lowVal EQU [ebp-8]			;lowerVal and higherVal store j and j+1 place in array.
higherVal EQU [ebp-12]
.code

;-----------------------------------------------------
; Name: sortList
; Description: Sorts an array of integers from low to high using bubble sort.
; Receives: The offset of the array in [ebp+8], and the amount of values held in the array in [ebp+12]
; Returns/registers changed: updates the array held in [ebp+12] to hold "request" amount of random values.
; Preconditions: request is a number less than 256, because that is how much space is allocated for the array.
;-----------------------------------------------------
sortList PROC
	push	ebp
	mov		ebp, esp
	sub		esp, 12
	mov		DWORD PTR lowVal, 0
	mov		DWORD PTR higherVal, 0
	mov		DWORD PTR j, 0


	push	eax
	push	ebx
	push	ecx


	mov		ecx, [ebp+12]
	dec		ecx						;because bubble sort n-1, so that the check checks the last element.
	
mainBubbleLoop:
	mov		eax, 0
	mov		j, eax
	
innerLoop:
		
	cmp		j, ecx				;Checks if we're at the last index to be checked.
	jge		exitLoop	
	push	ecx
			
	mov		ebx, [ebp+8]		;Calculates the value held at index j, and stores it into lowVal
	mov		j, eax
	mov		ecx, 4
	mul		ecx
	add		ebx, eax
	mov		eax, [ebx]
	mov		lowVal, eax	


	mov		ebx, [ebp+8]		;Calculates the value held at index j+1, and stores it into higherVal
	mov		eax, j
	inc		eax
	mov		ecx, 4
	mul		ecx
	add		ebx, eax
	mov		eax, [ebx]
	mov		higherVal, eax

	mov		eax, lowVal			;If the lower index value is less than the higher val, then we swap them with the exchangeElements procedure.
	cmp		eax, higherVal
	jge		noSwap


	push	j
	mov		eax, j
	inc		eax
	push	eax
	push	[ebp+8]
	call	exchangeElements
	
	noSwap:

	mov		eax, j			;We increase j, and continue looping.
	inc		eax
	mov		j, eax
	pop		ecx
	jmp		innerLoop
	
exitLoop:



loop mainBubbleLoop
	pop		ecx
	pop		ebx
	pop		eax

	mov		esp, ebp					;Removes locals from the stack
	pop		ebp
	ret		8							;cleans up the variables passed to the function

sortList ENDP

.const
actualiIndex EQU [ebp-4]
actualjIndex EQU [ebp-8]
.code

;-----------------------------------------------------
; Name: exchangeElements
; Description: Swaps 2 elements in an array based on their index.
; Receives: Offset of the array in [ebp+8], first index to swap in [ebp+12] and second index to swap in [ebp+16]
; Returns/registers changed: updates the array held in [ebp+8], by swapping the element at the first index with the element at the second index
; Preconditions: i and j are both less than the total amount of items in the array.
;-----------------------------------------------------
exchangeElements PROC
	push	ebp
	mov		ebp, esp
	sub		esp, 8
	mov		DWORD PTR actualiIndex, 0					;Local variables to hold the actual index, which is the index * 4 because each element is a DWORD
	mov		DWORD PTR actualjIndex, 0

	push	eax											;Saves registers changed
	push	ebx
	push	ecx
	

	mov		eax, [ebp+12]								;setting iIndex
	mov		ecx, 4
	mul		ecx
	mov		actualiIndex, eax
	
	mov		eax, [ebp+16]								;setting jIndex
	mov		ecx, 4
	mul		ecx
	mov		actualjIndex, eax
	
	
	mov		ebx, [ebp+8]								;Swapping the elements into the actual array
	add		ebx, actualiIndex
	mov		eax, [ebx]									

	mov		ebx, [ebp+8]
	add		ebx, actualjIndex
	mov		ecx, [ebx]									;Stores element at index j

	mov		[ebx], eax									;Moves element from index i into index j
	mov		ebx, [ebp+8]
	add		ebx, actualiIndex
	mov		[ebx], ecx									;Moves stored element from inex j to index i
	

	pop		ecx
	pop		ebx
	pop		eax

 	mov		esp, ebp									;Removes locals from the stack
	pop		ebp
	ret		12	

exchangeElements ENDP



.const
numbersInArray EQU [ebp + 8]
array EQU [ebp+12]
totalCount EQU [ebp-4]
.code
;-----------------------------------------------------
; Name: displayAverage
; Description: Calculates the average number in an array and returns it in eax
; Receives: Amount of numbers in array in [ebp+8], offset of array in [ebp+12]
; Returns/registers changed: Sets eax to hold the rounded average.
; Preconditions: Array is filled with random numbers, and the amount of numbers is the same as [ebp+8]
;-----------------------------------------------------
calculateAverage PROC
	push	ebp
	mov		ebp, esp
	sub		esp, 4
	mov		DWORD PTR totalCount, 0			;Local variable to keep track of totalCount of all the elements
	push	ebx
	push	ecx


	mov		ecx, numbersInArray
	mov		ebx, array
addingLoop:
	mov		eax,	[ebx]					;Loops through whole array using indirect addressing
	add		totalCount, eax				
	add		ebx, 4

	loop	addingLoop

	push	numbersInArray
	push	totalCount
	call	roundNumber					;Rounds the number calculated by the average

	pop		ecx
	pop		ebx

	mov		esp, ebp
	pop		ebp
	ret		8
calculateAverage ENDP



.const
numbersInArray EQU [ebp + 8]
array EQU [ebp+12]
.code
;-----------------------------------------------------
; Name: calculateMedian
; Description: calculates the median number of an array, if there are 2 middle numbers, it averages them and rounds.
; Receives: Amount of numbers in array in [ebp+8], offset of array in [ebp+12], median message in [ebp+16]
; Returns/registers changed: returns median in EAX
; Preconditions: Array is filled with random numbers, and the amount of numbers is the same as [ebp+8]
;-----------------------------------------------------
calculateMedian PROC
	push	ebp
	mov		ebp, esp

	push	ebx
	push	ecx


	mov		eax, numbersInArray
	mov		ebx, 2
	cdq
	div		ebx

	cmp		edx, 0					;If there is an even number, then we have to average the middle 2. Otherwise the median is the middle number
	je		evenNumber

	mov		ecx, eax
	inc		eax

	mov		ebx, array
getToMiddleNumber:
	
	add		ebx, 4					;Iterating to get to the middle number, if there's only one middle number.
	loop	getToMiddleNumber

	mov		eax, [ebx]
	jmp		endOfProc

evenNumber:
	mov		ecx, eax
	dec		ecx

	mov		ebx, array
getMiddleTwoNumbers:			;Iterating to the first middle number since there are 2 middle numbers that we need to average
	add		ebx, 4

	loop	getMiddleTwoNumbers
	mov		eax, [ebx]
	add		eax, [ebx+4]		;Adds the 2 middle numbers together
	
	
	mov		ecx, 2
	push	ecx
	push	eax
	call roundNumber

endOfProc:

	pop		ecx					;Restoring saved registers
	pop		ebx
	pop		ebp
	ret		8
calculateMedian ENDP


;-----------------------------------------------------
; Name: roundNumber
; Description: Divides a number, by a divident and returns the rounded sum in eax.
; Receives: Number received in [ebp+8], number to divide by in [ebp+12]
; Returns/registers changed: Updates eax to hold the number divided. Note, only works for positive decimals.
; Preconditions: Number is in [ebp+8], and in [ebp+12]
;-----------------------------------------------------
roundNumber PROC
	push	ebp
	mov		ebp, esp
	
	push	ecx
	push	edx


	mov		eax, [ebp+8]		;Divides number by divisor
	mov		ecx, [ebp+12]
	cdq
	div		ecx

	add		edx, edx			;Doubles the remainder, to check if it's greater than original denominator i.e. >= .5
	cmp		edx, [ebp+12]		
	jl		dontRoundUp
	inc		eax

dontRoundUp:

	pop		edx
	pop		ecx

	pop		ebp	
	ret		8
roundNumber ENDP


END