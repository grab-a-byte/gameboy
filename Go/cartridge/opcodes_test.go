package cartridge

import (
	"strings"
	"testing"
)

func Test_AritmaticOperand(t *testing.T) {

	table := []struct {
		input uint8
		str   string
		value uint8
	}{
		{0b10000000, "b", 0},
		{0b10000001, "c", 1},
		{0b10000010, "d", 2},
		{0b10000011, "e", 3},
		{0b10000100, "h", 4},
		{0b10000101, "l", 5},
		{0b10000110, "[hl]", 6},
		{0b10000111, "a", 7},
	}

	for _, check := range table {
		str, value, err := arithmaticOperand(check.input)
		if err != nil {
			t.Error("Failed to get operand")
		}
		if str != check.str {
			t.Errorf("Expected '%s' got '%s'", check.str, str)
		}

		if value != check.value {
			t.Errorf("Expected '%d' got '%d'", check.value, value)
		}
	}
}

func Test_DissassembleArithmatic(t *testing.T) {
	table := []struct {
		input uint8
		str   string
		value bool
	}{
		{0b10000000, "add a", true},
		{0b10000001, "add a", true},
		{0b10000010, "add a", true},
		{0b10000011, "add a", true},
		{0b10000100, "add a", true},
		{0b10000110, "add a", true},
		{0b10000101, "add a", true},
		{0b10000111, "add a", true},

		{0b10001000, "adc a", true},
		{0b10001001, "adc a", true},
		{0b10001010, "adc a", true},
		{0b10001011, "adc a", true},
		{0b10001100, "adc a", true},
		{0b10001110, "adc a", true},
		{0b10001101, "adc a", true},
		{0b10001111, "adc a", true},

		{0b10010000, "sub a", true},
		{0b10010001, "sub a", true},
		{0b10010010, "sub a", true},
		{0b10010011, "sub a", true},
		{0b10010100, "sub a", true},
		{0b10010110, "sub a", true},
		{0b10010101, "sub a", true},
		{0b10010111, "sub a", true},

		{0b10011000, "sbc a", true},
		{0b10011001, "sbc a", true},
		{0b10011010, "sbc a", true},
		{0b10011011, "sbc a", true},
		{0b10011100, "sbc a", true},
		{0b10011110, "sbc a", true},
		{0b10011101, "sbc a", true},
		{0b10011111, "sbc a", true},

		{0b10100000, "and a", true},
		{0b10100001, "and a", true},
		{0b10100010, "and a", true},
		{0b10100011, "and a", true},
		{0b10100100, "and a", true},
		{0b10100110, "and a", true},
		{0b10100101, "and a", true},
		{0b10100111, "and a", true},

		{0b10101000, "xor a", true},
		{0b10101001, "xor a", true},
		{0b10101010, "xor a", true},
		{0b10101011, "xor a", true},
		{0b10101100, "xor a", true},
		{0b10101110, "xor a", true},
		{0b10101101, "xor a", true},
		{0b10101111, "xor a", true},

		{0b10110000, "or a", true},
		{0b10110001, "or a", true},
		{0b10110010, "or a", true},
		{0b10110011, "or a", true},
		{0b10110100, "or a", true},
		{0b10110110, "or a", true},
		{0b10110101, "or a", true},
		{0b10110111, "or a", true},

		{0b10111000, "cp a", true},
		{0b10111001, "cp a", true},
		{0b10111010, "cp a", true},
		{0b10111011, "cp a", true},
		{0b10111100, "cp a", true},
		{0b10111110, "cp a", true},
		{0b10111101, "cp a", true},
		{0b10111111, "cp a", true},
	}

	for _, check := range table {
		val, str := dissassembleArithmatic(check.input)
		if val != check.value {
			t.Errorf("Expected value for %b to be %t but found %t", check.input, check.value, val)
		}
		if !strings.HasPrefix(str, check.str) {
			t.Errorf("Expected str for %b to be %s but found %s", check.input, check.str, str)
		}
	}
}
