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

fn getr16MemName(val: u2) []const u8 {
    return switch (val) {
        0 => "bc",
        1 => "de",
        2 => "hl+",
        3 => "hl-"
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

        //ld [r16mem], a
        0x02, 0x12, 0x22, 0x32 => {
            const register: u2 = @truncate(instruction >> 4);
            const regName = getr16MemName(register);
            const ins = try std.fmt.allocPrint(allocator, "ld [{s}], a", .{regName});
            return .{ .str = ins, .length = 1 };
        },

        //ld a, [r16mem]
        0x0A, 0x1A, 0x2A, 0x3A => {
            const param: u2 = @truncate(instruction >> 4);
            const paramName = getr16MemName(param);
            const ins = try std.fmt.allocPrint(allocator, "ld a, [{s}]", .{paramName});
            return .{ .str = ins, .length = 1 };
        },

        //ls [imm16], sp
        0x08 => {
            const val: u16 = (bytes[1] << 4) + (bytes[2]);
            const ins = try std.fmt.allocPrint(allocator, "ls [{d}], sp", .{val});
            return .{ .str = ins, .length = 3 };
        },

        //inc r16
        0x03, 0x13, 0x23, 0x33 => {
            const param: u2 = @truncate(instruction >> 4);
            const paramName = getR16Name(param);
            const ins = try std.fmt.allocPrint(allocator, "inc {s}", .{paramName});
            return .{ .str = ins, .length = 1 };
        },

        //dec r16
        0x0B, 0x1B, 0x2B, 0x3B => {
            const param: u2 = @truncate(instruction >> 4);
            const paramName = getR16Name(param);
            const ins = try std.fmt.allocPrint(allocator, "dec {s}", .{paramName});
            return .{ .str = ins, .length = 1 };
        },

        //add hl, r16
        0x09, 0x19, 0x29, 0x39 => {
            const param: u2 = @truncate(instruction >> 4);
            const paramName = getR16Name(param);
            const ins = try std.fmt.allocPrint(allocator, "add hl, {s}", .{paramName});
            return .{ .str = ins, .length = 1 };
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
