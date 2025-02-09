package cartridge

import (
	"errors"
	"fmt"
	"log"
	"strings"
)

type Cartridge struct {
	Title            string
	ManufacturerCode string //TODO: Need to check how this can be empty/null
	newLicenseeCode  []byte //Need an example where these are set to check encoding
	oldLicenseeCode  byte
	cartridgeType    byte
	romSize          int
	instructions     []string
}

func New(bytes []byte) (*Cartridge, error) {
	err := Validate(bytes)
	if err != nil {
		return nil, err
	}

	title := string(bytes[TITLE_START : TITLE_END+1])
	manCode := bytesToRunesToString(bytes[MANUFACTUTURER_CODE_START : MANUFACTUTURER_CODE_END+1])
	//Older Cartridges had this as part of title, the -1 is due to Manufacturer Code being at
	// 0x142 end and Title ending at 0x0143 so we need to be one less
	// so we set it as none as cannot be determined
	if strings.HasSuffix(title[:len(title)-1], manCode) {
		manCode = "NONE"
	}

	cart := &Cartridge{
		Title:            title,
		newLicenseeCode:  bytes[NEW_LICENSEE_CODE_START : NEW_LICENSEE_CODE_END+1],
		oldLicenseeCode:  bytes[OLD_LICENSEE_CODE],
		cartridgeType:    bytes[CARTRIDGE_TYPE],
		romSize:          int(bytes[ROM_SIZE]), //Could calculate direct to save recalculation each time
		ManufacturerCode: manCode,
	}

	instructions := bytes[0x0150:]
	for i := 0; i < len(instructions); i++ {
		b := instructions[i]
		str := ""
		if isArithmatic(b) {
			valid, ins := dissassembleArithmatic(b)
			if !valid {
				log.Println("Invalid instruction")
			}
			str = ins
		} else if isImmediateAritmatic(b) {
			str = dissassembleImmediateArithmatic(b, instructions[i+1])
			i += 1
		} else {
			str = "Unknown"
		}
		cart.instructions = append(cart.instructions, str)
	}

	return cart, nil
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

	builder.WriteString("Manufacturer Code: ")
	builder.WriteString(c.ManufacturerCode)
	builder.WriteRune('\n')

	//Commented to get rest of header working
	// for i, s := range c.instructions {
	// 	str := fmt.Sprintf("% x: %s \n", i, s)
	// 	builder.WriteString(str)
	// }

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

func Validate(bytes []byte) error {
	validateNintendoLogo(bytes)
	if !validateNintendoLogo(bytes) {
		return errors.New("unable to verfy nintendo logo, please check the carteidge you are using")
	}
	return nil
}

func validateNintendoLogo(bytes []byte) bool {
	//TODO: Only validte half if this fails and check due to newer cartridges
	slice := bytes[0x104:0x0134]
	expected := []byte{0xCE, 0xED, 0x66, 0x66, 0xCC, 0x0D, 0x00, 0x0B, 0x03, 0x73, 0x00, 0x83, 0x00, 0x0C, 0x00, 0x0D,
		0x00, 0x08, 0x11, 0x1F, 0x88, 0x89, 0x00, 0x0E, 0xDC, 0xCC, 0x6E, 0xE6, 0xDD, 0xDD, 0xD9, 0x99,
		0xBB, 0xBB, 0x67, 0x63, 0x6E, 0x0E, 0xEC, 0xCC, 0xDD, 0xDC, 0x99, 0x9F, 0xBB, 0xB9, 0x33, 0x3E}

	if len(slice) != len(expected) {
		return false
	}

	for i := range expected {
		if slice[i] != expected[i] {
			return false
		}
	}
	return true
}

func bytesToRunesToString(bytes []byte) string {
	runes := []rune{}
	for _, b := range bytes {
		runes = append(runes, rune(b))
	}
	return string(runes)
}
