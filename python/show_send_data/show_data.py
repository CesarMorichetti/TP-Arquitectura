"""Script para mostrar lo recibido desde FPGA"""

"""
Genera un vector de todos los bits recibidos (len = 2592)
el primer byte es el ultimo en del vector bus_from_mips.
"""
def merge_list(data):
    turn_around = []
    for i in data:
        turn_around.insert(0,i)
    print turn_around
    return "".join(turn_around)

"""
Recibe el vector completo y lo particiona en los diferentes
registros, banco de registros, memoria y contador de clk.
"""
def split_data(data, print_flag):
    latch_MEM_WB = data[2487:]
    data_memory  = data[1463:2487]
    latch_EX_MEM = data[1320:1463]
    latch_ID_EX  = data[1123:1320]
    registers    = data[99:1123]
    latch_IF_ID  = data[34:99]
    clk_count    = data[2:34]
    offset       = data[:2]

    if print_flag:
        print "Latch_MEM_WB:", latch_MEM_WB
        print len(latch_MEM_WB)
        print "---------------------------------------"
        print "MEM:", data_memory
        print len(data_memory)
        print "---------------------------------------"
        print "Latch_EX_MEM:", latch_EX_MEM
        print len(latch_EX_MEM)
        print "---------------------------------------"
        print "Latch_ID_EX:", latch_ID_EX
        print len(latch_ID_EX)
        print "---------------------------------------"
        print "REG:", registers
        print len(registers)
        print "---------------------------------------"
        print "Latch_IF_ID:", latch_IF_ID
        print len(latch_IF_ID)
        print "---------------------------------------"
        print "clk_count:", clk_count
        print len(clk_count)
        print "---------------------------------------"
        print "offset:", offset
        print len(offset)

    return latch_MEM_WB, data_memory, latch_EX_MEM, \
           latch_ID_EX, registers, latch_IF_ID, clk_count

"""
Recibe el vector del Latch MEM_WB y lo divide en cada 
senal y registros.
"""
def mem_wb(data):
    output_mem = data[0:32]
    alu_res = data[32:64]
    addr_reg_dst = data[64:68]
    pc_to_reg = data[68:100]
    write_pc = data[101]
    regwrite = data[102]
    memtoreg = data[103]
    stop_pipe = data[104]
    
    return output_mem, alu_res, addr_reg_dst, pc_to_reg, write_pc, regwrite,\
            memtoreg, stop_pipe

"""
Recibe el vector de la memoria, lo separa cada 32 e imprime
el contenido.
"""
def data_memory(data):
    memory = []
    for i in range(32):
        memory.append(data[i * 32:(i * 32) + 32])
    # print registers
    for idx, val in enumerate(memory):
        print "Memoria", idx, ":", int(val, 2), "{0:#0{1}x}".format(int(val, 2), (32 / 4) + 2), "{0:#0{1}b}".format(
            int(val, 2), 34)

"""
Recibe el vector del Latch EX_MEM, lo divide en cada senal
y registros.
"""
def ex_mem(data):
    jump            = data[0:32]    
    pc_to_reg       = data[32:64]    
    alu_res         = data[64:96]
    rt_reg          = data[96:128]
    addr_reg_dst    = data[128:133]    
    write_pc        = data[134]
    take            = data[135]
    regWrite        = data[136]
    memtoreg        = data[137]
    memwrite        = data[138]
    memread         = data[139]
    load_store_type = data[139:142]
    stop_pipe       = data[142]

    return jump, pc_to_reg, alu_res, rt_reg, addr_reg_dst, \
           write_pc, take, regWrite, memtoreg, memwrite, memread, \
           load_store_type, stop_pipe       

