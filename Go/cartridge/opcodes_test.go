package cartridge

import (
	"testing"
)

func Test_ArithmaticDissassembly(t *testing.T) {
	table := []struct {
		input uint8
		str   string
	}{
		{0b10000000, "add a, b"},
		{0b10000001, "add a, c"},
		{0b10000010, "add a, d"},
		{0b10000011, "add a, e"},
		{0b10000100, "add a, h"},
		{0b10000101, "add a, l"},
		{0b10000110, "add a, [hl]"},
		{0b10000111, "add a, a"},

		{0b10001000, "adc a, b"},
		{0b10001001, "adc a, c"},
		{0b10001010, "adc a, d"},
		{0b10001011, "adc a, e"},
		{0b10001100, "adc a, h"},
		{0b10001101, "adc a, l"},
		{0b10001110, "adc a, [hl]"},
		{0b10001111, "adc a, a"},

		{0b10010000, "sub a, b"},
		{0b10010001, "sub a, c"},
		{0b10010010, "sub a, d"},
		{0b10010011, "sub a, e"},
		{0b10010100, "sub a, h"},
		{0b10010110, "sub a, [hl]"},
		{0b10010101, "sub a, l"},
		{0b10010111, "sub a, a"},

		{0b10011000, "sbc a, b"},
		{0b10011001, "sbc a, c"},
		{0b10011010, "sbc a, d"},
		{0b10011011, "sbc a, e"},
		{0b10011100, "sbc a, h"},
		{0b10011101, "sbc a, l"},
		{0b10011110, "sbc a, [hl]"},
		{0b10011111, "sbc a, a"},

		{0b10100000, "and a, b"},
		{0b10100001, "and a, c"},
		{0b10100010, "and a, d"},
		{0b10100011, "and a, e"},
		{0b10100100, "and a, h"},
		{0b10100101, "and a, l"},
		{0b10100110, "and a, [hl]"},
		{0b10100111, "and a, a"},

		{0b10101000, "xor a, b"},
		{0b10101001, "xor a, c"},
		{0b10101010, "xor a, d"},
		{0b10101011, "xor a, e"},
		{0b10101100, "xor a, h"},
		{0b10101101, "xor a, l"},
		{0b10101110, "xor a, [hl]"},
		{0b10101111, "xor a, a"},

		{0b10110000, "or a, b"},
		{0b10110001, "or a, c"},
		{0b10110010, "or a, d"},
		{0b10110011, "or a, e"},
		{0b10110100, "or a, h"},
		{0b10110101, "or a, l"},
		{0b10110110, "or a, [hl]"},
		{0b10110111, "or a, a"},

		{0b10111000, "cp a, b"},
		{0b10111001, "cp a, c"},
		{0b10111010, "cp a, d"},
		{0b10111011, "cp a, e"},
		{0b10111100, "cp a, h"},
		{0b10111101, "cp a, l"},
		{0b10111110, "cp a, [hl]"},
		{0b10111111, "cp a, a"},
	}

	for _, check := range table {
		input := []byte{check.input}
		str, length := dissassembleNextBytes(input)
		if length != 1 {
			t.Errorf("Expected length for %b to be 1 but found %d", check.input, length)
		}
		if str != check.str {
			t.Errorf("Expected str for %b to be %s but found %s", check.input, check.str, str)
		}
	}
}
