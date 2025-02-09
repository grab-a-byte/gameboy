package cartridge

import "fmt"

const (
	OP_NOP     = 0b00000000
	OP_RLCA    = 0b00000111
	OP_RRCA    = 0b00001111
	OP_RLA     = 0b00010111
	OP_RRA     = 0b00011111
	OP_DAA     = 0b00100111
	OP_CPL     = 0b00101111
	OP_SCF     = 0b00110111
	OP_CCF     = 0b00111111
	OP_STOP    = 0b00010000
	OP_HALT    = 0b01110110
	OP_RET     = 0b11001001
	OP_RET_I   = 0b11011001
	OP_JMP_HL  = 0b11101001
	OP_ADD_IMM = 0b11000110
	OP_ADC_IMM = 0b11001110
	OP_SUB_IMM = 0b11010110
	OP_SBC_IMM = 0b11011110
	OP_AND_IMM = 0b11100110
	OP_XOR_IMM = 0b11101110
	OP_OR_IMM  = 0b11110110
	OP_CP_IMM  = 0b11111110
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

func isImmediateAritmatic(b byte) bool {
	switch b {
	case OP_ADD_IMM, OP_ADC_IMM, OP_SUB_IMM, OP_SBC_IMM, OP_AND_IMM, OP_XOR_IMM, OP_OR_IMM, OP_CP_IMM:
		return true
	}

	return false
}

func dissassembleImmediateArithmatic(ins byte, operand byte) string {
	strIns := ""
	switch ins {
	case OP_ADD_IMM: strIns = "add(imm) a"
	case OP_ADC_IMM: strIns = "adc(imm) a"
	case OP_SUB_IMM: strIns = "sub(imm) a"
	case OP_SBC_IMM: strIns = "sbc(imm) a"
	case OP_AND_IMM: strIns = "and(imm) a"
	case OP_XOR_IMM: strIns = "xor(imm) a"
	case OP_OR_IMM: strIns = "or(imm) a"
	case OP_CP_IMM: strIns = "cp(imm) a"
	default: panic("Unknown immediate arithmatic instruction")
	}

	return fmt.Sprintf("%s %d", strIns, operand)
}
