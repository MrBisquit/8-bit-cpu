module Address_Register (
    input [15:0] instr,             // Instruction                                      16 bits
    output reg [3:0] addr           // The address for the Operand                      4 bits
);

    // Always run
    always @(*) begin
        addr = instr[11:8]; // Address for the Operand
    end
    
endmodule