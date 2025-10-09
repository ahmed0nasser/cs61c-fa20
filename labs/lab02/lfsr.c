#include "lfsr.h"
#include <stdint.h>
#define CODE 0b0000000000101101

// recursive solution
uint8_t calculate_msb(uint16_t reg, uint16_t code) {
  if (code == 0)
    return 0;
  return (reg & (code & 1)) ^ calculate_msb(reg >> 1, code >> 1);
}

void lfsr_calculate(uint16_t *reg) {
  uint16_t code = CODE;
  uint16_t creg = *reg;
  uint8_t msb = 0;
  for (int i = 0; i < 16; i++) {
    msb ^= (creg & (code & 1));
    code >>= 1;
    creg >>= 1;
  }
  *reg >>= 1;
  *reg = (*reg & ~(1 << 15)) + (msb << 15);
}
