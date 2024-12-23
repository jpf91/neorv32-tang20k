#!/bin/bash

# Only export path if yosys is not already available
if ! [ -x "$(command -v yosys)" ]; then
    source $HOME/.local/fpga/oss-cad-suite/environment
fi

# Allow sourcing this script without params. Otherwise exec command
if [ $# -ne 0 ]; then
    exec "$@"
fi