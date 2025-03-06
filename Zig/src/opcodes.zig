const std = @import("std");

const Instruction = struct { str: []const u8, length: u8 };

const r8Map = [8][]const u8{ "b", "c", "d", "e", "h", "l", "[hl]", "a" };
const r16Map = [4][]const u8{ "bc", "de", "hl", "sp" };
const r16MemMap = [4][]const u8{ "bc", "de", "hl+", "hl-" };
const condMap = [4][]const u8{ "nz", "z", "nc", "c" };

pub fn disassembleInstruction(allocator: std.mem.Allocator, bytes: []const u8) !Instruction {
    const instruction = bytes[0];
    return switch (instruction) {
        //nop
        0x00 => .{ .str = "nop", .length = 1 },

        //ld r16 imm16
        0x01, 0x11, 0x21, 0x31 => {
            const register: u2 = @truncate(instruction >> 4);
            const regName = r16Map[register];
            const val: u16 = (bytes[1] << 4) + (bytes[2]);
            const ins = try std.fmt.allocPrint(allocator, "ld {s}, {d}", .{ regName, val });
            return .{ .str = ins, .length = 3 };
        },

        //ld [r16mem], a
        0x02, 0x12, 0x22, 0x32 => {
            const register: u2 = @truncate(instruction >> 4);
            const regName = r16MemMap[register];
            const ins = try std.fmt.allocPrint(allocator, "ld [{s}], a", .{regName});
            return .{ .str = ins, .length = 1 };
        },

        //ld a, [r16mem]
        0x0A, 0x1A, 0x2A, 0x3A => {
            const param: u2 = @truncate(instruction >> 4);
            const paramName = r16MemMap[param];
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
            const paramName = r16Map[param];
            const ins = try std.fmt.allocPrint(allocator, "inc {s}", .{paramName});
            return .{ .str = ins, .length = 1 };
        },

        //dec r16
        0x0B, 0x1B, 0x2B, 0x3B => {
            const param: u2 = @truncate(instruction >> 4);
            const paramName = r16Map[param];
            const ins = try std.fmt.allocPrint(allocator, "dec {s}", .{paramName});
            return .{ .str = ins, .length = 1 };
        },

        //add hl, r16
        0x09, 0x19, 0x29, 0x39 => {
            const param: u2 = @truncate(instruction >> 4);
            const paramName = r16Map[param];
            const ins = try std.fmt.allocPrint(allocator, "add hl, {s}", .{paramName});
            return .{ .str = ins, .length = 1 };
        },

        // inc r8
        0x04, 0x14, 0x24, 0x34, 0x0C, 0x1C, 0x2C, 0x3C => {
            const param: u3 = @truncate(instruction >> 3);
            const paramName = r8Map[param];
            const ins = try std.fmt.allocPrint(allocator, "inc {s}", paramName);
            return .{ .str = ins, .length = 1 };
        },

        //dec r8
        0x05, 0x15, 0x25, 0x35, 0x0D, 0x1D, 0x2D, 0x3D => {
            const param: u3 = @truncate(instruction >> 3);
            const paramName = r8Map[param];
            const ins = try std.fmt.allocPrint(allocator, "dec {s}", paramName);
            return .{ .str = ins, .length = 1 };
        },

        //ld r8, imm8
        0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E => {
            const param: u3 = @truncate(instruction >> 3);
            const paramName = r8Map[param];
            const value = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "ld {s}, {d}", .{ paramName, value });
            return .{ .str = ins, .length = 2 };
        },

        //rlca
        0x07 => return .{ .str = "rlca", .length = 1 },

        //rrca
        0x0F => return .{ .str = "rrca", .length = 1 },

        //rla
        0x17 => return .{ .str = "rla", .length = 1 },

        // rra
        0x1F => return .{ .str = "rra", .length = 1 },

        // daa
        0x27 => return .{ .str = "daa", .length = 1 },

        //cpl
        0x2F => return .{ .str = "cpl", .length = 1 },

        //scf
        0x37 => return .{ .str = "scf", .length = 1 },

        //ccf
        0x18 => return .{ .str = "ccf", .length = 1 },

        //jr imm8
        0x18 => {
            const val = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "jr {d}", .{val});
            return .{ .str = ins, .length = 2 };
        },

        //jr cond imm8
        0x20, 0x30, 0x28, 0x38 => {
            const cond: u2 = @truncate(instruction >> 3);
            const condName = condMap[cond];
            const val = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "jr {s}, {d}", .{ condName, val });
            return .{ .str = ins, .length = 2 };
        },

        //stop
        0x10 => return .{ .str = "stop", .length = 1 },

        //ld r8 r8
        0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F, 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5A, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F, 0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x77, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7E, 0x7F => {
            const src: u3 = @truncate(instruction >> 3);
            const dest: u3 = @truncate(instruction);
            const srcName = r8Map[src];
            const destName = r8Map[dest];
            const ins = std.fmt.allocPrint(allocator, "ld {s}, {s}", .{ srcName, destName });
            return .{ .str = ins, .lenth = 1 };
        },

        //halt
        0x76 => return .{ .str = "halt", .length = 1 },

        //add a, r8
        0x80, 0x81, 0x82, 0x8B, 0x8C, 0x8D, 0x8E, 0x8F => {
            const operand: u3 = @truncate(instruction);
            const operandName = r8Map[operand];
            const ins = try std.fmt.allocPrint(allocator, "add a, {s}", .{operandName});
            return .{ .str = ins, .length = 1 };
        },

        //adc a, r8
        0x88, 0x89, 0x8A, 0x8B, 0x8C, 0x8D, 0x8E, 0x8F => {
            const operand: u3 = @truncate(instruction);
            const operandName = r8Map[operand];
            const ins = try std.fmt.allocPrint(allocator, "adc a, {s}", .{operandName});
            return .{ .str = ins, .length = 1 };
        },

        //sub a, r8
        0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97 => {
            const operand: u3 = @truncate(instruction);
            const operandName = r8Map[operand];
            const ins = try std.fmt.allocPrint(allocator, "sub a, {s}", .{operandName});
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
