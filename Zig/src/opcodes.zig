const std = @import("std");

const Instruction = struct { str: []const u8, length: u8 };

fn getR16Name(val: u2) []const u8 {
    return switch (val) {
        0 => "bc",
        1 => "de",
        2 => "hl",
        3 => "sp",
    };
}

pub fn disassembleInstruction(allocator: std.mem.Allocator, bytes: []const u8) !Instruction {
    const instruction = bytes[0];
    return switch (instruction) {
        //nop
        0x00 => .{ .str = "nop", .length = 1 },
        //ld r16 imm16
        0x01, 0x11, 0x21, 0x31 => {
            const register: u2 = @truncate(instruction >> 4);
            const regName = getR16Name(register);
            const val: u16 = (bytes[1] << 4) + (bytes[2]);
            const ins = try std.fmt.allocPrint(allocator, "ld {s}, {d}", .{ regName, val });
            return .{ .str = ins, .length = 3 };
        },
        else => unreachable,
    };
}

test "dissassemble instruction" {
    const expect = std.testing.expect;
    const instructions = [_]u8{0x00};
    const nop = try disassembleInstruction(std.testing.allocator, instructions[0..]);
    try expect(std.mem.eql(u8, nop.str, "nop"));
    try expect(nop.length == 1);
}
