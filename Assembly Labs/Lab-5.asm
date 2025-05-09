.ORIG x3000
;	Your main() function starts here
LD R6, STACK_PTR			;	LOAD the pointer to the bottom of the stack in R6	(R6 = x5013)
ADD R6, R6, #-1				;	Allocate room for your return value 			(R6 = x5012)
ADD R5, R6, #0				;	MAKE your frame pointer R5 point to local variables	(R5 = x5012)
LEA R4, GLOBAL_VARS			;	MAKE your global var pointer R4 point to globals	(R4 = ADDRESS(GLOBAL_VARS))

LEA R0, ARRAY_POINTER			;	LOAD the address of your array pointer
STR R0, R5, #0				;	STORE pointer to array in stack				(R5 = x5012)
ADD R6, R6, #-2				;	MAKE stack pointer go back two addresses		(R6 = x5010)

STR R0, R6, #0				;	STORE pointer to array (input to sumOfSquares)		(R6 = x5010)
ADD R6, R6, #-1				;	MAKE stack pointer go back one address			(R6 = x500F)

LDR R0, R4, #0				;	LOAD MAX_ARRAY_SIZE value into R0
STR R0, R6, #0				;	STORE MAX_ARRAY_SIZE value into stack			(R6 = x500F)

ADD R6, R6, #-1				;	MAKE stack pointer go back one address			(R6 = x500E)
JSR sumOfSquares			;	CALL sumOfSquares() function
LDR R0, R5, #-4				;	LOAD return value of sumOfSquares() into R0		(R5 = x5012)

ADD R6, R6, #1				;	POP input to sumOfSquares off the stack			(R6 = x5010)

STR R0, R5, #-1				;	STORE int total into stack				(R5 = x5012)
STR R0, R5, #1				;	STORE main() return value into stack			(R5 = x5012)

ADD R6, R6, #4				;	POP stack						(R6 = x5014)
HALT

GLOBAL_VARS				;	Your global variables start here
MAX_ARRAY_SIZE	.FILL x0005		;	MAX_ARRAY_SIZE is a global variable and predefined
ARRAY_POINTER	.FILL x0002		;	ARRAY_POINTER points to the top of your array (5 elements)
		.FILL x0003
		.FILL x0005
		.FILL x0000
		.FILL x0001
STACK_PTR	.FILL x5013		;	STACK_PTR is a pointer to the bottom of the stack	(x5013)

sumOfSquares
;	Your sumOfSquares() function starts here

ADD R6, R6, #-1				; 	Reserves room for return value of sumOfSquares		(R6 = x500D)

STR R7, R6, #0				; 	Stores return address
ADD R6, R6, #-1				;	MAKE stack pointer go back one address			(R6 = x500C)

STR R5, R6, #0				; 	Stores previous R5
ADD R6, R6, #-1				; 	MAKE stack pointer go back one address			(R6 = x500B)

STR R3, R6, #0				; 	Stores previous R3
ADD R6, R6, #-1				; 	MAKE stack pointer go back one address			(R6 = x500A)

STR R2, R6, #0				; 	Stores previous R2
ADD R6, R6, #-1				; 	MAKE stack pointer go back one address			(R6 = x5009)

STR R1, R6, #0				; 	Stores previous R1
ADD R6, R6, #-1				; 	MAKE stack pointer go back one address			(R6 = x5008)

STR R0, R6, #0				; 	Stores previous R0
ADD R6, R6, #-1				; 	MAKE stack pointer go back one address			(R6 = x5007)

ADD R5, R6, #0				;	Moves R5 to point to local variables			(R5 = x5007)
ADD R6, R6, #-2				; 	Moves the stack pointer up two spaces to reserve room	(R6 = x5005)

LDR R2, R5, #8				; 	Loads array size into R2
AND R3, R3, #0				;	Clears out R3

STR R3, R5, #0				;	Stores counter into stack (Counter = 0)
STR R3, R5, #-1				; 	Stores sum into stack (Sum = 0)

NOT R2, R2
ADD R2, R2, #1				;	2's complement Arraysize for branch checking

WHILE_LOOP				;	Start of while loop

ADD R1, R3, R2				; 	Counter + arraysize. If zp we're done
BRzp DONE
LDR R0, R5, #9				; 	Loads array pointer (address of the array) into R0
ADD R0, R3, R0				;	Counter + array adress gives us address of value at index counter
LDR R0, R0, #0				;	Loads value at index counter to R0
STR R0, R5, #-2				;	Stores value at index counter into stack at x5005
ADD R6, R6, #-1				;	Moves the stack pointer up one				(R6 = x5004)

JSR square				;	Squares the value in x5005 and places it at x5004

