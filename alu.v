/* verilator lint_off IMPLICIT */
/* verilator lint_off WIDTHEXPAND */

module ALU (
    input [7:0] a,                  // Operand from the ACC                             8 bits
    input [7:0] b,                  // Operand from the DR                              8 bits

    input sub,                      // Subtraction symbol

    input [2:0] op_select,          // Operation selection                              3 bits

    output [7:0] result,            // Unified result output                            8 bits

    output cout,                    // Carry out for ADD/SUB
    output overflow,                // Overflow flag
    output negative,                // Negative flag
    output zero                     // Zero flag
);

    wire [7:0] sum;                 // Sum output from Math_Unit                        8 bits
    wire [7:0] and_res_internal;    // AND operation result                             8 bits
    wire [7:0] or_res_internal;     // OR operation result                              8 bits
    wire [7:0] mult_res;            // MULT operation result                            8 bits
    wire [7:0] div_res;             // DIV operation result                             8 bits
    wire overflow_arithmetic;       // Overflow detection for arithmetic operations

    // EXECUTE

    // ADD and SUB
    Math_Unit math_unit (
        .a(a),                              // a                -> a
        .b(b),                              // b                -> b
        .sub(sub),                          // sub              -> sub
        .sum(sum),                          // sum              -> sum
        .cout(cout),                        // cout             -> cout
        .overflow(overflow_arithmetic),     // overflow         -> overflow_arithmetic
        .negative(negative),                // negative         -> negative
        .zero(zero)                         // zero             -> zero
    );

    // AND operation
    And andOp (
        .a(a),                              // a                -> a
        .b(b),                              // b                -> b
        .y(and_res_internal)                // y                -> and_res_internal
    );

    // OR operation
    Or orOp (
        .a(a),                              // a                -> a
        .b(b),                              // b                -> b
        .y(or_res_internal)                 // y                -> or_res_internal
    );

    // MULT
    Multiplier mult (
        .a(a),                              // a                -> a
        .b(b),                              // b                -> b
        .product(multiply_res)              // product          -> multiply_res
    );

    // DIV
    Divider div (
        .dividend(a),                       // dividend         -> a
        .divisor(b),                        // divisor          -> b
        .quotient(divide_result),           // quotient         -> divide_result
        .remainder()                        // remainder        -> (empty, unused)
    );

    // Select between different operation results (6-to-1 MUX)
    Mux mux (
        .in0(sum),                          // in0              -> sum
        .in1(sum),                          // in1              -> sum
        .in2(and_res_internal),             // in2              -> and_res_internal
        .in3(or_res_internal),              // in3              -> or_res_internal
        .in4(mult_res),                     // in4              -> mult_res
        .in5(div_res),                      // in5              -> div_res
        .in6(b),                            // in6              -> b
        .sel(op_select),                    // sel              -> op_select
        .out(result)                        // out              -> result
    );

    // Overflow detection (only for addition and subtraction)
    assign overflow = (op_select == 3'b000 || op_select == 3'b001) && overflow_arithmetic;
    
endmodule
