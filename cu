module control_unit (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,

    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg Jump,
    output reg JumpReg,
    output reg ALUSrc,
    output reg [1:0] ALUOp,
    output reg [1:0] MemtoReg
);

always @(*) begin
    // defaults
    RegWrite = 0;
    MemRead  = 0;
    MemWrite = 0;
    Branch   = 0;
    Jump     = 0;
    JumpReg  = 0;
    ALUSrc   = 0;
    ALUOp    = 2'b00;
    MemtoReg = 2'b00;

    case (opcode)

        // R-type
        7'b0110011: begin
            RegWrite = 1;
            ALUOp    = 2'b10;
            ALUSrc   = 0;
        end

        // I-type ALU
        7'b0010011: begin
            RegWrite = 1;
            ALUOp    = 2'b10;
            ALUSrc   = 1;
        end

        // LOAD
        7'b0000011: begin
            RegWrite = 1;
            MemRead  = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00;
            MemtoReg = 2'b01;
        end

        // STORE
        7'b0100011: begin
            MemWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00;
        end

        // BRANCH
        7'b1100011: begin
            Branch = 1;
            ALUOp  = 2'b01;
        end

        // JAL
        7'b1101111: begin
            RegWrite = 1;      // write PC+4 to rd
            Jump     = 1;
            MemtoReg = 2'b10;  // PC+4
        end

        // JALR
        7'b1100111: begin
            RegWrite = 1;      // write PC+4 to rd
            JumpReg  = 1;
            ALUSrc   = 1;      // rs1 + imm
            ALUOp    = 2'b00;  // ADD
            MemtoReg = 2'b10;  // PC+4
        end

        default: begin
        end
    endcase
end

endmodule
