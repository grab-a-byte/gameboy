package cartridge

import "testing"

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
