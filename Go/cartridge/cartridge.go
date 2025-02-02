package cartridge
// index := slices.Index(data, 0xCE)
// if index < 0 {
// 	panic("Unable to find byte for header")
// } else {
// 	fmt.Println(index)
// }
// for _, b := range data[260:700] {
// 	fmt.Printf("%x ", b)
// }

type Cartridge struct {
	Title            string
	ManufacturerCode string //TODO: Need to check how this can be empty/null
	newLicenseeCode  string
	oldLicenseeCode  byte
	cartridgeType    int
	romSize          int
}

func New(bytes []byte) *Cartridge {
	return &Cartridge{
		Title:           string(bytes[TITLE_START : TITLE_END+1]),
		newLicenseeCode: string(bytes[NEW_LICENSEE_CODE_START : NEW_LICENSEE_CODE_END+1]), //May be wrong, might need to rethink
		oldLicenseeCode: bytes[OLD_LICENSEE_CODE],
	}
}

func (c *Cartridge) License() string {
	if c.oldLicenseeCode == 0x33 {
		value, ok := oldLicenseeCodeMap[c.oldLicenseeCode]
		if !ok {
			return "UNKNOWN"
		}
		return value
	}
	value, ok := newLicenseeCodeMap[c.newLicenseeCode]
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
	switch c.cartridgeType {
	case 0x00:
		return "ROM_ONLY"
	case 0x01:
		return "MBC1"
	case 0x02:
		return "MBC1+RAM"
	case 0x03:
		return "MBC1+RAM+BATTERY"
	case 0x05:
		return "MBC2"
	case 0x06:
		return "MBC2+BATTERY"
	case 0x08:
		return "ROM+RAM"
	case 0x09:
		return "ROM+RAM+BATTERY"
	case 0x0B:
		return "MMM01"
	case 0x0C:
		return "MMM01+RAM"
	case 0x0D:
		return "MMM01+RAM+BATTERY"
	case 0x0F:
		return "MBC3+TIMER+BATTERY"
	case 0x10:
		return "MBC3+TIMER+RAM+BATTERY"
	case 0x11:
		return "MBC3"
	case 0x12:
		return "MBC3+RAM"
	case 0x13:
		return "MBC3+RAM+BATTERY"
	case 0x19:
		return "MBC5"
	case 0x1A:
		return "MBC5+RAM"
	case 0x1B:
		return "MBC5+RAM+BATTERY"
	case 0x1C:
		return "MBC5+RUMBLE"
	case 0x1D:
		return "MBC5+RUMBLE+RAM"
	case 0x1E:
		return "MBC5+RUMBLE+RAM+BATTERY"
	case 0x20:
		return "MBC6"
	case 0x22:
		return "MBC7+SENSOR+RUMBLE+RAM+BATTERY"
	case 0xFC:
		return "POCKET CAMERA"
	case 0xFD:
		return "BANDAI TAMA5"
	case 0xFE:
		return "HuC3"
	case 0xFF:
		return "HuC1+RAM+BATTERY"
	}

	return "UNKNOWN cartridge type"
}

var newLicenseeCodeMap map[string]string = map[string]string{}

