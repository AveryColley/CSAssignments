.ORIG x5000

MEMDUMP						; Loops through addresses and prints out both the adress and the value at that address
						; R0 -> R1
STI R6, OUT_STACK_R6
LD R6, OUT_STACK_BASE

; Preserves the value of all the registers prior to starting

STR R0, R6, #0		; R0 -> x5FFF
STR R1, R6, #-1		; R1 -> x5FFE
STR R2, R6, #-2		; R2 -> x5FFD
STR R3, R6, #-3		; R3 -> x5FFC
STR R4, R6, #-4		; R4 -> x5FFB
STR R5, R6, #-5		; R5 -> x5FFA
			; R6 -> x5FF9 (Because of line 5)
STR R7, R6, #-7		; R7 -> x5FF8

ADD R6, R6, #-8		; Moves R6 to x5FF7

AND R4, R4, #0
ADD R4, R4, R0		; Copies R0 to R4
AND R5, R5, #0
ADD R5, R5, R1		; Copies R1 to R5

LEA R0, MEMCONBEGIN
PUTS			; Prints out the first part of the header line

AND R0, R0, #0
ADD R0, R4, R0		; Copies R4 to R0
JSR WORD_OUT

LEA R0, MEMCONMIDDLE
PUTS			; Prints out the middle part of the header line

AND R0, R0, #0
ADD R0, R5, R0		; Copies R5 to R0
JSR WORD_OUT

LEA R0, MEMCONEND
PUTS			; Prints out the ending part of the header line

LD R0, CHAR_NL
OUT			; Prints a newline character

MDLOOP			; Prints out each address and the value at that address from R4 to R5

AND R3, R3, #0
ADD R3, R4, R3		; Copies R4 to R3
NOT R3, R3		
ADD R3, R3, #1		; 2's complement of R3 (R4)
ADD R3, R5, R3		; Checks to see if R5 < R4
BRn MDMP_EXIT

AND R0, R0, #0
ADD R0, R4, R0		; Copies R4 to R0
JSR WORD_OUT

LD R0, CHAR_SPACE
OUT
OUT
OUT			; Prints out 3 spaces

LDR R0, R4, #0		; Loads contents of memory address in R4 to R0
JSR WORD_OUT 

LD R0, CHAR_NL
OUT			; Prints out a newline character

ADD R4, R4, #1
BRnzp MDLOOP

MDMP_EXIT
; Undoes the Stack to how it was before this was called

ADD R6, R6, #8		; Undoes stack address movement from beginning of function

LDR R0, R6, #0		; Value from x5FFF -> R0
LDR R1, R6, #-1		; Value from x5FFE -> R1
LDR R2, R6, #-2		; Value from x5FFD -> R2
LDR R3, R6, #-3		; Value from x5FFC -> R3
LDR R4, R6, #-4		; Value from x5FFB -> R4
LDR R5, R6, #-5		; Value from x5FFA -> R5
LDR R7, R6, #-7		; Value from x5FF8 -> R7
LDR R6, R6, #-6		; Value from x5FF9 -> R6

RET

WORD_OUT

; Preserves the value of all the registers prior to starting

STR R0, R6, #0		; R0 -> x5FF7
STR R1, R6, #-1		; R1 -> x5FF6
STR R2, R6, #-2		; R2 -> x5FF5
STR R3, R6, #-3		; R3 -> x5FF4
STR R4, R6, #-4		; R4 -> x5FF3
STR R5, R6, #-5		; R5 -> x5FF2
STR R6, R6, #-6		; R6 -> x5FF1
STR R7, R6, #-7		; R7 -> x5FF0

ADD R6, R6, #-8		; Moves R6 to x5FEF

LD R0 CHAR_X
OUT			; Prints out 'x'

LEA R5 NIBBLE_1_SHIFT	; Loads the address of the first amount of times to shift to R5

WO_NIBBLE_LOOP		; Prints out each label (in ASCII) from most significant to least

