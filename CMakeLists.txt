cmake_minimum_required(VERSION 3.12)
cmake_policy(SET CMP0074 NEW)

project(cpu CXX)

find_package(verilator HINTS $ENV{VERILATOR_ROOT} ${VERILATOR_ROOT})
if(NOT verilator_FOUND)
    message(
        FATAL_ERROR
        "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable"
    )
endif()

# SystemC dependencies
#set(THREADS_PREFER_PTHREAD_FLAG ON)
#find_package(Threads REQUIRED)

# Find SystemC using SystemC's CMake integration
#find_package(SystemCLanguage QUIET)

# Create a new executable target that will contain all your sources
add_executable(cpu sim_main.cpp)
target_compile_features(cpu PUBLIC cxx_std_14)

set_property(TARGET cpu PROPERTY CXX_STANDARD ${SystemC_CXX_STANDARD})

# Add the Verilated circuit to the target
verilate(cpu COVERAGE TRACE_VCD TRACE
  INCLUDE_DIRS "./"
  VERILATOR_ARGS -f input.vc -x-assign fast
  SOURCES cpu.v
)

verilator_link_systemc(cpu)