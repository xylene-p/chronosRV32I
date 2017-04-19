Chronos RV32I: A RISC-V Pipelined Processor
===================

## Overview
RISC-V ISA Five-Stage Pipelined Processor written in Verilog

## Files

## Setup
Ubuntu 16.04 LTS -> Linux VM on Google Cloud Platform
Specs: 2 vCPUs, 7.5 GB

### Start
#### Requirements
- Verilog compiler: Icarus Verilog
- RISC-V toolchain (for compiling .S programs)
    - Install the RISC-V toolchain as specified below.

## Testing

### Hardware Source Files
In terminal:
```bash
bash run.sh
```

### Compiling Assembly Files
Compile RISC-V assembly file (.S)
  riscv32-unknown-elf-gcc -o rv32itest rv32itest.S

Generate assembly dump file (.dump)
  riscv32-unknown-elf-objdump --disassemble-all --disassemble-zeroes \
  --section=.text --section=.data rv32itest > rv32itest.dump


## WIP
#### Pipeline Stages
- [x] Instruction Fetch
- [x] Instruction Decode
- [ ] Execute
- [ ] Memory
- [ ] Write Back

#### Pipeline Control Units
- [ ] Data Hazard Detection Unit
    - Verify that hazards are detected during simulation

#### Branch Prediction
- [x] Branch target and condition generator
    - [ ] Integrate in EX-Stage
- [ ] Branch target buffer
    - [ ] Integrate in ID-Stage
- [ ] Hybrid branch predictor
    - [ ] Predictor 1: Two-bit saturating counter
    - [ ] Predictor 2: Q-learning predictor
    - [ ] Hybrid branch selector
    - [ ] Integrate in ID-Stage

#### RISC-V Software Tools Installation
The RISC-V toolchain is available on [GitHub](http://github.com/riscv/riscv-tools).

### Environment Configuration

Value                         | Alias
---------------------------   | ---------------
riscv32-unknown-elf-gcc       | riscv-gcc
riscv32-unknown-elf-objdump   | riscv-objdump