var oldLicenseeCodeMap map[byte]string = map[byte]string{
	0x00: "None",
	0x01: "Nintendo",
	0x08: "Capcom",
	0x09: "HOT-B",
	0x0A: "Jaleco",
	0x0B: "Coconuts Japan",
	0x0C: "Elite Systems",
	0x13: "EA (Electronic Arts)",
	0x18: "Hudson Soft",
	0x19: "ITC Entertainment",
	0x1A: "Yanoman",
	0x1D: "Japan Clary",
	0x1F: "Virgin Games Ltd",
	0x24: "PCM Complete",
	0x25: "San-X",
	0x28: "Kemco",
	0x29: "SETA Corporation",
	0x30: "Infogames",
	0x31: "Nintendo",
	0x32: "Bandai",
	0x34: "Konami",
	0x35: "HectorSoft",
	0x38: "Capcom",
	0x39: "Banpresto",
	0x3C: "Entertainment Interactive",
	0x3E: "Gremlin",
	0x41: "Ubisoft",
	0x42: "Atlus",
	0x44: "Malibu Interactive",
	0x46: "Angel",
	0x47: "Spectrum HoloByte",
	0x49: "Irem",
	0x4A: "Virgin Games Ltd",
	0x4D: "Malibu Interactive",
	0x4F: "U.S.Gold",
	0x50: "Absolute",
	0x51: "Acclaim Entertainment",
	0x52: "Activision",
	0x53: "Sammy USA Corporation",
	0x54: "GameTek",
	0x55: "Park Place",
	0x56: "LJN",
	0x57: "Matchbox",
	0x59: "Milton Bradley Company",
	0x5A: "Mindscape",
	0x5B: "Romstar",
	0x5C: "Naxat Soft",
	0x5D: "Tradewest",
	0x60: "Titus Interactive",
	0x61: "Virgin Games Ltd",
	0x67: "Ocean Software",
	0x69: "EA (Electronic Arts)",
	0x6E: "Elite Systems",
	0x6F: "Electro Brain",
	0x70: "Infograms",
	0x71: "Interplay Entertainment",
	0x72: "Broaderbund",
	0x73: "Sculpted Software",
	0x75: "The Saled Curve Limited",
	0x78: "THQ",
	0x79: "Accolade",
	0x7A: "Triffix Entertainment",
	0x7C: "MicroProse",
	0x7F: "Kemco",
	0x80: "Misawa Entertainment",
	0x83: "LOZC G.",
	0x86: "Tokuma SHoten",
	0x8B: "Bullet-Proog Software",
	0x8C: "Vic Tikai Corp.",
	0x8e: "Ape Inc.",
	0x8F: "I'Max",
	0x91: "Chunsoft Co.",
	0x92: "Video System",
	0x93: "Tsubaraya Productions",
	0x95: "Varie",
	0x96: "Yonexawa",
	0x97: "Kemco",
	0x99: "Arc",
	0x9A: "Nihom Bussan",
	0x9B: "Temco",
	0x9C: "Imagineer",
	0x9D: "Banpresto",
	0x9F: "Nova",
	0xA1: "Hori Electric",
	0xA2: "Bandai",
	0xA4: "Konami",
	0xA6: "Kawada",
	0xA7: "Takara",
	0xA9: "Technos Japan",
	0xAA: "Broderbund",
	0xAC: "Toei Animation",
	0xAD: "Toho",
	0xAF: "Namco",
	0xB0: "Acclaim Entertainment",
	0xB1: "ASCII Corporation / Nexsoft",
	0xB2: "Bandai",
	0xB4: "Square Enix",
	0xB6: "HAL Laboratory",
	0xB7: "SNK",
	0xB9: "Pony Canyon",
	0xBA: "Culture Brain",
	0xBB: "Sunsoft",
	0xBD: "Sony Imagesoft",
	0xBF: "Sammy Corporation",
	0xC0: "Taito",
	0xC2: "Kemco",
	0xC3: "Square",
	0xC4: "Tokuma Shoten",
	0xC5: "Data East",
	0xC6: "Tokin House",
	0xC8: "Koei",
	0xC9: "UFL",
	0xCA: "Ultra Games",
	0xCB: "VAP, Inc",
	0xCC: "Use Corporation",
	0xCD: "Meldac",
	0xCE: "Pony Canyon",
	0xCF: "Angel",
	0xD0: "Taito",
	0xD1: "SOFEL (Software Engineering Lab)",
	0xD2: "Quest",
	0xD3: "Sigma Enterprises",
	0xD4: "ASK Kodansha Co.",
	0xD6: "Naxat Soft",
	0xD7: "Copya System",
	0xD9: "Banpresto",
	0xDA: "Tomy",
	0xDB: "LJN",
	0xDD: "Nipon Computer Systems",
	0xDE: "Human Ent.",
	0xDF: "Altron",
	0xE0: "Jaleco",
	0xE1: "Towa Chiki",
	0xE2: "Yutaka",
	0xE3: "Varie",
	0xE5: "Epoch",
	0xE7: "Athena",
	0xE8: "Asmik Ace Entertainment",
	0xE9: "Natsume",
	0xEA: "King Records",
	0xEB: "Atlus",
	0xEC: "Epic/Sony Records",
	0xEE: "IGS",
	0xF0: "A Wave",
	0xF3: "Extreme Entertainment",
	0xFF: "LJN",
}
