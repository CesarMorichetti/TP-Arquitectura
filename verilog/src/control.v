`timescale 1ns / 1ps
module control(
            input wire [5 : 0] i_op,
            input wire [5 : 0] i_func,
        
            output reg         RegDst,
            output reg         MemRead,
            output reg         MemWrite,
            output reg         MemtoReg,
            output reg [3 : 0] ALUop,
            output reg         ALUsrc,
            output reg         RegWrite,
            output reg         shmat,
            output reg [2 : 0] load_store_type
            );


    always@(*) begin
        load_store_type  = i_op[2 : 0];
        case(i_op[5 : 3])
            //Load
            3'b100: begin
                RegDst      = 0;
                MemRead     = 1;
                MemWrite    = 0;
                MemtoReg    = 1;
                ALUop       = 4'b0001;
                ALUsrc      = 1;
                RegWrite    = 1;
                shmat       = 0;

            end
            //Store
            3'b101: begin
                RegDst      = 0;
                MemRead     = 0;
                MemWrite    = 1;
                MemtoReg    = 0;
                ALUop       = 4'b0001;
                ALUsrc      = 1;
                RegWrite    = 0;
                shmat       = 0;

            end
            //INMED
            3'b001: begin
                RegDst      = 0;
                MemRead     = 0;
                MemWrite    = 0;
                MemtoReg    = 0;
                ALUop       = {1'b1,i_op[2:0]};
                ALUsrc      = 1;
                RegWrite    = 1;
                shmat       = 0;

            end
            //R-type or jump or branch
            3'b000: begin
                if(i_op[2])begin
                //branch
                    RegDst      = 0;
                    MemRead     = 0;
                    MemWrite    = 0;
                    MemtoReg    = 0;
                    ALUop       = 4'b0000;//Indistinto
                    ALUsrc      = 0;
                    RegWrite    = 0;
                    shmat       = 0;
                end
                else begin
                    if(i_op[1])begin
                    //j/jal
                        RegDst      = 0;
                        MemRead     = 0;
                        MemWrite    = 0;
                        MemtoReg    = 0;
                        ALUop       = 4'b0000;//Indistinto
                        ALUsrc      = 0;
                        RegWrite    = i_op[0];
                        shmat       = 0;
                    end
                    else begin
                        if(i_func[5:1]== 5'b00100) begin
                        //JR/JALR
                            RegDst      = i_func[0];
                            MemRead     = 0;
                            MemWrite    = 0;
                            MemtoReg    = 0;
                            ALUop       = 4'b0000;//Indistinto
                            ALUsrc      = 0;
                            RegWrite    = i_func[0];
                            shmat       = 0;
                        end
                        else begin
                        //R-type
                            RegDst      = 1;
                            MemRead     = 0;
                            MemWrite    = 0;
                            MemtoReg    = 0;
                            ALUop       = 4'b0000;//Campo func
                            ALUsrc      = 0;
                            RegWrite    = 1;
                            shmat       = (i_func[5:2]==0);
                        end
                    end
                end
            end
            default: begin
                RegDst      = 0;
                MemRead     = 0;
                MemWrite    = 0;
                MemtoReg    = 0;
                ALUop       = 4'b0000;
                ALUsrc      = 0;
                RegWrite    = 0;
                shmat       = 0;
            end
        endcase
    end

endmodule