LD R1, MSD_MASK
LDR R0, R6, #8		; Loads the value in x5FF7 to R0

LDR R3, R5, #0		; Loads the amount of times to shift into R3
BRz WO_NIB_SHIFT_DONE	; Don't need to shift anymore

WO_CLS_LOOP		; Sets up the circular left shift and calculates whether or not we continue shifting

AND R2, R0, R1		; Checks whether or not we add 1
BRz WO_CLS
AND R2, R2, #0
ADD R2, R2, #1

WO_CLS			; Performs the circular left shift

ADD R0, R0, R0		; Perform a left shift by one place value
ADD R0, R0, R2		; Adds the carry bit from R2
ADD R3, R3, #-1
BRp WO_CLS_LOOP

WO_NIB_SHIFT_DONE	; Need to determine if the character is alphabetical or numeric

LD R1, NUM_MASK		; Loads x000F into R1
AND R0, R1, R0
LD R1, CHAR_NL		; Loads x000A into R1
NOT R1, R1
ADD R1, R1, #1		; 2's complement of R1
ADD R1, R1, R0
BRn WO_CHAR_NUM		; We need to turn a number into ASCII

AND R0, R0, #0
ADD R0, R1, R0		; Copies R1 to R0
LD R1, ALPHA_BASE
ADD R0, R1, R0		; Gets the ASCII version of the nibble (A-F)
BRnzp WO_CHAR_PRINT

WO_CHAR_NUM		; Turns a number into ASCII

LD R1, DIGIT_BASE	; Loads x0030 into R1
ADD R0, R1, R0		; Gets the ASCII version of the nibble (0-9)

WO_CHAR_PRINT		; Prints out the character and sets up for the next iteration of the loop

OUT			; Prints the ASCII Version of the nibble
LDR R3, R5, #0		; Reloads the word we are turning into ASCII
BRz WO_EXIT		; At the end of NIBBLE_1_SHIFT	
ADD R5, R5, #1
BRnzp WO_NIBBLE_LOOP	; Still need to shift

WO_EXIT
; Undoes the Stack to how it was before this was called

ADD R6, R6, #8		; Undoes stack address movement from beginning of function

LDR R0, R6, #0		; Value from x5FF7 -> R0
LDR R1, R6, #-1		; Value from x5FF6 -> R1
LDR R2, R6, #-2		; Value from x5FF5 -> R2
LDR R3, R6, #-3		; Value from x5FF4 -> R3
LDR R4, R6, #-4		; Value from x5FF3 -> R4
LDR R5, R6, #-5		; Value from x5FF2 -> R5
LDR R7, R6, #-7		; Value from x5FF0 -> R7
LDR R6, R6, #-6		; Value from x5FF1 -> R6

RET			; Done

; Global Variables: 
; ------------------

MEMCONBEGIN	.STRINGZ "Memory Contents "	; Beginning of the header line
MEMCONMIDDLE	.STRINGZ " to "			; Middle of the header line
MEMCONEND	.STRINGZ ":"			; End of the header line		
CHAR_X		.FILL x0078			; Value for 'x' in ASCII
CHAR_NL		.FILL x000A			; Value for the newline character in ASCII			
CHAR_SPACE	.FILL x0020			; Value for the space character in ASCII

OUT_STACK_BASE	.FILL x5FFF			; Base address of the stack
OUT_STACK_R6	.FILL x5FF9			; Where R6 goes before running

NIBBLE_1_SHIFT	.FILL #4			; Amount to shift each nibble left circularly by
		.FILL #8
		.FILL #12
		.FILL x0000

MSD_MASK	.FILL x8000			; Mask that looks for the most significant bit being set
NUM_MASK	.FILL x000F			; Mask that looks for the lowest nibble of being set
ALPHA_BASE	.FILL x0041			; Beginning of uppercase ASCII
DIGIT_BASE	.FILL x0030			; Beginning of digits in ASCII

; ------------------

.END