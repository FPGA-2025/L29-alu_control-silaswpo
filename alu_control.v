module ALU_Control (
    input wire is_immediate_i,
    input wire [1:0] ALU_CO_i,
    input wire [6:0] FUNC7_i,
    input wire [2:0] FUNC3_i,
    output reg [3:0] ALU_OP_o
);

always @* begin
    case (ALU_CO_i)
        2'b00: begin
            // LOAD/STORE → sempre soma
            ALU_OP_o = 4'b0010; // SUM
        end
2'b01: begin
    case (FUNC3_i)
        3'b000: ALU_OP_o = 4'b1010; // BLT ou similar
        3'b001: ALU_OP_o = 4'b0011; // BNE → EQUAL para verificação de desigualdade
        3'b010: ALU_OP_o = 4'b1010;
        3'b011: ALU_OP_o = 4'b1010;
        3'b100: ALU_OP_o = 4'b1100;
        3'b101: ALU_OP_o = 4'b1110;
        3'b110: ALU_OP_o = 4'b1101;
        3'b111: ALU_OP_o = 4'b1111;
        default: ALU_OP_o = 4'b0000;
    endcase
end



        2'b10: begin
            // ALU → depende de FUNC3, FUNC7 e is_immediate
            case (FUNC3_i)
                3'b000: begin
                    if (is_immediate_i || FUNC7_i == 7'b0000000)
                        ALU_OP_o = 4'b0010; // ADD ou ADDI → SUM
                    else if (FUNC7_i == 7'b0100000)
                        ALU_OP_o = 4'b1010; // SUB
                    else
                        ALU_OP_o = 4'b0000; // padrão
                end
                3'b111: ALU_OP_o = 4'b0000; // AND
                3'b110: ALU_OP_o = 4'b0001; // OR
                3'b100: ALU_OP_o = 4'b1000; // XOR
                3'b010: ALU_OP_o = 4'b1110; // SLT
                3'b011: ALU_OP_o = 4'b1111; // SLTU
                3'b001: ALU_OP_o = 4'b0100; // SLL
                3'b101: begin
                    if (FUNC7_i == 7'b0000000)
                        ALU_OP_o = 4'b0101; // SRL
                    else if (FUNC7_i == 7'b0100000)
                        ALU_OP_o = 4'b0111; // SRA
                    else
                        ALU_OP_o = 4'b0000; // padrão
                end
                default: ALU_OP_o = 4'b0000;
            endcase
        end
        default: ALU_OP_o = 4'b0000; // Instrução inválida
    endcase
end

endmodule
