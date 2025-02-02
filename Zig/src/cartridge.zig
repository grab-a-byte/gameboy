const Cartridge = struct {
    EntryPoint: [4]u8,
    NintendoLogo: [48]u8,
    Title: [16]u8,
    ManufacturerCode: [4]u8,
    CgbFlag: bool,
    NewLicenseeCode: [2]u8,
    SgbFlag: bool,
    CartrigeType: u8,
    RomSize: u8,
    RamSize: u8,
    DestinationCode: u8,
    OldLicenseeCode: u8,
    MaskRomVersionNumber: u8,
    HeaderChecksum: u8,
    GlobalChecksum: [2]u8,

    pub fn Destination(self: *Cartridge) ![]u8 {
        return if (self.DestinationCode == 0) "Japan" else "Overseas";
    }

    pub fn LicenseeCode(self: * const Cartridge) ![]u8 {
        return if (self.OldLicenseeCode == 33) self.NewLicense() else self.OldLicense();
    }

    fn NewLicense() ![]u8 {
        return error.NewLicenseNotImplemented;
    }

    fn OldLicense() ![]u8 {
        return error.OldLicenceNotImplemented;
    }
};

//TODO: Move byte constant addresses to actual consants with names
pub fn New(cartridgeBytes: []u8) Cartridge {
    var cartridge: Cartridge = undefined;
    cartridge.NintendoLogo = cartridgeBytes[0x104..(0x133 + 1)].*;
    cartridge.Title = cartridgeBytes[0x134..(0x143 + 1)].*; //TODO Trim Zeroes
    cartridge.ManufacturerCode = cartridgeBytes[0x13F..(0x142 + 1)].*; //Unsure how to check if this is an actual thing, docs say may be part of title
    cartridge.CgbFlag = if (cartridgeBytes[0x143] == 0xC0) true else false;
    cartridge.NewLicenseeCode = cartridgeBytes[0x144..0x146].*; //Actually 0x145 but add one as not inclusive
    cartridge.SgbFlag = if (cartridgeBytes[0x146] == 0x03) true else false;
    return cartridge;
}

//TODO: Add tests harcoding the example.gb file in bytes to a zig file
