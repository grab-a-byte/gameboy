package cartridge

import "fmt"

const (
	OP_NOP    = 0b00000000
	OP_RLCA   = 0b00000111
	OP_RRCA   = 0b00001111
	OP_RLA    = 0b00010111
	OP_RRA    = 0b00011111
	OP_DAA    = 0b00100111
	OP_CPL    = 0b00101111
	OP_SCF    = 0b00110111
	OP_CCF    = 0b00111111
	OP_STOP   = 0b00010000
	OP_HALT   = 0b01110110
	OP_RET    = 0b11001001
	OP_RET_I  = 0b11011001
	OP_JMP_HL = 0b11101001
)

const (
	REG8_B uint8 = iota
	REG8_C
	REG8_D
	REG8_E
	REG8_H
	REG8_L
	REG8_HL
	REG8_A
)

var regStrMap = map[uint8]string{
	REG8_B:  "b",
	REG8_C:  "c",
	REG8_D:  "d",
	REG8_E:  "e",
	REG8_H:  "h",
	REG8_L:  "l",
	REG8_HL: "[hl]",
	REG8_A:  "a",
}

func arithmaticOperand(number uint8) (string, uint8, error) {
	value := number & 0b00000111
	if val, ok := regStrMap[value]; ok {
		return val, value, nil
	}

	return "", 0, fmt.Errorf("unable to determine operand, looking for operand %d", value)
}
