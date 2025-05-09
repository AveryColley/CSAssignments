.ORIG x4000

STI R6, STACK_R6
LD R6, STACK

; Preserves the value of all of the registers prior to starting

STR R0, R6, #0		; R0 -> x4700
STR R1, R6, #-1		; R1 -> x46FF
STR R2, R6, #-2		; R2 -> x46FE
STR R3, R6, #-3		; R3 -> x46FD
STR R4, R6, #-4		; R4 -> x46FC
STR R5, R6, #-5		; R5 -> x46FB
			; R6 -> x46FA (Because of line 3)
STR R7, R6, #-7		; R7 -> x46F9

LEA R0, PROMPT
PUTS			; Prints out the prompt
LD R1, CHARACTER_COUNT	; #5 -> R1

CHAR_GET		; Label for getting characters

GETC
OUT

LD R2, X_VAL		; x0078 -> R2
NOT R2, R2
ADD R2, R2, #1		; 2's complement of X_VAL
ADD R2, R2, R0		; Checks to see if inputted character is 'x'
BRz X_DETECTED		; Branches to X_DETECTED if inputted character is 'x'

LD R2, ALPHA_VAL	; x0041 -> R2
NOT R2, R2
ADD R2, R2, #1		; 2's complement of ALPHA_VAL
ADD R2, R2, R0		; Checks to see if inputted character is A-F
BRzp ALPHA_DETECTED	; Branches to ALPHA_DETECTED if inputted character is A-F

LD R2, NUMERIC_VAL	; x0030 -> R2
NOT R2, R2
ADD R2, R2, #1		; 2's complement of NUMERIC_VAL
ADD R2, R2, R0		; Checks to see if inputted character is 0-9
BRzp NUMERIC_DETECTED	; Branches to NUMERIC_DETECTED if inputted character is 0-9
BRnzp CHAR_FINISHED

ALPHA_DETECTED		; Label for when given character is A-F, converts from ASCII to hex

ADD R2, R2, #10		; Undoes the comparison between R2 and R0
ADD R3, R1, #-1		; Decrements CHARACTER_COUNT and checks if a bitshift is necessary
BRz CHAR_FINISHED
ADD R3, R3, #-1		; The correct amount of bitshifts to run
BRnzp BITSHIFT

NUMERIC_DETECTED	; Label for when given character is 0-9, converts from ASCII to hex
ADD R3, R1, #-1		; Checks if bitshift is necessary. R2 is already in hex from the comparison with R0 earlier
BRz CHAR_FINISHED
ADD R3, R3, #-1		; The correct amount of bitshifts to run

BITSHIFT		; Label for bitshifting R2 using R3

ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R3, R3, #-1		; One bitshift has been completed
BRzp BITSHIFT		; More bitshifts required
BRnzp CHAR_FINISHED	; Done bitshifting

X_DETECTED		; Allows us to start reading the given address
CHAR_FINISHED		; Indicates a character is shifted over the proper amount and adds it to R4

ADD R4, R2, R4
ADD R1, R1, #-1		; A character has been taken care of
BRp CHAR_GET		; More characters still need to be received

LD R0 NEWLINE_VAL	; Loads a newline character into R0
OUT			; Prints out that newline character
AND R0, R0, #0
ADD R0, R0, R4		; Puts R4 into R0, which is our output register

; Restores all of the registers back to where they were at the beginning (except our output register R0)

LDR R1, R6, #-1 	; Value at x46FF -> R1
LDR R2, R6, #-2		; Value at x46FE -> R2
LDR R3, R6, #-3		; Value at x46FD -> R3
LDR R4, R6, #-4		; Value at x46FC -> R4
LDR R5, R6, #-5		; Value at x46FB -> R5
LDR R7, R6, #-7		; Value at x46F9 -> R7
LDR R6, R6, #-6 	; Value at x46FA -> R6

RET			; Done

; Global Variables:
; ------------------

STACK		.FILL x4700				; Defines the starting address of the stack
STACK_R6	.FILL x46FA				; Defines where R6 will be stored in the stack before running

CHARACTER_COUNT	.FILL #5				; Defines how many characters are expected to be inputted
PROMPT		.STRINGZ "Enter your address: \n"	; Defines the string prompt

X_VAL		.FILL x0078				; Hex value of 'x' in ASCII
ALPHA_VAL	.FILL x0041				; Hex value of the start of A-F
NUMERIC_VAL	.FILL x0030				; Hex value of the start of 0-9
NEWLINE_VAL	.FILL x000A				; Hex value of a newline character

; ------------------
.END
