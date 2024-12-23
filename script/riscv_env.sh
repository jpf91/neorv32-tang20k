#!/bin/bash

# Only export path if riscv-none-elf-gcc is not already available
if ! [ -x "$(command -v riscv-none-elf-gcc)" ]; then
    export PATH=$PATH:/home/jpfau/.local/fpga/xpack-riscv-none-elf-gcc-14.2.0-3/bin
fi

# Allow sourcing this script without params. Otherwise exec command
if [ $# -ne 0 ]; then
    exec "$@"
fi