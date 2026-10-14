# Synchronous FIFO Design Using Verilog

## Overview

This project implements a synchronous First-In, First-Out (FIFO) buffer using Verilog HDL. It stores input data and outputs it in the same order it was written.

The design is parameterized, allowing the data width and FIFO depth to be configured. Functional verification and synthesis were performed using Xilinx Vivado 2024.2.

## Features

- Parameterized data width and FIFO depth
- Synchronous reset
- Read and write enable controls
- Full and empty status flags
- FIFO overflow and underflow protection
- FIFO data-order verification
- Pointer wraparound testing
- Simultaneous read and write testing

## Design Specifications

| Parameter | Value |
|---|---|
| Data width | 8 bits |
| FIFO depth | 16 entries |
| Testbench clock period | 10 ns |
| Testbench clock frequency | 100 MHz |

## Tools Used

- Verilog HDL
- Xilinx Vivado 2024.2
- Vivado Simulator (XSim)

## Project Structure

```text
Synchronous-FIFO-Verilog/
├── sync_fifo.v
├── tb_sync_fifo.v
├── README.md
└── Screenshots/
    ├── simulation_results.png
    ├── simulation_waveform.png
    └── synthesis_utilization.png
```

## Simulation and Verification

The testbench verifies the following scenarios:

1. Reset behavior and initial empty status
2. Sequential write and read operations
3. FIFO data ordering
4. FIFO full condition
5. Overflow protection when writing while full
6. FIFO draining and empty status
7. Pointer wraparound
8. Simultaneous read and write operations

**Simulation result:** `ALL TESTS PASSED` in the recorded Vivado XSim run.

### 1. Simulation Test Results

This screenshot shows the testbench output, including the final simulation status.

<!<img width="575" height="593" alt="image" src="https://github.com/user-attachments/assets/df877c93-b230-41b8-a732-173def494c19" />


### 2. Simulation Waveform

This waveform shows the clock, reset, read/write enables, input/output data, and FIFO status flags.

<img width="1567" height="571" alt="image" src="https://github.com/user-attachments/assets/1554ceaa-6fc6-412a-bb5a-a6dad001ff8d" />


## Synthesis Results

The following resource utilization values were reported by Vivado for the selected FPGA target.

| Resource | Used | Available | Utilization |
|---|---:|---:|---:|
| LUT | 24 | 20,800 | 0.12% |
| Flip-Flops (FF) | 25 | 41,600 | 0.06% |
| I/O | 22 | 106 | 20.75% |

### 3. Vivado Synthesis Utilization Report



*Note: Resource utilization depends on the selected FPGA device and synthesis settings.*

## Learning Outcomes

- RTL design using Verilog HDL
- Synchronous digital design principles
- FIFO read/write control and pointer management
- Functional simulation and testbench development
- FPGA synthesis and resource utilization analysis

## Future Improvements

- Add randomized test scenarios
- Add assertions for protocol verification
- Test different data widths and FIFO depths
- Perform timing analysis
- Implement the design on an FPGA development board

## Author

Kavin K K

Electronics and Communication Engineering (ECE)

GitHub Profile: [@kavinkk0509](https://github.com/kavinkk0509)
