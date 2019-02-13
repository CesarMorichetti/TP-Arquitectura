`timescale 1ns / 1ps
module tb_control();

    reg [5 : 0]  op;
    reg [5 : 0]  func;

    wire         RegDst;
    //wire         jump;
    //wire         Branch;
    wire         MemRead;
    wire         MemWrite;
    wire         MemtoReg;
    wire [3 : 0] ALUop;
    wire         ALUsrc;
    wire         RegWrite;
    wire         shmat;
    wire [2 : 0] load_store_type;
    
    initial begin
    
    op      = 0;
    func    = 0;

    #100
    //ADD
    op      = 6'b000000;
    func    = 6'b100000;
    #20
    //SUB
    op      = 6'b000000;
    func    = 6'b100010;
    #20
    //AND
    op      = 6'b000000;
    func    = 6'b100100;
    #20
    //OR
    op      = 6'b000000;
    func    = 6'b100101;
    #20
    //XOR
    op      = 6'b000000;
    func    = 6'b100110;
    #20
    //NOR
    op      = 6'b000000;
    func    = 6'b100111;
    #20
    //SLT
    op      = 6'b000000;
    func    = 6'b101010;
    #20
    //SLL
    op      = 6'b000000;
    func    = 6'b000000;
    #20
    //SRL
    op      = 6'b000000;
    func    = 6'b000010;
    #20
    //SRA
    op      = 6'b000000;
    func    = 6'b000011;
    #20
    //SLLV
    op      = 6'b000000;
    func    = 6'b000100;
    #20
    //SRLV
    op      = 6'b000000;
    func    = 6'b000110;
    #20
    //SRAV
    op      = 6'b000000;
    func    = 6'b000111;
    #20
    //ADDU
    op      = 6'b000000;
    func    = 6'b100001;
    #20
    //SUBU
    op      = 6'b000000;
    func    = 6'b100011;
    

    //Tipo I
    #20
    //LB
    op      = 6'b100000;
    func    = 6'b000000;
    #20
    //LH
    op      = 6'b100001;
    func    = 6'b000000;
    #20
    //LW
    op      = 6'b100011;
    func    = 6'b000000;
    #20
    //LBU
    op      = 6'b100100;
    func    = 6'b000000;
    #20
    //LHU
    op      = 6'b100101;
    func    = 6'b000000;
    #20
    //SB
    op      = 6'b101000;
    func    = 6'b000000;
    #20
    //SH
    op      = 6'b101001;
    func    = 6'b000000;
    #20
    //SW
    op      = 6'b101011;
    func    = 6'b000000;
    #20
    //ADDI
    op      = 6'b001000;
    func    = 6'b000000;
    #20
    //ANDI
    op      = 6'b001100;
    func    = 6'b000000;
    #20
    //ORI
    op      = 6'b001101;
    func    = 6'b000000;
    #20
    //XORI
    op      = 6'b001110;
    func    = 6'b000000;
    #20
    //LUI
    op      = 6'b001111;
    func    = 6'b000000;
    #20
    //SLTI
    op      = 6'b001010;
    func    = 6'b000000;
    #20
    //BEQ
    op      = 6'b000100;
    func    = 6'b000000;
    #20
    //BNE
    op      = 6'b000101;
    func    = 6'b000000;
    #20
    //J
    op      = 6'b000010;
    func    = 6'b000000;
    #20
    //J
    op      = 6'b000010;
    func    = 6'b000000;
    #20
    //JAL
    op      = 6'b000011;
    func    = 6'b000000;
    #20
    //JR
    op      = 6'b000000;
    func    = 6'b001000;
    #20
    //JALR
    op      = 6'b000000;
    func    = 6'b001001;

    end

    control u_control(
                    .i_op(op),
                    .i_func(func),
                    .RegDst(RegDst),
                    .MemRead(MemRead),
                    .MemWrite(MemWrite),
                    .MemtoReg(MemtoReg),
                    .ALUop(ALUop),
                    .ALUsrc(ALUsrc),
                    .RegWrite(RegWrite),
                    .shmat(shmat),
                    .load_store_type(load_store_type)
                    );

endmodule
