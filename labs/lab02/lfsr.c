#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    uint16_t leftBit = 0;
    leftBit ^= (*reg >> 0) & 1;
    leftBit ^= (*reg >> 2) & 1;
    leftBit ^= (*reg >> 3) & 1;
    leftBit ^= (*reg >> 5) & 1;
    *reg >>= 1;
    *reg |= (leftBit << 15);
}

