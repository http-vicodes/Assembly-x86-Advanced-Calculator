# x86 Assembly Advanced Calculator

## Overview
This project is a basic calculator implemented in x86 Assembly (Intel syntax). It performs addition, subtraction, multiplication, and division using user input. The program correctly handles negative numbers and provides error handling for invalid operators.

## Features
- Supports **addition (`+`), subtraction (`-`), multiplication (`x`), and division (`/`)**.
- Accepts **negative numbers** as input.
- Displays an **error message** if an invalid operator is entered.
- Outputs multi-digit results correctly.
- Utilizes **interrupt service routines (ISR)** to read user input.
- Handles **division remainder calculation**.

## Memory Layout
The program defines variables in memory to store inputs, results, and intermediate values:

| Variable       | Purpose                           |
|---------------|-----------------------------------|
| `num1`        | Stores the first number          |
| `num2`        | Stores the second number         |
| `operator`    | Stores the selected operation    |
| `result`      | Stores the final computation result |
| `remainder`   | Stores the remainder from division |
| `input`       | Temporarily holds user input     |

## How It Works
1. **Initialize Variables**  
   The program initializes all variables to `0x0` before processing user input.

2. **Read First Input (`num1`)**  
   - Calls `CheckInputAX` to fetch the user input.
   - If negative, calls `InputNegative` to store `num1` as a negative value.
   - Otherwise, reads the number normally.

3. **Read Operator (`operator`)**  
   - Compares input against valid operators (`+`, `-`, `x`, `/`).
   - If an invalid operator is entered, prints `error`.

4. **Read Second Input (`num2`)**  
   - Calls `CheckInputAX` again.
   - If negative, calls `InputNegative2` to handle it.
   - Otherwise, reads the number normally.

5. **Perform Calculation**  
   - Compares the stored operator and jumps to the corresponding function:
     - `addition`
     - `subtraction`
     - `multiplication`
     - `division`

6. **Print Result**  
   - Checks if the result is negative (`OutputNegative`).
   - Uses `OutputBX` or `OutputMoreBX` to print multi-digit numbers.

## Functions and Subroutines
### `CheckInputAX`
- Waits for user input by checking the ISR (`0xF5`).
- Stores the input value in `AX`.

### `InputNegative`
- Reads a negative number.
- Calls `readBX` and negates the value.

### `readBX`
- Reads multi-digit numbers into `BX`.
- Calls `loopDigit` for each digit.

### `loopDigit`
- Converts ASCII input to a numerical value.
- Calls `accumulate` to build multi-digit numbers.

### `accumulate`
- Multiplies the current number by 10 and adds the new digit.

### `OutputNegative`
- Prints a minus sign (`-`) before outputting the absolute value.

### `OutputBX`
- Sends a single character to output.

### `addition`, `subtraction`, `multiplication`, `division`
- Perform arithmetic operations and store the result in `result`.

### `OutputMoreBX`
- Handles multi-digit number output using `OutputDoubleBX`, `OutputTripleBX`, etc.

## Error Handling
- If an invalid operator is detected, prints `"error"` and halts execution.

## Future Improvements
- Support for floating-point calculations.
- Improved error handling for non-numeric inputs.
- Enhanced input/output formatting.

## Running the Program
To run the calculator, assemble it using an x86 assembler like `NASM` and execute it in an emulator like **DOSBox** or **EMU8086**.

```sh
nasm -f bin calculator.asm -o calculator.com
dosbox calculator.com

