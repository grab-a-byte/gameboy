package cartridge

import (
	"encoding/binary"
	"fmt"
)

var r8Map = map[byte]string{
	0: "b",
	1: "c",
	2: "d",
	3: "e",
	4: "h",
	5: "l",
	6: "[hl]",
	7: "a",
}

var r16Map = map[byte]string{
	0: "bc",
	1: "de",
	2: "hl",
	3: "sp",
}

var r16StkMap = map[byte]string{
	0: "bc",
	1: "de",
	2: "hl",
	3: "af",
}

var r16MemMap = map[byte]string{
	0: "bc",
	1: "de",
	2: "hl+",
	3: "hl-",
}

var condMap = map[byte]string{
	0: "nz",
	1: "z",
	2: "nc",
	3: "c",
}

// Values are broken up in line with https://gbdev.io/pandocs/CPU_Instruction_Set.html
// as of 19/2/2025
func dissassembleNextBytes(bytes []byte) (string, int) {

	instruction := bytes[0]

	switch instruction {
	//nop
	case 0x00:
		return "nop", 1

	//ld r16 imm16
	case 0x01, 0x11, 0x21, 0x31:
		param := (instruction & 0b0011000) >> 4
		paramName := r16Map[param]
		value := binary.LittleEndian.Uint16(bytes[1:3])
		return fmt.Sprintf("ld %s, %d", paramName, value), 3

	//ld [r16mem], a
	case 0x02, 0x12, 0x22, 0x32:
		param := (instruction & 0b0011000) >> 4
		paramName := r16MemMap[param]
		return fmt.Sprintf("ld [%s], a", paramName), 1

	//ld a, [r16mem]
	case 0x0A, 0x1A, 0x2A, 0x3A:
		param := (instruction & 0b0011000) >> 4
		paramName := r16MemMap[param]
		return fmt.Sprintf("ld a, [%s]", paramName), 1

	//ld [imm16], sp
	case 0x08:
		value := binary.LittleEndian.Uint16(bytes[1:3])
		return fmt.Sprintf("ld [%d], sp", value), 3

	//inc r16
	case 0x03, 0x13, 0x23, 0x33:
		param := (instruction & 0b00111000) >> 4
		paramName := r16Map[param]
		return fmt.Sprintf("inc %s", paramName), 1

	//dec r16
	case 0x0B, 0x1B, 0x2B, 0x3B:
		param := (instruction & 0b00111000) >> 4
		paramName := r16Map[param]
		return fmt.Sprintf("dec %s", paramName), 1

	//add hl, r16
	case 0x09, 0x19, 0x29, 0x39:
		param := (instruction & 0b00111000) >> 4
		paramName := r16Map[param]
		return fmt.Sprintf("dec %s", paramName), 1

	//inc r8
	case 0x04, 0x14, 0x24, 0x34, 0x0C, 0x1C, 0x2C, 0x3C:
		operand := (instruction & 0b00111000) >> 3
		paramName := r8Map[operand]
		return fmt.Sprintf("inc %s", paramName), 1

	//dec r8
	case 0x05, 0x15, 0x25, 0x35, 0x0D, 0x1D, 0x2D, 0x3D:
		operand := (instruction & 0b00111000) >> 3
		paramName := r8Map[operand]
		return fmt.Sprintf("dec %s", paramName), 1

	//ld r8, imm8
	case 0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E:
		operand := (instruction & 0b00111000) >> 3
		paramName := r8Map[operand]
		val := bytes[1]
		return fmt.Sprintf("ld %s, %d", paramName, val), 2

	//rlca
	case 0x07:
		return "rlca", 1

	//rrca
	case 0x0F:
		return "rrca", 1

	//rla
	case 0x17:
		return "rla", 1

	//rra
	case 0x1F:
		return "rra", 1

	//daa
	case 0x27:
		return "daa", 1

	//cpl
	case 0x2F:
		return "cpl", 1

	//scf
	case 0x37:
		return "scf", 1

	//ccf
	case 0x3F:
		return "ccf", 1

	//jr imm8
	case 0x18:
		val := bytes[1]
		return fmt.Sprintf("jr %d", val), 2

	//jr cond, imm8
	case 0x20, 0x30, 0x28, 0x38:
		cond := (instruction & 0b00011000) >> 3
		condName := condMap[cond]
		val := bytes[1]
		return fmt.Sprintf("jr %s, %d", condName, val), 2

	//stop
	case 0x10:
		return "stop", 1

	//ls r8, r8 //TODO: Return as 100% certain some are missed
	case 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,
		0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F,
		0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57,
		0x58, 0x59, 0x5A, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F,
		0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,
		0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F:
		src := (instruction & 0b00111000) >> 3
		dest := (instruction & 0b00000111)
		srcName := r8Map[src]
		destName := r8Map[dest]
		return fmt.Sprintf("ld %s, %s", srcName, destName), 1

	//halt
	case 0x76:
		return "halt", 1

	// add a, r8
	case 0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87:
		operand := (instruction & 0b00000111)
		operandName := r8Map[operand]
		return fmt.Sprintf("add a, %s", operandName), 1

	// adc a, r8
	case 0x88, 0x89, 0x8A, 0x8B, 0x8C, 0x8D, 0x8E, 0x8F:
		operand := (instruction & 0b00000111)
		operandName := r8Map[operand]
		return fmt.Sprintf("adc a, %s", operandName), 1

	// sub a, r8
	case 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97:
		operand := (instruction & 0b00000111)
		operandName := r8Map[operand]
		return fmt.Sprintf("sub a, %s", operandName), 1

	// sbc a, r8
	case 0x98, 0x99, 0x9A, 0x9B, 0x9C, 0x9D, 0x9E, 0x9F:
		operand := (instruction & 0b00000111)
		operandName := r8Map[operand]
		return fmt.Sprintf("sbc a, %s", operandName), 1

	// and a, r8
	case 0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7:
		operand := (instruction & 0b00000111)
		operandName := r8Map[operand]
		return fmt.Sprintf("and a, %s", operandName), 1

	// xor a, r8
	case 0xA8, 0xA9, 0xAA, 0xAB, 0xAC, 0xAD, 0xAE, 0xAF:
		operand := (instruction & 0b00000111)
		operandName := r8Map[operand]
		return fmt.Sprintf("xor a, %s", operandName), 1

	// or a, r8
	case 0xB0, 0xB1, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6, 0xB7:
		operand := (instruction & 0b00000111)
		operandName := r8Map[operand]
		return fmt.Sprintf("xor a, %s", operandName), 1

	// cp a, r8
	case 0xB8, 0xB9, 0xBA, 0xBB, 0xBC, 0xBD, 0xBE, 0xBF:
		operand := (instruction & 0b00000111)
		operandName := r8Map[operand]
		return fmt.Sprintf("cp a, %s", operandName), 1

	// add a, imm8
	case 0xC6:
		value := bytes[1]
		return fmt.Sprintf("add a, %d", value), 2

	// adc a, imm8
	case 0xCE:
		value := bytes[1]
		return fmt.Sprintf("adc a, %d", value), 2

	//sub a, imm8
	case 0xD6:
		value := bytes[1]
		return fmt.Sprintf("sub a, %d", value), 2

	//sbc a, imm8
	case 0xDE:
		value := bytes[1]
		return fmt.Sprintf("sbc a, %d", value), 2

	//and a, imm8
	case 0xE6:
		value := bytes[1]
		return fmt.Sprintf("and a, %d", value), 2

	// xor a, imm8
	case 0xEE:
		value := bytes[1]
		return fmt.Sprintf("xor a, %d", value), 2

	//or a, imm8
	case 0xF6:
		value := bytes[1]
		return fmt.Sprintf("or a, %d", value), 2

	// cp a, imm8
	case 0xFE:
		value := bytes[1]
		return fmt.Sprintf("cp a, %d", value), 2

	// ret cond
	case 0xC0, 0xC8, 0xD0, 0xD8:
		cond := (instruction & 0b00011000) >> 3
		condName := condMap[cond]
		return fmt.Sprintf("ret %s", condName), 1

	// ret
	case 0xC9:
		return "ret", 1

	// reti
	case 0xD9:
		return "reti", 1

	// jp cond imm16
	case 0xC2, 0xCA, 0xD2, 0xDA:
		cond := (instruction & 0b00011000) >> 3
		condName := condMap[cond]
		value := binary.LittleEndian.Uint16(bytes[1:3])
		return fmt.Sprintf("jp %s, %d", condName, value), 3

	// jp imm16
	case 0xC3:
		value := binary.LittleEndian.Uint16(bytes[1:3])
		return fmt.Sprintf("jp %d", value), 3

	// call cond imm16
	case 0xC4, 0xCC, 0xD4, 0xDC:
		cond := (instruction & 0b00011000) >> 3
		condName := condMap[cond]
		value := binary.LittleEndian.Uint16(bytes[1:3])
		return fmt.Sprintf("call %s, %d", condName, value), 3

	// call imm16
	case 0xCD:
		value := binary.LittleEndian.Uint16(bytes[1:3])
		return fmt.Sprintf("call %d", value), 3

	// rst tgt3
	case 0xC7, 0xCF, 0xD7, 0xDF, 0xE7, 0xEF, 0xF7, 0xFF:
		tgt := (instruction & 0b00111000) >> 3
		return fmt.Sprintf("rst %d", tgt), 1
	}

	// panic(fmt.Sprintf("Unknown operand %8x", instruction))
	//Temp just to keep things moving and parse whole file
	return fmt.Sprintf("%2x: %8b", instruction, instruction), 1
}
