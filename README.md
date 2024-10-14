# FIFO UVM

## Overview

This project involves the **Universal Verification Methodology (UVM)** verification of a **Synchronous FIFO** design. The goal was to create a complete UVM environment to thoroughly verify the functionality of the FIFO, including test sequences, assertions, functional coverage, and the use of constraints and covergroups to ensure all conditions and edge cases are verified.

## UVM Structure

![Project Image](https://github.com/MohamedHussein27/FIFO-UVM/blob/main/Doc/UVM%20Structure.png)

### Key Features of the FIFO:
- **FIFO_WIDTH**: Configurable data width (default: 16 bits).
- **FIFO_DEPTH**: Configurable memory depth (default: 8 entries).

### Ports:

| Port       | Direction | Function                                                                                     |
|------------|-----------|----------------------------------------------------------------------------------------------|
| data_in    | Input     | Input data bus for writing to the FIFO.                                                       |
| wr_en      | Input     | Write Enable: Enables data write if the FIFO is not full.                                      |
| rd_en      | Input     | Read Enable: Enables data read if the FIFO is not empty.                                       |
| clk        | Input     | Clock signal.                                                                                 |
| rst_n      | Input     | Active-low reset.                                                                             |
| data_out   | Output    | Output data bus for reading from the FIFO.                                                    |
| full       | Output    | Indicates when the FIFO is full.                                                              |
| almostfull | Output    | Indicates when the FIFO is almost full.                                                       |
| empty      | Output    | Indicates when the FIFO is empty.                                                             |
| almostempty| Output    | Indicates when the FIFO is almost empty.                                                      |
| overflow   | Output    | Indicates a write was attempted while the FIFO was full.                                      |
| underflow  | Output    | Indicates a read was attempted while the FIFO was empty.                                      |
| wr_ack     | Output    | Acknowledges that a write operation has successfully occurred.                                 |

### Behavior:
- When both `rd_en` and `wr_en` are asserted, the FIFO will prioritize writing if the FIFO is not full, and reading if not empty.
- The **FIFO** handles underflow and overflow situations with clear flag indications.

---

## UVM Environment

A full UVM environment has been implemented to verify the FIFO design. This includes constraints for sequences, covergroups for functional coverage, and assertions to validate correct behavior under various operating conditions.

### Key Components:

1. **FIFO Interface (FIFO_IF.sv)**: Defines the interface for connecting to the FIFO, handling signal interactions such as data input, clock, write enable, and read enable signals.
2. **FIFO Configuration (FIFO_CONFIG.sv)**: Stores configuration parameters for the UVM environment and the DUT.
3. **FIFO Transaction (FIFO_SEQUENCE_ITEM.sv)**: Defines the read/write transaction for UVM sequences.
4. **FIFO Sequences**: Various sequences used to test the FIFO:
   - **FIFO_WRITE_SEQUENCE.sv**: Tests FIFO write operations.
   - **FIFO_READ_SEQUENCE.sv**: Tests FIFO read operations.
   - **FIFO_WRITE_READ_SEQUENCE.sv**: Combines both write and read operations for testing.
   - **FIFO_RESET_SEQUENCE.sv**: Resets the FIFO during UVM tests.
5. **FIFO Driver (FIFO_DRIVER.sv)**: Drives the DUT by generating stimuli based on sequences and applying it through the interface.
6. **FIFO Monitor (FIFO_MONITOR.sv)**: Observes the DUT's input and output, sampling transactions for the scoreboard and coverage.
7. **FIFO Scoreboard (FIFO_SCOREBOARD.sv)**: Compares the DUT's outputs with the expected values to verify correctness.
8. **FIFO Coverage Collector (FIFO_COVERAGE_COLLECTOR.sv)**: Captures functional coverage for key aspects of the FIFO, including various signal transitions and edge cases (full, empty, almost full, etc.).
9. **Assertions (FIFO_SVA.sv)**: SystemVerilog assertions ensure proper protocol adherence by the FIFO (e.g., no write when FIFO is full, no read when empty).
10. **Top-Level Environment (FIFO_ENV.sv)**: Instantiates and connects all UVM components to form the complete test environment.
11. **Main Test (FIFO_TEST.sv)**: Main test file to run UVM tests, initiating the entire verification flow.

---

## Testbench Flow

1. **Setup**: 
   - The environment is initialized, and configuration settings are applied using `FIFO_CONFIG.sv`. The FIFO interface is connected to the DUT, which is set up to simulate the FIFO.
   
2. **Sequences**:
   - Various UVM sequences are executed, starting with the `FIFO_RESET_SEQUENCE` to initialize the DUT. Following this, write, read, and combined write-read sequences (`FIFO_WRITE_SEQUENCE.sv`, `FIFO_READ_SEQUENCE.sv`, `FIFO_WRITE_READ_SEQUENCE.sv`) apply stimulus to the DUT.
   
3. **Driver and Monitor**:
   - The **FIFO Driver** (driven by UVM sequences) applies stimulus to the FIFO, while the **FIFO Monitor** observes and captures the DUT's responses to the stimuli.
   
4. **Scoreboard and Coverage**:
   - The **Scoreboard** compares the DUT's outputs with the expected values, ensuring proper functionality. Any mismatches are flagged as errors. Simultaneously, the **Coverage Collector** tracks the functional coverage of key signals and edge conditions to ensure thorough verification.
   
5. **Assertions**:
   - Throughout the simulation, assertions are constantly checking for protocol violations (e.g., trying to read when FIFO is empty, trying to write when FIFO is full).
   
6. **Final Checks**:
   - At the end of the simulation, functional coverage and assertion results are reported. The test is deemed successful if all checks pass and full functional coverage is achieved.

---

## Repository Structure:

```plaintext
FIFO-UVM/
│
├── Doc/                                    # Documentation
│   ├── FIFO UVM Doc.pdf                    # Detailed verification plan and documentation
│   └── / UVM Structure                     # UVM Structure Image
│
├── design/                                 # RTL design files for the FIFO
│   └── FIFO.sv                             # Synchronous FIFO RTL code
│
├── UVM Based Verification/                           # UVM verification environment
│   ├── FIFO_AGENT.sv                       # UVM agent, driver, monitor
│   ├── FIFO_CONFIG.sv                      # UVM configuration
│   ├── FIFO_COVERAGE_COLLECTOR.sv          # Functional coverage collector
│   ├── FIFO_DRIVER.sv                      # UVM driver
│   ├── FIFO_ENV.sv                         # UVM environment
│   ├── FIFO_IF.sv                          # FIFO interface
│   ├── FIFO_MAIN_SEQUENCE.sv               # Main test sequence
│   ├── FIFO_MONITOR.sv                     # UVM monitor
│   ├── FIFO_READ_SEQUENCE.sv               # Read operation sequence
│   ├── FIFO_RESET_SEQUENCE.sv              # Reset operation sequence
│   ├── FIFO_SCOREBOARD.sv                  # Scoreboard for output checking
│   ├── FIFO_SEQUENCER.sv                   # Sequencer for generating test sequences
│   ├── FIFO_SEQUENCE_ITEM.sv               # Sequence item definition
│   ├── FIFO_SVA.sv                         # Assertions for the FIFO
│   ├── FIFO_TEST.sv                        # Main UVM test file
│   ├── FIFO_TOP.sv                         # Top-level module for testbench
│   ├── FIFO_WRITE_READ_SEQUENCE.sv         # Write-read operation sequence
│   └── FIFO_WRITE_SEQUENCE.sv              # Write operation sequence
│
└── README.md                               # Project documentation

```

## Contact Me!

- [Email](mailto:Mohamed_Hussein2100924@outlook.com)
- [WhatsApp](https://wa.me/+2001097685797)
- [LinkedIn](https://www.linkedin.com/in/mohamed-hussein-274337231)