"""
Recibe el vector del Latch ID_EX, lo divide en cada senal
y registros.
"""
def id_ex(data):
    o_rt_addr          = data[0:5]
    o_rd_addr          = data[5:10]
    o_rs_addr          = data[10:15]
    o_sig_extended     = data[15:47]
    o_rs_reg           = data[47:79]
    o_rt_reg           = data[79:111]
    o_pc               = data[111:143]
    o_jump_address     = data[143:175]
    o_op               = data[175:181]
    os_RegDst          = data[182]
    os_MemRead         = data[183]
    os_MemWrite        = data[184]
    os_MemtoReg        = data[185]
    os_ALUop           = data[185:189]
    os_ALUsrc          = data[190]
    os_RegWrite        = data[191]
    os_shmat           = data[192]
    os_load_store_type = data[192:195]
    os_stall           = data[196]
    os_stop_pipe       = data[197]
    len(o_rt_addr)          
    len(o_rd_addr)          
    len(o_rs_addr)          
    len(o_sig_extended)     
    len(o_rs_reg)           
    len(o_rt_reg)           
    len(o_pc)               
    len(o_jump_address)     
    len(o_op)               
    len(os_RegDst)          
    len(os_MemRead)         
    len(os_MemWrite)        
    len(os_MemtoReg)        
    len(os_ALUop)           
    len(os_ALUsrc)          
    len(os_RegWrite)        
    len(os_shmat)           
    len(os_load_store_type) 
    len(os_stall)           
    len(os_stop_pipe)       
    return o_rt_addr, o_rd_addr, o_rs_addr, o_sig_extended, o_rs_reg,\
           o_rt_reg, o_pc, o_jump_address, o_op, os_RegDst, os_MemRead,\
           os_MemWrite, os_MemtoReg, os_ALUop, os_ALUsrc, os_RegWrite,\
           os_shmat, os_load_store_type, os_stall, os_stop_pipe      
"""
Recibe el vector de la memoria, lo separa cada 32 e imprime
el contenido.
"""
def registers(data):
    registers = []
    for i in range(32):
        registers.append(data[i*32:(i*32)+32])
    #print registers
    for idx,val in enumerate(registers):
        print "Registro", idx, ":" ,int(val,2),"{0:#0{1}x}".format(int(val,2),(32/4)+2), "{0:#0{1}b}".format(int(val,2),34)

"""
Recibe el vector del Latch IF_ID, lo divide en cada senal
y registros.
"""
def if_id(data):
    pc          = data[0:32]
    instruction = data[32:64]
    stop_pipe   = data[64]
    return pc, instruction, stop_pipe

"""
En funcion de los flags genera la informacion para imprimir.
"""
def print_func(data, bits, decimal=True, hexa=True, binary=True):
    print_line = []
    if decimal:
        print_line.append(int(data,2))
    if hexa:
        print_line.append("{0:#0{1}x}".format(int(data,2),(bits/4)+2))
    if binary:
        print_line.append("{0:#0{1}b}".format(int(data,2),bits+2))
    return print_line

"""
Lee archivo con informacion del debuger.
"""
def simula_recepcion_datos():
    f = open("filename.txt","r")
    cont = f.read()
    cont = cont.replace("\n","")
    read = [cont[i:i+8] for i in range(0, 2592, 8)]
    print read
    return read

