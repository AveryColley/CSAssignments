.ORIG x3000

LD R2, ECHO		; Sets R2 to be where our echoed string starts
LEA R0, PROMPT
PUTS			; Prints out the prompt

GETS GETC
OUT
ADD R1, R0, #-10	; Checks to see if the entered character is a new line
BRz DONE		; If it's a new line character we don't store it and instead print out the string
STR R0, R2, #0		; Stores the String starting at x3100
ADD R2, R2, #1		; Increments R2 to store the character in the next slot
BRnzp GETS 
DONE AND R3, R3, #0	; Clears out R3
STR R3, R2, #0		; Adds a Null character to after the string
LD R0, ECHO		; Loads the start of the string into R0
PUTS			; Prints out the string
HALT

PROMPT .STRINGZ "Enter string to echo: "
ECHO   .FILL    x3100				; Start of echoed string
.END