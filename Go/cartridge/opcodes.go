package cartridge

import (
	"encoding/binary"
	"fmt"
)

// Consts are broken up in line with https://gbdev.io/pandocs/CPU_Instruction_Set.html
// as of 19/2/2025
const (
	//Block 0
	OP_NOP = 0b00000000

	OP_LD_R16_IMM16 = 0b00000001
	OP_LD_R16MEM    = 0b00000010
	OP_LD_A_R16MEM  = 0b00001010
	OP_LD_IMM16_SP  = 0b00001000

	OP_INC_R16    = 0b00000011
	OP_DEC_R16    = 0b00001011
	OP_ADD_HL_R16 = 0b00001000

	OP_INC_R8 = 0b0000100
	OP_DEC_R8 = 0b0000101

	OP_LD_R8_IMM8 = 0b0000110

	OP_RLCA = 0b00000111
	OP_RRCA = 0b00001111
	OP_RLA  = 0b00010111
	OP_RRA  = 0b00011111
	OP_DAA  = 0b00100111
	OP_CPL  = 0b00101111
	OP_SCF  = 0b00110111
	OP_CCF  = 0b00111111

	OP_JR_IMM8      = 0b00011000
	OP_JR_COND_IMM8 = 0b00100000

	OP_STOP = 0b00010000

	//Block 1: 8 bit register loads
	//impossible to encode ld [hl][hl]
	OP_LD_R8_R8 = 0b01000000

	OP_HALT = 0b01110110

	//Block 2: 8-bit arithmatic
	OP_ADD_A_R8 = 0b10000000
	OP_ADC_A_R8 = 0b10001000
	OP_SUB_A_R8 = 0b10010000
	OP_SBC_A_R8 = 0b10011000
	OP_AND_A_R8 = 0b10100000
	OP_XOR_A_R8 = 0b10101000
	OP_OR_A_R8  = 0b10110000
	OP_CP_A_R8  = 0b10111000

	//Block 3
	OP_ADD_A_IMM = 0b11000110
	OP_ADC_A_IMM = 0b11001110
	OP_SUB_A_IMM = 0b11010110
	OP_SBC_A_IMM = 0b11011110
	OP_AND_A_IMM = 0b11100110
	OP_XOR_A_IMM = 0b11101110
	OP_OR_A_IMM  = 0b11110110
	OP_CP_A_IMM  = 0b11111110

	OP_RET_COND        = 0b11000000
	OP_RET             = 0b11001001
	OP_RET_I           = 0b11011001
	OP_JP_COND_IMM16   = 0b11000010
	OP_JP_IMM16        = 0b11000011
	OP_JMP_HL          = 0b11101001
	OP_CALL_COND_IMM16 = 0b11000100
	OP_CALL_IMM16      = 0b11001101
	OP_RST_TGT3        = 0b11000111

	OP_POP_R16STK  = 0b11000001
	OP_PUSH_R16STK = 0b11000101

	OP_PREFIX = 0b11001011

	OP_LDH_C_A    = 0b11100010
	OP_LDH_IMM8_A = 0b11100000
	OP_LD_IMM16_A = 0b11101010
	OP_LD_A_C     = 0b11110010
	OP_LDH_A_IMM8 = 0b11110000
	OP_LS_A_IMM16 = 0b11111010

	OP_ADD_SP_IMM8   = 0b11101000
	OP_LD_HL_SP_IMM8 = 0b11111000
	OP_LD_SP_HL      = 0b11111001

	OP_DI = 0b11110011
	OP_EI = 0b11111011

	OP_PRE_RLC_R8  = 0b00000000
	OP_PRE_RRC_R8  = 0b00001000
	OP_PRE_RL_R8   = 0b00010000
	OP_PRE_RR_R8   = 0b00011000
	OP_PRE_SLA     = 0b00100000
	OP_PRE_SRA     = 0b00101000
	OP_PRE_SWAP_R8 = 0b00110000
	OP_PRE_SRL_R8  = 0b00111000

	OP_PRE_BIT_B3_R8 = 0b01000000
	OP_PRE_RES_B3_R8 = 0b10000000
	OP_PRE_SET_B3_R8 = 0b11000000
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

func dissassembleNextBytes(bytes []byte) (string, int) {
	instruction := bytes[0]

	maskEquals := func(b uint8) bool {
		return instruction&b == b
	}

	if maskEquals(OP_NOP) {
		return "OP_NOP", 1
	}

	if maskEquals(OP_LD_R16_IMM16) {
		regMasked := (instruction & 0b00110000) >> 4
		regName := r16Map[int(regMasked)]
		val := binary.LittleEndian.Uint16(bytes[1:3])
		return fmt.Sprintf("ld %s %d", regName, val), 3
	}

	return "", 0
}
