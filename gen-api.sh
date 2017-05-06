#!/bin/sh

svd2rust -i resources/STM32F40x.svd > src/lib.rs

# Reformat compiler attributes removing unnecessary spaces
# Remove spaces from # [ attribute ] => #[attribute] and add \n
sed -i 's/\s*# \[ \([^]]*\) \]/\n#[\1]/g' src/lib.rs
# Remove spaces from # ! [ attribute ] and add \n
sed -i 's/\s*# ! \[ \([^]]*\) \]/#![\1]\n/g' src/lib.rs
sed -i 's/ \([()]\) */\1/g' src/lib.rs

# Use rustfmt to reformat to human readable format
rustfmt src/*.rs

# Test that build succeeds for target platform (ARM Cortex-M4)
xargo check --target thumbv7em-none-eabihf
