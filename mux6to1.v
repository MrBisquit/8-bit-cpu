module Mux6to1 (
    input [7:0] in0,                // Input for operation 0                            8 bits
    input [7:0] in1,                // Input for operation 1                            8 bits
    input [7:0] in2,                // Input for operation 2                            8 bits
    input [7:0] in3,                // Input for operation 3                            8 bits
    input [7:0] in4,                // Input for operation 4                            8 bits
    input [7:0] in5,                // Input for operation 5                            8 bits
    
    input [2:0] sel,                // Select input                                     3 bits
    
    output [7:0] out,               // Output                                           8 bits
);

    assign out = (sel = 3'b000) ? in0 :
        (sel == 3'b001) ? in1 :
        (sel == 3'b010) ? in2 :
        (sel == 3'b011) ? in3 :
        (sel == 3'b100) ? in4 :
        (sel == 3'b101) ? in5 :
        8'b0; // Should not occur
    
endmodule