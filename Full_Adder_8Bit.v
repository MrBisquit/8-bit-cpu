/* verilator lint_off UNOPTFLAT */

module Full_Adder (
    input a,                        // First input bit
    input b,                        // Second input bit
    input cin,                      // Carry in
    
    output sum,                     // Sum output
    output cout                     // Carry out
);

    assign sum = a ^ b ^ cin;                   // Sum is the XOR of a, b, and cin
    assign cout = (a & b) | (cin & (a ^ b));    // Carry-out logic
    
endmodule

module Full_Adder_8Bit (
    input [7:0] a,                  // First input                                      8 bits
    input [7:0] b,                  // Second input                                     8 bits

    input cin,                      // Carry in

    output [7:0] sum,               // Sum output                                       8 bits
    output cout                     // Carry out (from the most significant bit)
);

    wire [7:0] carry;               // Immediate carry signals                          8 bits

    // 8 1-bit full adders, 1 for each bit
    Full_Adder fa0 (.a(a[0]), .b(b[0]), .cin(cin),       .sum(sum[0]), .cout(carry[0]));
    Full_Adder fa1 (.a(a[1]), .b(b[1]), .cin(carry[0]),  .sum(sum[1]), .cout(carry[1]));
    Full_Adder fa2 (.a(a[2]), .b(b[2]), .cin(carry[1]),  .sum(sum[2]), .cout(carry[2]));
    Full_Adder fa3 (.a(a[3]), .b(b[3]), .cin(carry[2]),  .sum(sum[3]), .cout(carry[3]));
    Full_Adder fa4 (.a(a[4]), .b(b[4]), .cin(carry[3]),  .sum(sum[4]), .cout(carry[4]));
    Full_Adder fa5 (.a(a[5]), .b(b[5]), .cin(carry[4]),  .sum(sum[5]), .cout(carry[5]));
    Full_Adder fa6 (.a(a[6]), .b(b[6]), .cin(carry[5]),  .sum(sum[6]), .cout(carry[6]));
    Full_Adder fa7 (.a(a[7]), .b(b[7]), .cin(carry[6]),  .sum(sum[7]), .cout(cout)); // Most significant bit
    
endmodule
