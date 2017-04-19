#!/bin/bash
riscv32-unknown-elf-gcc -o beq beq.S
riscv32-unknown-elf-objdump --disassemble-all --disassemble-zeroes \
--section=.text --section=.data beq > beq.dump
