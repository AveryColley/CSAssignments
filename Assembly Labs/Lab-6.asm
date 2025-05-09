.ORIG x3000

BEGINNING

LD R6, STACK_PTR					; (R6 = x5013)
ADD R6, R6, #-1						; Return value space (R6 = x5012)
ADD R5, R6, #0						; Initialize frame pointer (R5 = x5012)

LEA R4, GLOBAL_VARS					; Loads global variables into R4
LEA R0, PROMPT0						; Loads start of string into R0

PUTS							; Prints prompt
GETC							; Gets user input
OUT							; Prints user input

LD R1, ASCII_NUM					; Loads ASCII_NUM into R1
ADD R3, R1, R0						; Converts the input into an ASCII number and stores it in R3
ADD R1, R1, R0						; Copies value from R0 into R1 (User input)

STR R1, R6, #0						; Stores user input onto the stack
ADD R6, R6, #-1						; Decrements R6 by 1 (R6 = x5011)

JSR FIBONACCI

LDR R2, R5, #-1						; Loads return from Fibonacci into R2
ADD R6, R6, #1						; Pops input to Fibonacci (R6 = x5012)

LEA R0, PROMPT1						; Loads prompt to be printed
PUTS							; Prints prompt
ADD R0, R1, #0						; Copy value from R1 into R0

LD R1, ASCII_NUM					; Loads ASCII_NUM into R1
NOT R1, R1
ADD R1, R1, #1						; Two's complement on R1

ADD R0, R0, R1						; Converts ASCII numeric character to decimal
OUT							; Prints out the decimal character

LEA R0, PROMPT2						; Loads prompt into R0
PUTS							; Prints prompt
ADD R3, R2, #0						; Copies R2 into R3
AND R1, R1, #0						; Clears out R1

CHECK_10s

ADD R1, R1, #1						; Increments R1 to start counting the number of 10s
ADD R3, R3, #-10
BRzp CHECK_10s

ADD R1, R1, #-1
BRz SKIP_PRINT10s					; No 10s

ADD R0, R1, #0						; Copies amount of 10s from output to R0
LD R1, ASCII_NUM					; Loads ASCII_NUM into R1

NOT R1, R1
ADD R1, R1, #1						; Two's complement on R1

ADD R0, R0, R1
OUT							; Prints the 10s place digit

SKIP_PRINT10s

ADD R3, R3, #10						; Failsafe to avoid negatives
AND R1, R1, #0						; Clears out R1

CHECK_1s

ADD R1, R1, #1
ADD R3, R3, #-1						; Decrement our counter
BRzp CHECK_1s

ADD R0, R1, #-1						; Decrement because CHECK_1s will overshoot by 1 otherwise

LD R1, ASCII_NUM					; Loads ASCII_NUM into R1

NOT R1, R1
ADD R1, R1, #1						; Two's complement on R1

ADD R0, R0, R1						; Loads the number to be printed
OUT							; Prints the number

LEA R0, PROMPT3						; Loads the prompt to be printed
PUTS							; Prints the prompt

STR R2, R5, #1						; Loads the main return value onto the stack
ADD R6, R6, #2						; Pops stack (R6 = x5014)

BRnzp BEGINNING
HALT

GLOBAL_VARS
;----------------;

PROMPT0		.STRINGZ "Please enter a number n: "	; The first prompt to print
STACK_PTR	.FILL x5013				; Pointer to the bottom of the stack
ASCII_NUM	.FILL #-48				
PROMPT1		.STRINGZ "\nF("				; The second prompt
PROMPT2		.STRINGZ ") = "				; The third prompt
PROMPT3		.STRINGZ "\n"				; Newline character

;----------------;

FIBONACCI

ADD R6, R6, #-1						; Room for return value (R6 = x5010)
STR R7, R6, #0						; Return Adress

ADD R6, R6, #-1						; (R6 = x500F)
STR R5, R6, #0						; Store R5 in the stack

ADD R6, R6, #-1						; (R6 = x500E)
STR R3, R6, #0						; Store R3 in the stack

ADD R6, R6, #-1						; (R6 = x500D)
STR R2, R6, #0						; Store R2 in the stack

ADD R6, R6, #-1						; (R6 = x500C)
STR R1, R6, #0						; Store R1 in the stack

ADD R6, R6, #-1						; (R6 = x500B)
STR R0, R6, #0						; Store R0 in the stack

ADD R6, R6, #-1						; (R6 = x500A)

ADD R5, R6, #0						; Stack pointer now points to bottom of FIBONACCI's local variables (R5 = x500A)

LDR R2, R5, #8						; Loads input into R2

AND R1, R1, #0						; Clears out R1
ADD R1, R1, #-1						; Places the value -1 into R1 for comparison

ADD R1, R1, R2						; Compares input to 1
BRz END_ALL_CASES
AND R0, R0, #0						; Clears out R0
ADD R0, R0 #1
ADD R1, R2, #0						; Compares input to 0
BRz END_ALL_CASES

ADD R2, R2, #-1						; Subtracts 1 from input (n-1)
STR R2, R6, #0						; Stores input onto stack

ADD R6, R6, #-1						; (R6 = x5009)
JSR FIBONACCI						; Recursive call

LDR R1, R5, #-1						; Loads return into R1
ADD R6, R6, #1						; Pops input for F(n-1) (R6 = x500A)

ADD R2, R2, #-1						; Subtracts 1 from input (n-2)
STR R2, R6, #0						; Stores input to F(n-2) onto stack

ADD R6, R6, #-1						; Decrements stack pointer (R6 = x5009)						
JSR FIBONACCI						; Recursive Call

LDR R2, R5, #-1						; Loads return into R2
ADD R6, R6, #1						; Pops input for F(n-2) (R6 = x500A)

ADD R0, R1, R2						; Stores F(n-1)+F(n-2) into R0

END_ALL_CASES

STR R0, R5, #7						; Stores return value to stack
ADD R6, R5, #0						; Moves the Stack pointer to the end of frame (R6 = x500A)

;Restores registers;
;------------------;

ADD R6, R6, #1						; (R6 = x500B)

LDR R0, R6, #0						; Restores R0
ADD R6, R6, #1						; (R6 = x500C)

LDR R1, R6, #0						; Restores R1
ADD R6, R6, #1						; (R6 = x500D)

LDR R2, R6, #0						; Restores R2
ADD R6, R6, #1						; (R6 = x500E)

LDR R3, R6, #0						; Restores R3
ADD R6, R6, #1						; (R6 = x500F)

LDR R5, R6, #0						; Restores R5
ADD R6, R6, #1						; (R6 = x5010)

LDR R7, R6, #0						; Restores R7
ADD R6, R6, #1						; (R6 = x5011)
RET

.END