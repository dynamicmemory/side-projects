import sys 
import re 

def transpile_crust_to_c(source_code: str) -> str:
    lines = source_code.splitlines()
    c_lines = ['#include <stdio.h>', '', '']

    for line in lines:
        line = line.strip()

        if line.startswith("stuff"):
            #Function definition
            m = re.match(r'stuff int (\w+)\((.*?)\) -> int {', line)
            if m:
                func_name = m.group(1)
                args = m.group(2)
                c_lines.append(f"int {func_name}({args}) {{")
                continue

        if line.startswith("crust main()"):
            c_lines.append("int main() {")
            continue 

        if "letm int" in line:
            # Variable declaration
            line = line.replace("letm int", "int")
            c_lines.append(line)
            continue 

        if "let int" in line:
            # Variable declaration
            line = line.replace("let int", "const int")
            c_lines.append(line)
            continue 

        if line.startswith("show("):
            expr = line[len("show("):-1]
            c_lines.append(f'printf("%d\\n", {expr};')
            continue

        if line.startswith("fin "):
            c_lines.append("return " + line[4:])

        if line.strip() == "fin":
            c_lines.append("return 0;")
            continue 

        if line.strip() == "}":
            c_lines.append("}")
            continue

    return "\n".join(c_lines)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python crustc.py test.crust")
        sys.exit(1)

    crust_file = sys.argv[1]
    with open(crust_file, 'r') as f:
        source = f.read()

    c_output = transpile_crust_to_c(source)

    with open("out.c", "w") as f:
        f.write(c_output)

    print("Generated out.c")
