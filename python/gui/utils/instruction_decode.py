import binary_to_dec


# Getting the registers and inmediate values
def rs_base(values):
    return "$" + binary_to_dec.strbin_to_udec(values[:5])


def rt(values):
    return "$" + binary_to_dec.strbin_to_udec(values[5:10])


def rd(values):
    return "$" + binary_to_dec.strbin_to_udec(values[10:15])


def shamt(values):
    return binary_to_dec.strbin_to_dec(values[15:])


def immediate_offset(values):
    return binary_to_dec.strbin_to_dec(values[10:])


# Joining the registers and inmediate values
def rd_rs_shamt(values):
    return rd(values) + ", " + rs_base(values) + ", " + shamt(values)


def rd_rt_rs(values):
    return rd(values) + ", " + rt(values) + ", " + rs_base(values)


def rd_rs_rt(values):
    return rd(values) + ", " + rs_base(values) + ", " + rt(values)


def rs_rt_offset(values):
    return rs_base(values) + ", " + rt(values) + ", " + immediate_offset(values)


def rt_rs_immediate(values):
    return rt(values) + ", " + rs_base(values) + ", " + immediate_offset(values)


def rt_immediate(values):
    return rt(values) + ", " + immediate_offset(values)


def rt_offset_base(values):
    return rt(values) + ", " + immediate_offset(values) + "(" + rs_base(values) + ")"


# Making instructions with funct field
def funct_000000(values):
    return "SLL " + rd_rs_shamt(values) + ";"


def funct_000010(values):
    return "SRL " + rd_rs_shamt(values) + ";"


def funct_000011(values):
    return "SRA " + rd_rs_shamt(values) + ";"


def funct_000100(values):
    return "SLLV " + rd_rt_rs(values) + ";"


def funct_000110(values):
    return "SRLV " + rd_rt_rs(values) + ";"


def funct_000111(values):
    return "SRAV " + rd_rt_rs(values) + ";"


def funct_001000(values):
    return "JR $" + binary_to_dec.strbin_to_udec(values[:5]) + ";"


def funct_001001(values):
    return "JALR $" + binary_to_dec.strbin_to_udec(values[10:15]) + ", $" + binary_to_dec.strbin_to_udec(
        values[:5]) + ";"


def funct_100000(values):
    return "ADD " + rd_rs_rt(values) + ";"


def funct_100010(values):
    return "SUB " + rd_rs_rt(values) + ";"


def funct_100100(values):
    return "AND " + rd_rs_rt(values) + ";"


def funct_100101(values):
    return "OR " + rd_rs_rt(values) + ";"


def funct_100110(values):
    return "XOR " + rd_rs_rt(values) + ";"


def funct_100111(values):
    return "NOR " + rd_rs_rt(values) + ";"


def funct_101010(values):
    return "SLT " + rd_rs_rt(values) + ";"


def opcode_000000(fields):
    values = fields[:20]
    funct = fields[20:]
    function = globals().get('funct_' + funct)
    return function(values)


def opcode_000100(fields):
    return "BEQ " + rs_rt_offset(fields) + ";"


def opcode_000101(fields):
    return "BNE " + rs_rt_offset(fields) + ";"


def opcode_001000(fields):
    return "ADDI " + rt_rs_immediate(fields) + ";"


def opcode_001010(fields):
    return "SLTI " + rt_rs_immediate(fields) + ";"


def opcode_001100(fields):
    return "ANDI " + rt_rs_immediate(fields) + ";"


def opcode_001101(fields):
    return "ORI " + rt_rs_immediate(fields) + ";"


def opcode_001110(fields):
    return "XORI " + rt_rs_immediate(fields) + ";"


def opcode_001111(fields):
    return "LUI " + rt_immediate(fields) + ";"


def opcode_100000(fields):
    return "LB " + rt_offset_base(fields) + ";"


def opcode_100001(fields):
    return "LH " + rt_offset_base(fields) + ";"


def opcode_100011(fields):
    return "LW " + rt_offset_base(fields) + ";"


def opcode_100100(fields):
    return "LBU " + rt_offset_base(fields) + ";"


def opcode_100101(fields):
    return "LHU " + rt_offset_base(fields) + ";"


def opcode_100111(fields):
    return "LWU " + rt_offset_base(fields) + ";"


def opcode_101000(fields):
    return "SB " + rt_offset_base(fields) + ";"


def opcode_101001(fields):
    return "SH " + rt_offset_base(fields) + ";"


def opcode_101011(fields):
    return "SW " + rt_offset_base(fields) + ";"


def opcode_000010(fields):
    return "J " + binary_to_dec.strbin_to_udec(fields) + ";"


def opcode_000011(fields):
    return "JAL " + binary_to_dec.strbin_to_udec(fields) + ";"


def get_instruction(binary_instruction):
    opcode = binary_instruction[:6]
    fields = binary_instruction[6:]
    function = globals().get('opcode_' + opcode)
    return function(fields)