if __name__ == "__main__":

    data_from_fpga = simula_recepcion_datos()
    data_from_fpga = merge_list(data_from_fpga)
    #print len(data_from_fpga)

    reg_mem_wb, reg_data_mem, reg_ex_mem, reg_id_ex, reg_reg,\
    reg_if_id, reg_clk_count = split_data(data_from_fpga, 0)

    print "****************************************************************"
    if_id_pc, if_id_instruction, if_id_stop_pipe = if_id(reg_if_id)
    print "Latch if_id PC:               ", print_func(if_id_pc,32,True,True,True)
    print "Latch if_id Instruction:      ", print_func(if_id_instruction,32,True,True,True)
    print "Latch if_id stop pipe signal: ", print_func(if_id_stop_pipe,1,True,True,True)
    print "****************************************************************"
    registers(reg_reg)
    print "****************************************************************"
    mem_wb_output_mem, mem_wb_alu_res, mem_wb_addr_reg, mem_wb_pc, \
    mem_wb_write_pc, mem_wb_regwrite, mem_wb_memtoreg, mem_wb_stop_pipe\
        = mem_wb(reg_mem_wb)
    print "Latch mem_wb output_mem:", print_func(mem_wb_output_mem, 32, True ,True ,True)
    print "Latch mem_wb alu_res:   ", print_func(mem_wb_alu_res, 32, True ,True ,True)
    print "Latch mem_wb addr_reg:  ", print_func(mem_wb_addr_reg, 4, True ,True ,True)
    print "Latch mem_wb pc:        ", print_func(mem_wb_pc, 32, True ,True ,True)
    print "Latch mem_wb write_pc:  ", print_func(mem_wb_write_pc, 1, True ,True ,True)
    print "Latch mem_wb regwrite:  ", print_func(mem_wb_regwrite, 1, True ,True ,True)
    print "Latch mem_wb memtoreg:  ", print_func(mem_wb_memtoreg, 1, True ,True ,True)
    print "Latch mem_wb stop_pipe: ", print_func(mem_wb_stop_pipe, 1, True ,True ,True)
    print "****************************************************************"
    data_memory(reg_data_mem)
    print "****************************************************************"
    ex_mem_jump, ex_mem_pc_to_reg, ex_mem_alu_res, ex_mem_rt_reg, \
    ex_mem_addr_reg_dst, ex_mem_write_pc, ex_mem_take, ex_mem_regWrite, \
    ex_mem_memtoreg, ex_mem_memwrite, ex_mem_memread, ex_mem_load_store_type, \
    ex_mem_stop_pipe = ex_mem(reg_ex_mem) 
    print "Latch ex_mem jump_address:    ", print_func(ex_mem_jump, 32, True, True, True)
    print "Latch ex_mem pc_to_reg:       ", print_func(ex_mem_pc_to_reg, 32, True, True, True)
    print "Latch ex_mem alu_res:         ", print_func(ex_mem_alu_res, 32, True, True, True)
    print "Latch ex_mem rt_reg:          ", print_func(ex_mem_rt_reg, 32, True, True, True)
    print "Latch ex_mem addr_reg_dst:    ", print_func(ex_mem_addr_reg_dst, 5, True, True, True)
    print "Latch ex_mem write_pc:        ", print_func(ex_mem_write_pc, 1, True, True, True)
    print "Latch ex_mem jump_take:       ", print_func(ex_mem_take, 1, True, True, True)
    print "Latch ex_mem regWrite:        ", print_func(ex_mem_regWrite, 1, True, True, True)
    print "Latch ex_mem memtoreg:        ", print_func(ex_mem_memtoreg, 1, True, True, True)       
    print "Latch ex_mem memwrite:        ", print_func(ex_mem_memwrite, 1, True, True, True)       
    print "Latch ex_mem memread:         ", print_func(ex_mem_memread, 1, True, True, True)        
    print "Latch ex_mem load_store_type: ", print_func(ex_mem_load_store_type, 2, True, True, True)
    print "Latch ex_mem stop_pipe:       ", print_func(ex_mem_stop_pipe, 1, True, True, True)

    id_ex_rt_addr, id_ex_rd_addr, id_ex_rs_addr, id_ex_sig_extended, \
    id_ex_rs_reg, id_ex_rt_reg, id_ex_pc, id_ex_jump_address, id_ex_op, \
    id_ex_RegDst, id_ex_MemRead, id_ex_MemWrite, id_ex_MemtoReg, id_ex_ALUop, \
    id_ex_ALUsrc, id_ex_RegWrite, id_ex_shmat, id_ex_load_store_type, \
    id_ex_stall, id_ex_stop_pipe = id_ex(reg_id_ex)
