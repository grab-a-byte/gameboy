package cartridge

import (
	"encoding/binary"
	"fmt"
)

var r8Map = map[int]string{
	0: "b",
	1: "c",
	2: "d",
	3: "e",
	4: "h",
	5: "l",
	6: "[hl]",
	7: "a",
}

var r16Map = map[int]string{
	0: "bc",
	1: "de",
	2: "hl",
	3: "sp",
}

var r16StkMap = map[int]string{
	0: "bc",
	1: "de",
	2: "hl",
	3: "af",
}

var r16MemMap = map[int]string{
	0: "bc",
	1: "de",
	2: "hl+",
	3: "hl-",
}

var condMap = map[int]string{
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
		paramName := r16Map[int(param)]
		value := binary.LittleEndian.Uint16(bytes[1:3])
		return fmt.Sprintf("ld %s, %d", paramName, value), 3

	//ld [r16mem], a
	case 0x02, 0x12, 0x22, 0x32:
		param := (instruction & 0b0011000) >> 4
		paramName := r16MemMap[int(param)]
		return fmt.Sprintf("ld [%s], a", paramName), 1

	//ld a, [r16mem]
	case 0x0A, 0x1A, 0x2A, 0x3A:
		param := (instruction & 0b0011000) >> 4
		paramName := r16MemMap[int(param)]
		return fmt.Sprintf("ld a, [%s]", paramName), 1

	//ld [imm16], sp
	case 0x08:
		value := binary.LittleEndian.Uint16(bytes[1:3])
		return fmt.Sprintf("ld [%d], sp", value), 3

	//inc r16
	case 0x03, 0x13, 0x23, 0x33:
		param := (instruction & 0b00111000) >> 4
		paramName := r16Map[int(param)]
		return fmt.Sprintf("inc %s", paramName), 1

	//dec r16
	case 0x0B, 0x1B, 0x2B, 0x3B:
		param := (instruction & 0b00111000) >> 4
		paramName := r16Map[int(param)]
		return fmt.Sprintf("dec %s", paramName), 1

	//add hl, r16
	case 0x09, 0x19, 0x29, 0x39:
		param := (instruction & 0b00111000) >> 4
		paramName := r16Map[int(param)]
		return fmt.Sprintf("dec %s", paramName), 1

	//inc r8
	case 0x04, 0x14, 0x24, 0x34, 0x0C, 0x1C, 0x2C, 0x3C:
		operand := (instruction & 0b00111000) >> 3
		paramName := r8Map[int(operand)]
		return fmt.Sprintf("inc %s", paramName), 1

	//dec r8
	case 0x05, 0x15, 0x25, 0x35, 0x0D, 0x1D, 0x2D, 0x3D:
		operand := (instruction & 0b00111000) >> 3
		paramName := r8Map[int(operand)]
		return fmt.Sprintf("dec %s", paramName), 1

	//ld r8, imm8
	case 0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E:
		operand := (instruction & 0b00111000) >> 3
		paramName := r8Map[int(operand)]
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
		condName := condMap[int(cond)]
		val := bytes[1]
		return fmt.Sprintf("jr %s, %d", condName, val), 2

	//stop
	case 0x10:
		return "stop", 1
	}

	// panic(fmt.Sprintf("Unknown operand %8x", instruction))
	//Temp just to keep things moving and parse whole file
	return fmt.Sprintf("%2x", instruction), 1
}
