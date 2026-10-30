module Multiplier (
    input [7:0] a,                  // First input                                      8 bits
    input [7:0] b,                  // Second input                                     8 bits
    
    output [7:0] product            // Product                                          8 bits
);

    // Internal wires to hold partial products
    wire [7:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;

    // Internal wires to hold the sums and carries
    wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6;
    wire carry0, carry1, carry2, carry3, carry4, carry5;

    // Generate the partial products
    assign pp0 = (a & {8{b[0]}});       // Partial product for b[0]
    assign pp1 = (a & {8{b[1]}}) << 1;  // Partial product for b[1], shifted by 1 bit
    assign pp2 = (a & {8{b[2]}}) << 2;  // Partial product for b[2], shifted by 2 bits
    assign pp3 = (a & {8{b[3]}}) << 3;  // Partial product for b[3], shifted by 3 bits
    assign pp4 = (a & {8{b[4]}}) << 4;  // Partial product for b[4], shifted by 4 bits
    assign pp5 = (a & {8{b[5]}}) << 5;  // Partial product for b[5], shifted by 5 bits
    assign pp6 = (a & {8{b[6]}}) << 6;  // Partial product for b[6], shifted by 6 bits
    assign pp7 = (a & {8{b[7]}}) << 7;  // Partial product for b[7], shifted by 7 bits

    // Sum the partial products using 8-bit adders
    Full_Adder_8Bit adder0 (.a(pp0),    .b(pp1),    .cin(1'b0),   .sum(sum0), .cout(carry0));
    Full_Adder_8Bit adder1 (.a(pp2),    .b(pp3),    .cin(carry0), .sum(sum1), .cout(carry1));
    Full_Adder_8Bit adder2 (.a(pp4),    .b(pp5),    .cin(carry1), .sum(sum2), .cout(carry2));
    Full_Adder_8Bit adder3 (.a(pp6),    .b(pp6),    .cin(carry2), .sum(sum3), .cout(carry3));

    Full_Adder_8Bit adder4 (.a(sum0),   .b(sum1),   .cin(carry3), .sum(sum4), .cout(carry4));
    Full_Adder_8Bit adder5 (.a(sum2),   .b(sum3),   .cin(carry4), .sum(sum5), .cout(carry5));

    // Final sum provides the product
    assign product = sum4 + sum5;
    
endmodule