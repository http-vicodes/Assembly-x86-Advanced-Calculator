#variables initialisation
MOV AX, 0x0
MOV [num1], AX
MOV [operator], AX
MOV [num2], AX
MOV [result], AX
MOV [remainder], AX
MOV [input], AX

CALL CheckInputAX #here ISR isn't resetted so just checking
CMP AX, '-'
JEQ InputNegative
CALL readBX #if positive proceed as normal
continue:
MOV [num1], BX

CMP AX, '+'
JEQ operator_assignment
CMP AX, '-'
JEQ operator_assignment
CMP AX, 'x'
JEQ operator_assignment
CMP AX, '/'
JEQ operator_assignment
error_detected:
MOV BX, 'e'
SUB BX, 0x30
CALL OutputBX
CALL OutputStatus
MOV BX, 'r'
SUB BX, 0x30
CALL OutputBX
CALL OutputStatus
MOV BX, 'r'
SUB BX, 0x30
CALL OutputBX
CALL OutputStatus
MOV BX, 'o'
SUB BX, 0x30
CALL OutputBX
CALL OutputStatus
MOV BX, 'r'
SUB BX, 0x30
JMP AnyOutput

operator_assignment:
MOV [operator], AX


CALL CheckInputAX #here ISR isn't resetted so just checking
CMP AX, '-'
JEQ InputNegative2
CALL readBX #if positive proceed as normal
continue2:
MOV [num2], BX
CMP AX, 0x0A
JNE error_detected 



MOV BX, [operator]
CMP BX, '+'
JEQ addition
CMP BX, '-'
JEQ subtraction
CMP BX, 'x'
JEQ multiplication
CMP BX, '/'
JEQ division

printResult:
MOV BX, [result]
CMP BX, 0x0
JGE continue3
CALL OutputNegative
continue3:
CMP BX, 0xA
JGE OutputMoreBX
AnyOutput:
CALL OutputBX

HALT
ORG 0x0100
num1: DC.W 0x0
num2: DC.W 0x0
operator: DC.W 0x0
result: DC.W 0x0
remainder: DC.W 0x0
input: DC.W 0x0
division_result: DC.W 0x0

CheckInputAX:
MOV AX, [0xF5]
CMP AX, 0x0
JEQ CheckInputAX
MOV AX, [0xF3]
MOV BX, 0x1
MOV [0xF5], BX
RET

InputNegative:
MOV BX, 0x0
MOV [0xF5], BX #sign has been read but not stored
CALL readBX
NEG BX
JMP continue

InputNegative2:
MOV BX, 0x0
MOV [0xF5], BX #sign has been read but not stored
CALL readBX
NEG BX
JMP continue2


readBX:
MOV AX, 0x0
MOV [input], AX
CALL loopDigit
RET

InputAX:
MOV AX, [0xF5]
CMP AX, 0x0
JEQ InputAX
MOV AX, [0xF3]
MOV BX, 0x0
MOV [0xF5], BX
RET

loopDigit:
CALL InputAX
CMP AX, 0x30
JL endLoop
CMP AX, 0x40
JGE endLoop
SUB AX, 0x30 #from ASCII to number
CALL accumulate
JMP LoopDigit
endLoop:
MOV BX, [input]
RET

accumulate:
MOV BX, [input]
MUL BX, 0xA
ADD BX, AX
MOV [input], BX
RET

OutputNegative:
MOV BX, '-'
SUB BX, 0x30
Call OutputBX
MOV BX, [result]
NEG BX
MOV [result], BX
RET

OutputBX:
MOV AX, [0xF2]
CMP AX, 0x0
JNE OutputBX
ADD BX, 0x30
MOV [0xF0], BX
MOV AX, 0x1
MOV [0xF2], AX
RET

OutputStatus:
MOV AX, [0xF2]
CMP AX, 0x0
JNE OutputStatus
RET

addition:
MOV AX, [num1]
MOV BX, [num2]
ADD BX, AX
MOV [result], BX
JMP printResult
 
subtraction:
MOV AX, [num2]
MOV BX, [num1]
SUB BX, AX
SUB BX, AX
MOV [result], BX
JMP printResult

multiplication:
MOV AX, [num1]
MOV BX, [num2]
MUL BX, AX
MOV [result], BX
JMP printResult

division:
MOV BX, [num1]
MOV AX, [num2]
DIV BX, AX
MOV [result], BX
JMP printResult

OutputMoreBX:
MOV BX, [result]
CMP BX, 0d100
JL OutputDoubleBX
MOV AX, 0d1000
CMP BX, AX
JL OutputTripleBX
MOV AX, 0d10000
CMP BX, AX
JL OutputQuadrupleBX 
JMP OutputQuintupleBX #else

OutputDoubleBX:
MOV BX, [result]
DIV BX, 0d10
CALL OutputBX
MOV BX, [result]
MOD BX, 0d10
JMP AnyOutput

OutputTripleBX:
MOV BX, [result]
DIV BX, 0d100
CALL OutputBX
MOV BX, [result]
MOD BX, 0d100
MOV [remainder], BX
DIV BX, 0d10
CALL OutputBX
MOV BX, [remainder]
MOD BX, 0d10
JMP AnyOutput

OutputQuadrupleBX:
MOV BX, [result]
DIV BX, 0d10		#div by 1000
DIV BX, 0d100
MOV [division_result], BX
CALL OutputBX
MOV AX, [division_result]
MOV BX, 0d1000
MUL AX, BX    #manual mod pt1: div_result x divisor
MOV BX, [result]
SUB BX, AX  #manual mod pt2: dividend - (div_result x divisor)
MOV [remainder], BX
DIV BX, 0d100
CALL OutputBX
MOV BX, [result]
MOD BX, 0d100
MOV [remainder], BX
DIV BX, 0d10
CALL OutputBX
MOV BX, [remainder]
MOD BX, 0d10
JMP AnyOutput

OutputQuintupleBX:
MOV BX, [result]
DIV BX, 0d100
DIV BX, 0d100
MOV [division_result], BX
CALL OutputBX
MOV AX, [division_result]
MOV BX, 0d10000
MUL AX, BX
MOV BX, [result]
SUB BX, AX 
MOV [remainder], BX
DIV BX, 0d10
DIV BX, 0d100
MOV [division_result], BX
CALL OutputBX
MOV AX, [division_result]
MOV BX, 0d1000
MUL AX, BX
MOV BX, [remainder]
SUB BX, AX 
MOV [remainder], BX
DIV BX, 0d100
CALL OutputBX
MOV BX, [remainder]
MOD BX, 0d100
MOV [remainder], BX
DIV BX, 0d10
CALL OutputBX
MOV BX, [remainder]
MOD BX, 0d10
JMP AnyOutput


