# Converts MIPS instructions into binary and hex
import os
import sys
from instructiondecode import instr_decode # converts the instruction part of a line of MIPS code
from registerdecode import reg_decode # converts the register and immediate parts of the MIPS code



# the main conversion function
def convert(code):
    code = code.replace("(", " ")
    code = code.replace(")", "")
    code = code.replace(",", " ")
    code = code.replace("  ", " ")
    args = code.split(" ")
    instruction = args[0]

    if instruction == "exit":
        sys.exit()

    codes = instr_decode(instruction)
    func_type = codes[0]
    reg_values = reg_decode(func_type, instruction, args[1:]) #get the numeric values of the registers

    #the following if statement below prints an error if needed
    if reg_values == None:
        print("Instruccion no valida por None")
        return

    #execution for r-type functions
    if func_type == "r": #("Instruction form: opcode|  rs |  rt |  rd |shamt| funct")
        opcode = '{0:06b}'.format(codes[1])
        rs = '{0:05b}'.format(reg_values[0])
        rt = '{0:05b}'.format(reg_values[1])
        rd = '{0:05b}'.format(reg_values[2])
        shamt = '{0:05b}'.format(reg_values[3])
        funct = '{0:06b}'.format(codes[2])
        #print("Formatted binary: "+opcode+"|"+rs+"|"+rt+"|"+rd+"|"+shamt+"|"+funct)
        binary = opcode+rs+rt+rd+shamt+funct
        print(binary)

    #execution for i-type functions
    elif func_type == "i": #("Instruction form: opcode|  rs |  rt |   immediate      ")
        opcode = '{0:06b}'.format(codes[1])
        rs = '{0:05b}'.format(reg_values[0])
        rt = '{0:05b}'.format(reg_values[1])
        imm = '{0:016b}'.format(reg_values[2])
        #print("Formatted binary: " + opcode+"|"+rs+"|"+rt+"|"+imm)
        binary = opcode+rs+rt+imm
        print(binary)

    #execution for j-type functions
    elif func_type == "j": #("Instruction form: opcode|          immediate           ")
        opcode = '{0:06b}'.format(codes[1])
        imm = '{0:026b}'.format(reg_values[0])
        #print("Formatted binary: " + opcode+"|"+imm)
        binary = opcode+imm
        print(binary)

    elif func_type == "nop":
        print("00000000000000000000000000000000")

    else:
        print("Instruccion no valida")
        return

    return

# main
#os.system("clear")

i = 1
for linea in open("instAsm.asm", "r"):
    #print(str(i)+" ")
    linea = linea[:-1]
    #print (linea)
    convert(linea)
    i += 1
    #print("--------------------------------------------------------------------------------")
