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

const (
	op_add = 0b10000000
	op_adc = 0b10001000
	op_sub = 0b10010000
	op_sbc = 0b10011000
	op_and = 0b10100000
	op_xor = 0b10101000
	op_or  = 0b10110000
	op_cp  = 0b10111000
)

func isArithmatic(number byte) bool {
	return (0b11000000 & number) == 0b10000000
}

func dissassembleArithmatic(number uint8) (bool, string) {
	masked := number & 0b11111000
	operand, _, err := arithmaticOperand(number)
	if err != nil {
		panic("Unknown mathematical operand")
	}
	switch masked {
	case op_add:
		return true, fmt.Sprintf("add a %s", operand)
	case op_adc:
		return true, fmt.Sprintf("adc a %s", operand)
	case op_sub:
		return true, fmt.Sprintf("sub a %s", operand)
	case op_sbc:
		return true, fmt.Sprintf("sbc a %s", operand)
	case op_and:
		return true, fmt.Sprintf("and a %s", operand)
	case op_xor:
		return true, fmt.Sprintf("xor a %s", operand)
	case op_or:
		return true, fmt.Sprintf("or a %s", operand)
	case op_cp:
		return true, fmt.Sprintf("cp a %s", operand)
	}

	return false, ""
}

func arithmaticOperand(number uint8) (string, uint8, error) {
	value := number & 0b00000111
	if val, ok := regStrMap[value]; ok {
		return val, value, nil
	}

	return "", 0, fmt.Errorf("unable to determine operand, looking for operand %d", value)
}
