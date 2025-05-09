.ORIG x3000

LD R2, ECHO			; Sets R2 to be where our echoed string starts
LEA R0, PROMPT
PUTS				; Prints out the prompt

C1 GETC				; Gets the first character in the packing
OUT
ADD R1, R0, #-10		; Checks to see if the first entered character is a new line
BRnp C2				; Takes in second character only if first is not new line
STR R0, R2, #0			; Stores a Null character where the current end of string is
BRnzp DONE

C2 AND R4, R4, #0		; Clears out R4
ADD R4, R4, R0			; Places value of R0 into R4
LD R1, LOW			
AND R4, R4, R1			; Clears out the upper byte of R4
GETC				; Gets the second character in the packing
ADD R1, R0, #-10		; Checks to see if the second entered character is a new line
BRnp PACK			; If neither character is a new line we pack them together
STR R4, R2, #0			; Stores the packed form of a character and Null at the current end of string

PACK AND R3, R3, #0		; Clears out R3
ADD R3, R3, R0			; Places value of R0 into R3
LD R1, LOW
AND R3, R1, R3			; Clears out the upper byte of R3
AND R0, R0, #0			; Clears out R0
ADD R0, R0, #8			; Places x0008 into R0
ADD R1, R3, #0			; Places the value in R3 into R1

SHIFT ADD R1, R1, R1		; Shifts the contents of R1 one to the left
ADD R0, R0, #-1			; Decrements our shift counter (R0)
BRp SHIFT

ADD R3, R1, #0			; Places the value of R1 into R3
LD R1, HIGH
AND R3, R1, R3			; Clears out the lower byte of R3
ADD R4, R3, R4			; Packs the 2 characters together
STR R4, R2, #0			; Stores the packed characters at the current end of string
ADD R2, R2, #1			; Increments the end of the string by 1
BRnzp C1

DONE PUTSP			; Prints out the string
HALT
 


PROMPT 	.STRINGZ "Enter string to echo: "
ECHO 	.FILL x3100				; Start of echoed string
LOW	.FILL x00FF
HIGH	.FILL xFF00
.END
