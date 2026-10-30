module Math_Unit (
    input [7:0] a,                  // Operand from the ACC                             8 bits
    input [7:0] b,                  // Operand from the DR                              8 bits

    input sub,                      // Subtraction symbol

    input [7:0] sum,                 // Sum output                                      8 bits

    output cout,                    // Carry out for ADD/SUB
    output overflow,                // Overflow flag
    output negative,                // Negative flag
    output zero                     // Zero flag
);

    wire [7:0] b_xor;               // XOR-ed version of b                              8 bits
    wire carry_in;
    wire or_result;

    // XOR b with the subtraction signal, so it handles both addition and subtraction
    assign b_xor = b ^ {8{sub}};

    // Carry input to the adder is the subtraction signal
    assign carry_in = sub;

    Full_Adder_8Bit adder (
        .a(a),                              // a                -> a
        .b(b_xor),                          // b                -> b_xor
        .cin(carry_in),                     // cin              -> carry_in
        .sum(sum),                          // sum              -> sum
        .cout(cout)                         // cout             -> cout
    );

    // Overflow detection, this occurs if carry-in to MSB differs from the carry-out of MSB
    assign overflow = (a[7] & b_xor[7] & ~sum[7] | (~a[7] ^ ~b_xor[7] & sum[7]));

    // Negative output, high if the most significant bit (sign bit) of the result is 1
    assign negative = sum[7];

    // Zero out, high if all bits in the result are 0
    assign or_result = |sum;

    assign zero = ~or_result;

endmodule