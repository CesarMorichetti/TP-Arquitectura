# dictionary used to contain register numeric values
registers = {
    "r0" : 0,
    "r1" : 1,
    "r2" : 2,
    "r3" : 3,
    "r4" : 4,
    "r5" : 5,
    "r6" : 6,
    "r7" : 7,
    "r8" : 8,
    "r9" : 9,
    "r10" : 10,
    "r11" : 11,
    "r12" : 12,
    "r13" : 13,
    "r14" : 14,
    "r15" : 15,
    "r16" : 16,
    "r17" : 17,
    "r18" : 18,
    "r19" : 19,
    "r20" : 20,
    "r21" : 21,
    "r22" : 22,
    "r23" : 23,
    "r24" : 24,
    "r25" : 25,
    "r26" : 26,
    "r27" : 27,
    "r28" : 28,
    "r29" : 29,
    "r30" : 30,
    "r31" : 31
}


# Given the function type, reg_decode will output an array containing the
# numeric values of the registers and immediates in MIPS code.
# param 'func_type' is the function type of the MIPS code
# param 'instr' is the instruction given in the MIPS code
# param 'regs' is an array containing the registers used in the MIPS code
# returns an array in the form [rs, rt, rd, shamt] for r-type functions
# returns an array in the form [rs, rt, immediate] for i-type functions
def reg_decode(func_type, instr, regs):

    #execution for r-type functions
    if func_type == "r":

        #special case for MIPS shifts
        if (instr == "sll") or (instr == "srl") or (instr == "sra"):
            try:
               #return[rs,        rt,               rd,             shamt]
               return [0, registers[regs[1]], registers[regs[0]], int(regs[2])]
            except:
                return None

        #special case for MIPS jr
        if (instr == "jr"):
            try:
                #return[        rs,        rt, rd,shamt]
                return [registers[regs[0]], 0, 0, 0]
            except:
                return None

        #special case for MIPS jalr
        if (instr == "jalr"):
            try:
                #return[         rs       ,rt,         rd        ,shamt]
                return [registers[regs[0]], 0, registers[regs[1]], 0]
            except:
                return None

        #standard r-type MIPS instructions
        try:
            #return[      rs,                 rt,               rd,          shamt]
            return[registers[regs[1]], registers[regs[2]], registers[regs[0]], 0]
        except:
            return None


    #execution for i-type functions
    elif func_type == "i":

        #special case for lui
        if (instr == "lui"):
            try:
                if len(regs[1]) > 1 and regs[1][1] == "x":
                    imm = int(regs[1], base=16)
                else:
                    imm = int(regs[1])

                #return[rs,       rt        ,  immediate  ]
                return[0, registers[regs[0]], imm]
            except:
                return None


        #special case for lw, sb, sw, ll sc
        if (instr == "lw") or (instr == "sb") or (instr == "sw") or (instr == "ll") or (instr == "sc"):
            try:
                if len(regs[1]) > 1 and regs[1][1] == "x":

                    imm = int(regs[1], base=16)
                else:

                    imm = int(regs[1])

                #return[       rs,                rt        ,  immediate  ]
                return[registers[regs[2]], registers[regs[0]], imm]
            except:
                return None

        if (instr == "lb") or (instr == "lbu"):
            try:
                if len(regs[1]) > 1 and regs[1][1] == "x" :
                    imm = int(regs[1], base=16)

                else:
                    imm = int(regs[1])

                #return[        rs                 rt             immediate ]
                return [registers[regs[2]], registers[regs[0]], imm]
            except:
                return None

        #standard i-type MIPS instructions
        try:
            if len(regs[2]) > 1 and regs[2][1] == "x" :
                imm = int(regs[2], base=16)

            else:
                imm = int(regs[2])

            #return[        rs                 rt             immediate ]
            return [registers[regs[1]], registers[regs[0]], imm]
        except:
            return None


    #execution for j-type functions
    elif func_type == "j":
        try:
            if len(regs[0]) > 1 and regs[0][1] == "x":
                imm = int(regs[0], base=16)
            else:
                imm = int(regs[0])

            #return [ immediate ]
            return [imm]
        except:
            return None

    elif func_type == "nop":
        return "nop"

    elif func_type == "halt":
        return "halt"

    else:
        return None
