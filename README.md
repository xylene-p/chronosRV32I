RISC-V Pipelined Processor
===================

A RV32I processor

## Overview
RISC-V ISA Five-Stage Pipelined Processor written in Verilog

## Files

## Setup
Ubuntu 16.04 LTS -> Linux VM on Google Cloud Platform
Specs: 2 vCPUs, 7.5 GB

### Start
Install the RISC-V toolchain as specified below.

#### RISC-V Software Tools Installation
The RISC-V toolchain is available on GitHub(http://github.com/riscv/riscv-tools).

### Environment Configuration

Value                         | Alias
---------------------------   | ---------------
riscv32-unknown-elf-gcc       | riscv-gcc
riscv32-unknown-elf-objdump   | riscv-objdump

# Testing
Compile RISC-V assembly file (.S)
  riscv32-unknown-elf-gcc -o rv32itest rv32itest.S

Generate assembly dump file (.dump)
  riscv32-unknown-elf-objdump --disassemble-all --disassemble-zeroes \
  --section=.text --section=.data rv32itest > rv32itest.dump
