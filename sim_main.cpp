#include <memory>

#include <verilated.h>

#include "Vcpu.h"

int main(int argc, char** argv) {
    Verilated::mkdir("logs");

    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

    contextp->debug(0);

    contextp->threads(1);

    contextp->randReset(2);

    contextp->traceEverOn(true);

    contextp->commandArgs(argc, argv);

    const std::unique_ptr<Vcpu> cpu{new Vcpu{contextp.get(), "CPU"}};

    cpu->reset = !0;
    cpu->clk = 0;

    cpu->cpu_input = 0x00;
    cpu->load_addr = 0;
    cpu->load = 0;
    cpu->is_instr = 0;

    cpu->eval();

    //cpu->in_small = 1;
    //cpu->in_quad = 0x1234;
    //cpu->in_wide[0] = 0x11111111;
    //cpu->in_wide[1] = 0x22222222;
    //cpu->in_wide[2] = 0x3;

    while (!contextp->gotFinish()) {
        contextp->timeInc(1);

        cpu->clk = !cpu->clk;

        if(contextp->time() >= 10) {
            cpu->reset = 0;
        }

        cpu->eval();

        VL_PRINTF("[%" PRId64 "] clk=%x rst=%x output_val=%02x\n",
                  contextp->time(), cpu->clk, cpu->reset,
                  cpu->output_val);
    }

    cpu->final();

    #define VM_COVERAGE 1

#if VM_COVERAGE
    Verilated::mkdir("logs");
    contextp->coveragep()->write("logs/coverage.dat");
#endif

    //contextp->statsPrintSummary();

    return 0;
}