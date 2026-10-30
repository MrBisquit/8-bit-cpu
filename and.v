module And (
    input [7:0] a,                  // First input                                      8 bits
    input [7:0] b,                  // Second input                                     8 bits
    
    output [7:0] y                  // Output                                           8 bits
);

    assign y = a & b; // Bitwise AND operation
    
endmodule