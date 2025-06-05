import sys 
import re 

def transpile_cap_to_c(source_code: str) -> str:
    lines = source_code.splitlines()
    c_lines = ['#include <stdio.h>', '']

    for line in lines:
        line = line.strip()

        # Main entry point of program 
        if line.startswith("main"):
            c_lines.append("int main() {")
            continue 

        # Translating an int 
        if line.startswith("int"):
            c_lines.append(line)
            continue 

        # Translating a char 
        if line.startswith("char"):
            c_lines.append(line)
            continue 

        # translating a print statement 
        if line.startswith("stdout("):
            expr = line [len("stdout("):-1]
            c_lines.append(f'printf("%d\\n", {expr};')
            continue 

        # translating a main return 
        if line.startswith("ret "):
            c_lines.append("return " + line[4:])

        if line.strip() == "}":
            c_lines.append("}")
            continue

    return "\n".join(c_lines)


if __name__ == "__main__":
    # Let em know they forgot the file in the command 
    if len(sys.argv) != 2:
        print("Usage: python capcompiler.py test3.cap")
        sys.exit(1)

    # Open the cap file 
    cap_file = sys.argv[1]
    with open(cap_file, 'r') as f:
        source = f.read()

    # Translate the file to c 
    c_output = transpile_cap_to_c(source)

    # Create the C file 
    with open("capout.c", 'w') as f:
        f.write(c_output)

    print("Generated capout.c successfully")


