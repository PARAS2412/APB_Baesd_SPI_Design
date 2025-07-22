# APB_Baesd_SPI_Design

SPI Controller with APB Interface (Verilog)
This project implements a complete Serial Peripheral Interface (SPI) controller with support for APB (Advanced Peripheral Bus) communication. It includes key components such as a shift register, slave select logic, baud rate generator, and APB slave interface for easy processor integration. The design is simulation-ready and verified using ModelSim.

Architecture Overview
The SPI controller receives control and data inputs via the APB interface. The data is serialized using a configurable shift register and transmitted over the MOSI line. The controller also receives data via the MISO line. Timing is handled by a baud rate generator, and the entire system is governed by proper slave select and mode control logic.

Features
-Supports SPI Master mode with configurable CPOL, CPHA, and LSB/MSB bit ordering.
-Fully APB-compliant interface for register access and control.
-Dynamic baud rate generator using prescaler values (SPPR, SPR) for clock division.
-Clean data transmission/reception using an internal shift register.
-Slave select (SS) logic for safe SPI communication handling.
-Interrupt generation on transfer completion.
-Compatible with FPGAs and soft-core processor integration.
-Verified using ModelSim testbenches.

SPI_APB_Controller/
├── src/                  # All Verilog source files
│   ├── top_module.v
│   ├── shift_register.v
│   ├── baud_rate_generator.v
│   ├── slave_select_control.v
│   └── apb_slave_interface.v
│
├── tb/                   # Testbench for top module
│   └── tb_top_module.v
│
├── sim/                  # Simulation scripts and ModelSim files
   └── waveform.do

Tools Used
-ModelSim – Simulation
-Quartus Prime – Optional synthesis for FPGA targets
-Verilog HDL – RTL Design