LDR R0, R5, #-3				;	Loads into R0 the return value of square
LDR R1, R5, #-1				;	Loads current running sum into R1
ADD R0, R0, R1				;	Adds the newest square to the old sum
STR R0, R5, #-1				;	Replaces old sum with new one in stack

ADD R3, R3, #1				;	Incrememts counter by 1
STR R3, R5, #0				;	Stores new counter into stack
BRnzp WHILE_LOOP

DONE					;	Restores the stack to before sumOfSquares but adds the sum into the appropriate spot on the stack

LDR R0, R5, #-1				;	Loads the sum into R0
STR R0, R5, #7				;	Stores the sum into the return value section of the stack

ADD R6, R6, #2				;	Moves stack pointer to end of frame			(R6 = x5007)
ADD R6, R6, #1				;	Moves stack pointer forward 1				(R6 = x5008)

LDR R0, R6, #0				;	Restores the value of R0
ADD R6, R6, #1				;	Moves the stack pointer up by one			(R6 = x5009)

LDR R1, R6, #0				;	Restores the value of R1
ADD R6, R6, #1				;	Moves the stack pointer up by one			(R6 = x500A)

LDR R2, R6, #0				;	Restores the value of R2
ADD R6, R6, #1				;	Moves the stack pointer up by one			(R6 = x500B)

LDR R3, R6, #0				;	Restores the value of R3
ADD R6, R6, #1				;	Moves the stack pointer up by one			(R6 = x500C)

LDR R5, R6, #0				;	Restores the value of R5				(R5 = x5012)
ADD R6, R6, #1				;	Moves the stack pointer up by one			(R6 = x500D)

LDR R7, R6, #0				;	Restores the value of R7
ADD R6, R6, #1				;	Moves the stack pointer up by one			(R6 = x500E)

ADD R6, R6, #1				;	Pops the stack						(R6 = x500F)
RET

square
;	Your square() function starts here

ADD R6, R6, #-1				;	Allocates room for return value 			(R6 = x5003)

STR R7, R6, #0				;	Stores return address in stack
ADD R6, R6, #-1				; 	Moves the stack pointer back by one			(R6 = x5002)

STR R5, R6, #0				;	Stores R5 in stack
ADD R6, R6, #-1				; 	Moves the stack pointer back by one			(R6 = x5001)

STR R3, R6, #0				;	Stores R3 in stack
ADD R6, R6, #-1				; 	Moves the stack pointer back by one			(R6 = x5000)

STR R2, R6, #0				;	Stores R2 in stack
ADD R6, R6, #-1				; 	Moves the stack pointer back by one			(R6 = x4FFF)

STR R1, R6, #0				;	Stores R1 in stack
ADD R6, R6, #-1				; 	Moves the stack pointer back by one			(R6 = x4FFE)

STR R0, R6, #0				;	Stores R0 in stack
ADD R6, R6, #-1				; 	Moves the stack pointer back by one			(R6 = x4FFD)

ADD R5, R5, #-10			;	Moves R5 to top of frame				(R5 = x4FFD)

AND R0, R0, #0				;	Clears out R0
STR R0, R5, #0				; 	Stores product into stack (product = 0)

LDR R1, R5, #8				; 	Loads the number to be squared into R1
ADD R2, R1, #0				;	Copies number into R2

MULTIPLY_LOOP				; 	Loop for multiplication

ADD R0, R1, R0				;	Keeps track of product
ADD R2, R2, #-1				;	Keeps track of loop
BRp MULTIPLY_LOOP

STR R0, R5, #0				;	Stores product into stack
STR R0, R5, #7				;	Stores product as return value in stack

; Restores stack to before square was executed

ADD R6, R6, #1				;	Moves stack pointer forward by one			(R6 = x4FFE)
LDR R0, R6, #0				;	Restores R0
ADD R6, R6, #1				;	Moves stack pointer forward by one			(R6 = x4FFF)

LDR R1, R6, #0				;	Restores R1
ADD R6, R6, #1				;	Moves stack pointer forward by one			(R6 = x5000)

LDR R2, R6, #0				;	Restores R2
ADD R6, R6, #1				;	Moves stack pointer forward by one			(R6 = x5001)

LDR R3, R6, #0				;	Restores R3
ADD R6, R6, #1				;	Moves stack pointer forward by one			(R6 = x5002)

LDR R5, R6, #0				;	Restores R5
ADD R6, R6, #1				;	Moves stack pointer forward by one			(R6 = x5003)

LDR R7, R6, #0				;	Restores R7
ADD R6, R6, #1				;	Moves stack pointer forward by one			(R6 = x5004)

ADD R6, R6, #1				;	Pops the stack						(R6 = x5005)
RET

.END