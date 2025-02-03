const std = @import("std");

const Cartridge = struct {
    Title: [16]u8,
    ManufacturerCode: [4]u8,
    NewLicenseeCode: [2]u8,
    CartrigeType: u8,
    romSize: u8,
    OldLicenseeCode: u8,

    pub fn Destination(self: *Cartridge) ![]u8 {
        return if (self.DestinationCode == 0) "Japan" else "Overseas";
    }

    pub fn LicenseeCode(self: *const Cartridge) ![]u8 {
        return if (self.OldLicenseeCode == 33) self.NewLicense() else self.OldLicense();
    }

    fn NewLicense(self: *const Cartridge) ![]u8 {
        return if (self.NewLicenseeCode[0] == '0' and self.NewLicenseeCode[1] == '0') {
            "None";
        } else if (self.NewLicenseeCode[0] == '0' and self.NewLicenseeCode[1] == '1') {
            "Nintendo Research & Development";
        } else if (self.NewLicenseeCode[0] == '0' and self.NewLicenseeCode[1] == '8') {
            "Capcom";
        } else if (self.NewLicenseeCode[0] == '1' and self.NewLicenseeCode[1] == '3') {
            "EA (Electronic Arts)";
        } else if (self.NewLicenseeCode[0] == '1' and self.NewLicenseeCode[1] == '8') {
            "HudsonSoft";
        } else if (self.NewLicenseeCode[0] == '1' and self.NewLicenseeCode[1] == '9') {
            "B-AI";
        } else if (self.NewLicenseeCode[0] == '2' and self.NewLicenseeCode[1] == '0') {
            "KSS";
        } else if (self.NewLicenseeCode[0] == '2' and self.NewLicenseeCode[1] == '2') {
            "Planning Office WADA";
        } else if (self.NewLicenseeCode[0] == '2' and self.NewLicenseeCode[1] == '4') {
            "PCM Complete";
        } else if (self.NewLicenseeCode[0] == '2' and self.NewLicenseeCode[1] == '5') {
            "San-X";
        } else if (self.NewLicenseeCode[0] == '2' and self.NewLicenseeCode[1] == '8') {
            "Kemco";
        } else if (self.NewLicenseeCode[0] == '2' and self.NewLicenseeCode[1] == '9') {
            "SETA Corporation";
        } else if (self.NewLicenseeCode[0] == '3' and self.NewLicenseeCode[1] == '0') {
            "Viacom";
        } else if (self.NewLicenseeCode[0] == '3' and self.NewLicenseeCode[1] == '1') {
            "Nintendo";
        } else if (self.NewLicenseeCode[0] == '3' and self.NewLicenseeCode[1] == '2') {
            "Bandai";
        } else if (self.NewLicenseeCode[0] == '3' and self.NewLicenseeCode[1] == '3') {
            "Ocean Software / Acclaim Entertainment";
        } else if (self.NewLicenseeCode[0] == '3' and self.NewLicenseeCode[1] == '4') {
            "Konami";
        } else if (self.NewLicenseeCode[0] == '3' and self.NewLicenseeCode[1] == '5') {
            "HectorSoft";
        } else if (self.NewLicenseeCode[0] == '3' and self.NewLicenseeCode[1] == '7') {
            "Taito";
        } else if (self.NewLicenseeCode[0] == '3' and self.NewLicenseeCode[1] == '8') {
            "Hudson Soft";
        } else if (self.NewLicenseeCode[0] == '3' and self.NewLicenseeCode[1] == '9') {
            "Banpresto";
        } else if (self.NewLicenseeCode[0] == '4' and self.NewLicenseeCode[1] == '1') {
            "Ubisoft";
        } else if (self.NewLicenseeCode[0] == '4' and self.NewLicenseeCode[1] == '2') {
            "Atlus";
        } else if (self.NewLicenseeCode[0] == '4' and self.NewLicenseeCode[1] == '4') {
            "Malibu Interactive";
        } else if (self.NewLicenseeCode[0] == '4' and self.NewLicenseeCode[1] == '6') {
            "Angel";
        } else if (self.NewLicenseeCode[0] == '4' and self.NewLicenseeCode[1] == '7') {
            "Bullet-Proof Software";
        } else if (self.NewLicenseeCode[0] == '4' and self.NewLicenseeCode[1] == '9') {
            "Irem";
        } else if (self.NewLicenseeCode[0] == '5' and self.NewLicenseeCode[1] == '0') {
            "Absolute";
        } else if (self.NewLicenseeCode[0] == '5' and self.NewLicenseeCode[1] == '1') {
            "Acclaim Entertainment";
        } else if (self.NewLicenseeCode[0] == '5' and self.NewLicenseeCode[1] == '2') {
            "Activision";
        } else if (self.NewLicenseeCode[0] == '5' and self.NewLicenseeCode[1] == '3') {
            "Amyy USA Corporation";
        } else if (self.NewLicenseeCode[0] == '5' and self.NewLicenseeCode[1] == '4') {
            "Konami";
        } else if (self.NewLicenseeCode[0] == '5' and self.NewLicenseeCode[1] == '5') {
            "Hi Tech Expressions";
        } else if (self.NewLicenseeCode[0] == '5' and self.NewLicenseeCode[1] == '6') {
            "LJN";
        } else if (self.NewLicenseeCode[0] == '5' and self.NewLicenseeCode[1] == '7') {
            "Matchbox";
        } else if (self.NewLicenseeCode[0] == '5' and self.NewLicenseeCode[1] == '8') {
            "Mattel";
        } else if (self.NewLicenseeCode[0] == '5' and self.NewLicenseeCode[1] == '9') {
            "Milton Bradley Company";
        } else if (self.NewLicenseeCode[0] == '6' and self.NewLicenseeCode[1] == '0') {
            "Titus Interactive";
        } else if (self.NewLicenseeCode[0] == '6' and self.NewLicenseeCode[1] == '1') {
            "Virgin Games";
        } else if (self.NewLicenseeCode[0] == '6' and self.NewLicenseeCode[1] == '4') {
            "Lucasfilm Games";
        } else if (self.NewLicenseeCode[0] == '6' and self.NewLicenseeCode[1] == '7') {
            "Ocean Software";
        } else if (self.NewLicenseeCode[0] == '6' and self.NewLicenseeCode[1] == '9') {
            "EA (Electronic Arts)";
        } else if (self.NewLicenseeCode[0] == '7' and self.NewLicenseeCode[1] == '0') {
            "Infogrames";
        } else if (self.NewLicenseeCode[0] == '7' and self.NewLicenseeCode[1] == '1') {
            "Interplay Entertainment";
        } else if (self.NewLicenseeCode[0] == '7' and self.NewLicenseeCode[1] == '2') {
            "Broderbund";
        } else if (self.NewLicenseeCode[0] == '7' and self.NewLicenseeCode[1] == '3') {
            "Sculpted Software";
        } else if (self.NewLicenseeCode[0] == '7' and self.NewLicenseeCode[1] == '5') {
            "The Sales Curve Limited";
        } else if (self.NewLicenseeCode[0] == '7' and self.NewLicenseeCode[1] == '8') {
            "THQ";
        } else if (self.NewLicenseeCode[0] == '7' and self.NewLicenseeCode[1] == '9') {
            "Accolade";
        } else if (self.NewLicenseeCode[0] == '8' and self.NewLicenseeCode[1] == '0') {
            "Misawa Entertainment";
        } else if (self.NewLicenseeCode[0] == '8' and self.NewLicenseeCode[1] == '3') {
            "lozc";
        } else if (self.NewLicenseeCode[0] == '8' and self.NewLicenseeCode[1] == '6') {
            "Tokuma Shoten";
        } else if (self.NewLicenseeCode[0] == '8' and self.NewLicenseeCode[1] == '7') {
            "Tsukuda Original";
        } else if (self.NewLicenseeCode[0] == '9' and self.NewLicenseeCode[1] == '1') {
            "Chunsoft Co.";
        } else if (self.NewLicenseeCode[0] == '9' and self.NewLicenseeCode[1] == '2') {
            "Video System";
        } else if (self.NewLicenseeCode[0] == '9' and self.NewLicenseeCode[1] == '3') {
            "Ocean Software / Acclaim Entertainment";
        } else if (self.NewLicenseeCode[0] == '9' and self.NewLicenseeCode[1] == '5') {
            "Varie";
        } else if (self.NewLicenseeCode[0] == '9' and self.NewLicenseeCode[1] == '6') {
            "Yonezawa/s'pal";
        } else if (self.NewLicenseeCode[0] == '9' and self.NewLicenseeCode[1] == '7') {
            "Kaneko";
        } else if (self.NewLicenseeCode[0] == '9' and self.NewLicenseeCode[1] == '9') {
            "Pack-In-Video";
        } else if (self.NewLicenseeCode[0] == '9' and self.NewLicenseeCode[1] == 'H') {
            "Bottom Up";
        } else if (self.NewLicenseeCode[0] == 'A' and self.NewLicenseeCode[1] == '4') {
            "Konami (Yu-Gi-Oh)";
        } else if (self.NewLicenseeCode[0] == 'B' and self.NewLicenseeCode[1] == 'L') {
            "MTO";
        } else if (self.NewLicenseeCode[1] == 'D' and self.NewLicenseeCode[1] == 'K') {
            "Kodansha";
        } else {
            error.NewLicenseNotImplemented;
        };
    }

    fn OldLicense(self: *const Cartridge) ![]u8 {
        return switch (self.OldLicenseeCode) {
            0x00 => "None",
            0x01 => "Nintendo",
            0x08 => "Capcom",
            0x09 => "HOT-B",
            0x0A => "Jaleco",
            0x0B => "Coconuts Japan",
            0x0C => "Elite Systems",
            0x13 => "EA (Electronic Arts)",
            0x18 => "Hudson Soft",
            0x19 => "ITC Entertainment",
            0x1A => "Yanoman",
            0x1D => "Japan Clary",
            0x1F => "Virgin Games Ltd",
            0x24 => "PCM Complete",
            0x25 => "San-X",
            0x28 => "Kemco",
            0x29 => "SETA Corporation",
            0x30 => "Infogames",
            0x31 => "Nintendo",
            0x32 => "Bandai",
            0x34 => "Konami",
            0x35 => "HectorSoft",
            0x38 => "Capcom",
            0x39 => "Banpresto",
            0x3C => "Entertainment Interactive",
            0x3E => "Gremlin",
            0x41 => "Ubisoft",
            0x42 => "Atlus",
            0x44 => "Malibu Interactive",
            0x46 => "Angel",
            0x47 => "Spectrum HoloByte",
            0x49 => "Irem",
            0x4A => "Virgin Games Ltd",
            0x4D => "Malibu Interactive",
            0x4F => "U.S.Gold",
            0x50 => "Absolute",
            0x51 => "Acclaim Entertainment",
            0x52 => "Activision",
            0x53 => "Sammy USA Corporation",
            0x54 => "GameTek",
            0x55 => "Park Place",
            0x56 => "LJN",
            0x57 => "Matchbox",
            0x59 => "Milton Bradley Company",
            0x5A => "Mindscape",
            0x5B => "Romstar",
            0x5C => "Naxat Soft",
            0x5D => "Tradewest",
            0x60 => "Titus Interactive",
            0x61 => "Virgin Games Ltd",
            0x67 => "Ocean Software",
            0x69 => "EA (Electronic Arts)",
            0x6E => "Elite Systems",
            0x6F => "Electro Brain",
            0x70 => "Infograms",
            0x71 => "Interplay Entertainment",
            0x72 => "Broaderbund",
            0x73 => "Sculpted Software",
            0x75 => "The Saled Curve Limited",
            0x78 => "THQ",
            0x79 => "Accolade",
            0x7A => "Triffix Entertainment",
            0x7C => "MicroProse",
            0x7F => "Kemco",
            0x80 => "Misawa Entertainment",
            0x83 => "LOZC G.",
            0x86 => "Tokuma SHoten",
            0x8B => "Bullet-Proog Software",
            0x8C => "Vic Tikai Corp.",
            0x8e => "Ape Inc.",
            0x8F => "I'Max",
            0x91 => "Chunsoft Co.",
            0x92 => "Video System",
            0x93 => "Tsubaraya Productions",
            0x95 => "Varie",
            0x96 => "Yonexawa",
            0x97 => "Kemco",
            0x99 => "Arc",
            0x9A => "Nihom Bussan",
            0x9B => "Temco",
            0x9C => "Imagineer",
            0x9D => "Banpresto",
            0x9F => "Nova",
            0xA1 => "Hori Electric",
            0xA2 => "Bandai",
            0xA4 => "Konami",
            0xA6 => "Kawada",
            0xA7 => "Takara",
            0xA9 => "Technos Japan",
            0xAA => "Broderbund",
            0xAC => "Toei Animation",
            0xAD => "Toho",
            0xAF => "Namco",
            0xB0 => "Acclaim Entertainment",
            0xB1 => "ASCII Corporation / Nexsoft",
            0xB2 => "Bandai",
            0xB4 => "Square Enix",
            0xB6 => "HAL Laboratory",
            0xB7 => "SNK",
            0xB9 => "Pony Canyon",
            0xBA => "Culture Brain",
            0xBB => "Sunsoft",
            0xBD => "Sony Imagesoft",
            0xBF => "Sammy Corporation",
            0xC0 => "Taito",
            0xC2 => "Kemco",
            0xC3 => "Square",
            0xC4 => "Tokuma Shoten",
            0xC5 => "Data East",
            0xC6 => "Tokin House",
            0xC8 => "Koei",
            0xC9 => "UFL",
            0xCA => "Ultra Games",
            0xCB => "VAP, Inc",
            0xCC => "Use Corporation",
            0xCD => "Meldac",
            0xCE => "Pony Canyon",
            0xCF => "Angel",
            0xD0 => "Taito",
            0xD1 => "SOFEL (Software Engineering Lab)",
            0xD2 => "Quest",
            0xD3 => "Sigma Enterprises",
            0xD4 => "ASK Kodansha Co.",
            0xD6 => "Naxat Soft",
            0xD7 => "Copya System",
            0xD9 => "Banpresto",
            0xDA => "Tomy",
            0xDB => "LJN",
            0xDD => "Nipon Computer Systems",
            0xDE => "Human Ent.",
            0xDF => "Altron",
            0xE0 => "Jaleco",
            0xE1 => "Towa Chiki",
            0xE2 => "Yutaka",
            0xE3 => "Varie",
            0xE5 => "Epoch",
            0xE7 => "Athena",
            0xE8 => "Asmik Ace Entertainment",
            0xE9 => "Natsume",
            0xEA => "King Records",
            0xEB => "Atlus",
            0xEC => "Epic/Sony Records",
            0xEE => "IGS",
            0xF0 => "A Wave",
            0xF3 => "Extreme Entertainment",
            0xFF => "LJN",
            else => error.OldLicenceNotImplemented,
        };
    }

    pub fn RomSize(self: *const Cartridge) u32 {
        // (1024 * 32) * (1 << cartridgeBytes[0x148]),
        var shiftee = 1;
        var k = 0;
        while (k < self.romSize) : (k += 1) {
            shiftee = shiftee << k;
        }

        return (1024 * 32) * shiftee;
    }

    pub fn String(self: *const Cartridge, allocator: std.mem.Allocator) ![]u8 {
        var list = std.ArrayList(u8).init(allocator);
        try list.appendSlice("Title: ");
        std.debug.print("{any}", .{self.Title.len});
        try list.appendSlice(&self.Title);
        try list.appendSlice("\n");

        return list.items;
    }
};

//TODO: Move byte constant addresses to actual consants with names
pub fn New(cartridgeBytes: []u8) *Cartridge {
    var cartridge = Cartridge{
        .Title = cartridgeBytes[0x134..(0x143 + 1)].*, //TODO Trim Zeroes
        .ManufacturerCode = cartridgeBytes[0x13F..(0x142 + 1)].*, //Unsure how to check if this is an actual thing, docs say may be part of title
        .NewLicenseeCode = cartridgeBytes[0x144..0x146].*, //Actually 0x145 but add one as not inclusive
        .OldLicenseeCode = cartridgeBytes[0x014B],
        .romSize = cartridgeBytes[0x148],
        .CartrigeType = cartridgeBytes[0x0147],
    };

    return &cartridge;
}

//TODO: Add tests harcoding the example.gb file in bytes to a zig file
