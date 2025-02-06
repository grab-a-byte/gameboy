package cartridge

import (
	"fmt"
	"strings"
)

type Cartridge struct {
	Title            string
	ManufacturerCode string //TODO: Need to check how this can be empty/null
	newLicenseeCode  []byte //Need an example where these are set to check encoding
	oldLicenseeCode  byte
	cartridgeType    byte
	romSize          int
}

func New(bytes []byte) *Cartridge {
	return &Cartridge{
		Title:           string(bytes[TITLE_START : TITLE_END+1]),
		newLicenseeCode: bytes[NEW_LICENSEE_CODE_START : NEW_LICENSEE_CODE_END+1],
		oldLicenseeCode: bytes[OLD_LICENSEE_CODE],
		cartridgeType:   bytes[CARTRIDGE_TYPE],
		romSize: int(bytes[ROM_SIZE]), //Could calculate direct to save recalculation each time
	}
}

func (c *Cartridge) String() string {
	var builder strings.Builder
	builder.WriteString("Title: ")
	builder.WriteString(c.Title)
	builder.WriteRune('\n')

	builder.WriteString("Licensee: ")
	builder.WriteString(c.License())
	builder.WriteRune('\n')

	builder.WriteString("Cartridge Type: ")
	builder.WriteString(c.Type())
	builder.WriteRune('\n')

	builder.WriteString("Rom Size: ")
	builder.WriteString(fmt.Sprint(c.RomSize()))
	builder.WriteRune('\n')

	return builder.String()
}

func (c *Cartridge) License() string {
	if c.oldLicenseeCode != 0x33 {
		value, ok := oldLicenseeCodeMap[c.oldLicenseeCode]
		if !ok {
			return "UNKNOWN"
		}
		return value
	}

	value, ok := newLicenseeCodeMap[string(c.newLicenseeCode)]
	if !ok {
		return "UNKNOWN NEW"
	}
	return value
}

func (c *Cartridge) RomSize() int {
	kib := 1024 * 32
	return kib * (1 << c.romSize)
}

func (c *Cartridge) Type() string {
	value, ok := cartridgeTypeMap[c.cartridgeType]
	if !ok {
		return "Unknown cartridge type"
	}
	return value
}
