package cartridge

// Cartridge Memory Locations
const (
	ENTRY_POINT_START         = 0x0100
	ENTRY_POINT_END           = 0x0103
	NINTENDO_LOGO_START       = 0x0104
	NINTENDO_LOGO_END         = 0x0113
	TITLE_START               = 0x0134
	TITLE_END                 = 0x0143
	MANUFACTUTURER_CODE_START = 0x013F
	MANUFACTUTURER_CODE_END   = 0x0142
	CGB_FLAG                  = 0x0143
	NEW_LICENSEE_CODE_START   = 0x0144
	NEW_LICENSEE_CODE_END     = 0x0145
	SGB_FLAG                  = 0x0146
	CARTRIDGE_TYPE            = 0x0147
	ROM_SIZE                  = 0x0148
	RAM_SIZE                  = 0x0149
	DESTINATION_CODE          = 0x014A
	OLD_LICENSEE_CODE         = 0x014B
	MASK_ROM_VERSION          = 0x014C
	HEADER_CHECKSUM           = 0x014D
	GLOBAL_CHECKSUM_START     = 0x014E
	GLOBAL_CHECKSUM_END       = 0x014F
)
