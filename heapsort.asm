;
; heapsort.asm
;
; Created: 1/3/2019 2:18:51 PM
; Author : Joshua
;

; assume we are using an Atmega328P, the microprocessor in the Arduino Uno
.include "m328Pdef.inc"

; on reset go to the setup label
.ORG 0x0000
rjmp setup

setup:
	; define some useful references
	.def i = r16
	.def heapSize = r17
	.def parentAddr = r18
	.def currentAddr = r19
	.def currentVal = r20
	.def parentVal = r21
	.def heapEndAddr = r22

	; load the numbers to be sorted into memory addresses 0x0100-0x0104
	ldi r16, 10
	sts 0x0100, r16
	ldi r16, 2
	sts 0x0101, r16
	ldi r16, 27
	sts 0x0102, r16
	ldi r16, 7
	sts 0x0103, r16
	ldi r16, 15
	sts 0x0104, r16
	; set the references
	clr i
	ldi heapSize, 5
	mov heapEndAddr, heapSize
	dec heapEndAddr
	; set z register
	ldi zh, 0x01
	ldi zl, 0x00


; Build the max heap in place
buildHeap:
	; if we have cycled through every element, move on to deconstruct the heap
	cp i, heapSize
	breq deconstructHeap
	; copy the the current element number into the currentAddress register
	mov currentAddr, i

bubbleUp:
	; if the current address is 0, we're done bubbling up
	cpi currentAddr, 0
	breq increment
	; move the curretnt address into z low
	mov zl, currentAddr
	; get the value at the current address
	ld currentVal, z
	; copy the current address to the parent address
	mov parentAddr, currentAddr
	; subtract one
	subi parentAddr, 1
	; and bit shift right to divide by 2
	asr parentAddr
	; copy the parent address into z low
	mov zl, parentAddr
	; get the value at the parent address
	ld parentVal, z
	; compare the two values
	cp parentVal, currentVal
	; and if the parent is less than the current, swap them
	brlt swapElement
	; otherwise move onto the next element
	rjmp increment

swapElement:
	; store the current value to the parent address
	st z, currentVal
	; set the z pointer to the current address
	mov zl, currentAddr
	; store the parent value in the current address
	st z, parentVal
	; set the current address to the parent
	mov currentAddr, parentAddr
	; go back to the bubble loop
	rjmp bubbleUp
	

; increment the loop counter and move to the next element
increment:
	inc i
	rjmp buildHeap

deconstructHeap:
	; reuse the parent registers to avoid conflicting with definitions in "m328Pdef.inc"
	.undef parentAddr
	.undef parentVal
	; define some references for the left and right children
	.def rightChildVal = r23
	.def leftChildVal = r24
	.def rightChildAddr = r25
	.def leftChildAddr = r18
	.def heapEndVal = r21

	;break

	; if i is equal to 0 the heap has been deconstructed
	cpi i, 0
	; go to the end
	breq end

	; set the current address to the first (biggest) element in the max heap
	ldi currentAddr, 0
	; set the z pointer to the last heap element address
	mov zl, heapEndAddr
	; store the value in heapEndVal
	ld heapEndVal, z
	; set the z pointer to the current element address
	mov zl, currentAddr
	; store the value in currentVal
	ld currentVal, z

	; store the last heap element in the current (root) element
	st z, heapEndVal
	; set the z pointer to the last heap element address
	mov zl, heapEndAddr
	; store the first (max) heap element at last heap element
	st z, currentVal
	; update currentVal
	mov currentVal, heapEndVal
	; decrement the heap end address
	dec heapEndAddr

bubbleDown:
	; copy the current address into left child address
	mov leftChildAddr, currentAddr
	; bit shift left (multiply by 2)
	lsl leftChildAddr
	; add one
	inc leftChildAddr
	; copy the left child to the right child
	mov rightChildAddr, leftChildAddr
	; and add one again
	inc rightChildAddr

	; if the left child address is out of bounds decrement and continue the deconstruct loop
	cp heapEndAddr, leftChildAddr
	brlt decrement

	; set the z pointer and fetch the left child value
	mov zl, leftChildAddr
	ld leftChildVal, z

	; if the right child address is out of bounds go directly to left swap
	cp heapEndAddr, rightChildAddr
	brlt leftSwap

	; set the z pointer and fetch the right child value
	mov zl, rightChildAddr
	ld rightChildVal, z

	; find the max child
	cp leftChildVal, rightChildVal
	brlt rightSwap

leftSwap:
	; make sure that the max child is in fact greater than the current element
	cp currentVal, leftChildVal
	; if not, decrement the counter and heap end address
	brge decrement
	; copy the left child address to the z pointer
	mov zl, leftChildAddr
	; store the current value to the left child address
	st z, currentVal
	; set the z pointer to the current address
	mov zl, currentAddr
	; store the left child value in the current address
	st z, leftChildVal
	; set the current address to the left child
	mov currentAddr, leftChildAddr
	; set the current val to the left child
	mov currentVal, leftChildVal
	; go back to the bubble loop
	rjmp bubbleDown

rightSwap: 
	; make sure that the max child is in fact greater than the current element
	cp currentVal, rightChildVal
	; if not, decrement the counter and heap end address
	brge decrement
	; copy the right child address to the z pointer
	mov zl, rightChildAddr
	; store the current value to the right child address
	st z, currentVal
	; set the z pointer to the current address
	mov zl, currentAddr
	; store the right child value in the current address
	st z, rightChildVal
	; set the current address to the right child
	mov currentAddr, rightChildAddr
	; set the current val to the right child
	mov currentVal, rightChildVal
	; go back to the bubble loop
	rjmp bubbleDown

; decrement the loop counter and run the loop again for the next element
decrement:
	dec i
	rjmp deconstructHeap

; when we are done just run this infinite loop
end:
	rjmp end

	

	

    
