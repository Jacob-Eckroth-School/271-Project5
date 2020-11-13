;Name: Jacob Eckroth
;Date: November 8, 2020
;Program Number Five
;Program Description: This program asks the user to enter a number between 16 and 256.
;It then generates and fills an array based on numbers between 64-1024. It then sorts this
;list using bubble sort, and prints the sorted list, as well as calculates and prints the
;median and the average value of the array.
TITLE Composite Numbers

 .386
 .model flat,stdcall
 .stack 4096
 ExitProcess PROTO, dwExitCode:DWORD



INCLUDE Irvine32.inc
INCLUDE io.inc
INCLUDE algs.inc

.data				;Messages initialized here

sortedTitle BYTE "The sorted list:",13,10,0
unsortedTitle BYTE "The unsorted random numbers:",13,10,0

introTitle BYTE "Sorting Random Integers Programmed by Jacob Eckroth",13,10,0

description BYTE "This program generates random numbers in the range [64, 1024],",
" displays the original list, sorts the list, and calculates the median value and the average value.",
" Finally, it displays the list sorted in descending order.",13,10,0

howManyPrompt BYTE "How many numbers should be generated? [16, 256]: ",0
okPrompt BYTE "OK!",13,10,0
invalidPrompt BYTE "Invalid input",13,10,0
medianMessage BYTE "The median is ",0
averageMessage BYTE "The average is ",0



.data?
request DWORD ?
array DWORD 256 DUP(?)


.code
;Executes the entire program.
;No pre or post conditions.
main PROC
  call  Randomize

  push  OFFSET description
  push  OFFSET introTitle
    
  call  introduction                    ;Prints introduction to the user


  push  OFFSET invalidPrompt
  push  OFFSET okPrompt
  push  OFFSET howManyPrompt
  push  OFFSET request
  call  getData                         ;Gets input for how many numbers they want

  push  OFFSET array
  push  request
  call  fillArray                       ;Fills the array
  
  push  OFFSET unsortedTitle
  push  OFFSET array
  push  request
  call  displayList                     ;Displays unsorted array


  push  request
  push  OFFSET array
  call  sortList                        ;Sorts the array

  call  crlf
  push  OFFSET averageMessage
  push  OFFSET array
  push  request
  call  displayAverage                 ;Displays the average value of the array


  push  OFFSET medianMessage
  push  OFFSET array
  push  request
  call  displayMedian                   ;Displays the median value of the array

  push  OFFSET sortedTitle
  push  OFFSET array
  push  request
  call  displayList                     ;Prints the sorted list
  





INVOKE ExitProcess, 0
main ENDP


END main