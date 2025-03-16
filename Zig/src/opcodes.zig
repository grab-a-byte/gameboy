const std = @import("std");

const Instruction = struct { str: []const u8, length: u8 };

const r8Map = [8][]const u8{ "b", "c", "d", "e", "h", "l", "[hl]", "a" };
const r16Map = [4][]const u8{ "bc", "de", "hl", "sp" };
const r16StkMap = [4][]const u8{ "bc", "de", "hl", "af" };
const r16MemMap = [4][]const u8{ "bc", "de", "hl+", "hl-" };
const condMap = [4][]const u8{ "nz", "z", "nc", "c" };

fn u16LitteEndian(byte1: u8, byte2: u8) u16 {
    const val: u16 = byte1 + (@as(u16, byte2) << 8);
    return val;
}

pub fn disassembleInstruction(allocator: std.mem.Allocator, bytes: []const u8) !Instruction {
    const instruction = bytes[0];
    return switch (instruction) {
        //nop
        0x00 => .{ .str = "nop", .length = 1 },

        //ld r16 imm16
        0x01, 0x11, 0x21, 0x31 => {
            const register: u2 = @truncate(instruction >> 4);
            const regName = r16Map[register];
            const val: u16 = u16LitteEndian(bytes[1], bytes[2]);
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

        //ld [imm16], sp
        0x08 => {
            const val: u16 = u16LitteEndian(bytes[1], bytes[2]);
            const ins = try std.fmt.allocPrint(allocator, "ld [{d}], sp", .{val});
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
            const ins = try std.fmt.allocPrint(allocator, "inc {s}", .{paramName});
            return .{ .str = ins, .length = 1 };
        },

        //dec r8
        0x05, 0x15, 0x25, 0x35, 0x0D, 0x1D, 0x2D, 0x3D => {
            const param: u3 = @truncate(instruction >> 3);
            const paramName = r8Map[param];
            const ins = try std.fmt.allocPrint(allocator, "dec {s}", .{paramName});
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
        0x3F => return .{ .str = "ccf", .length = 1 },

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
            const ins = try std.fmt.allocPrint(allocator, "ld {s}, {s}", .{ srcName, destName });
            return .{ .str = ins, .length = 1 };
        },

        //halt
        0x76 => return .{ .str = "halt", .length = 1 },

        //add a, r8
        0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87 => {
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

        //sbc a, r8
        0x98, 0x99, 0x9A, 0x9B, 0x9C, 0x9D, 0x9E, 0x9F => {
            const operand: u3 = @truncate(instruction);
            const operandName = r8Map[operand];
            const ins = try std.fmt.allocPrint(allocator, "sbc a, {s}", .{operandName});
            return .{ .str = ins, .length = 1 };
        },

        //and a, r8
        0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7 => {
            const operand: u3 = @truncate(instruction);
            const operandName = r8Map[operand];
            const ins = try std.fmt.allocPrint(allocator, "and a, {s}", .{operandName});
            return .{ .str = ins, .length = 1 };
        },

        //xor a, r8
        0xA8, 0xA9, 0xAA, 0xAB, 0xAC, 0xAD, 0xAE, 0xAF => {
            const operand: u3 = @truncate(instruction);
            const operandName = r8Map[operand];
            const ins = try std.fmt.allocPrint(allocator, "xor a, {s}", .{operandName});
            return .{ .str = ins, .length = 1 };
        },

        //or a, r8
        0xB0, 0xB1, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6, 0xB7 => {
            const operand: u3 = @truncate(instruction);
            const operandName = r8Map[operand];
            const ins = try std.fmt.allocPrint(allocator, "or a, {s}", .{operandName});
            return .{ .str = ins, .length = 1 };
        },

        //cp a, r8
        0xB8, 0xB9, 0xBA, 0xBB, 0xBC, 0xBD, 0xBE, 0xBF => {
            const operand: u3 = @truncate(instruction);
            const operandName = r8Map[operand];
            const ins = try std.fmt.allocPrint(allocator, "cp a, {s}", .{operandName});
            return .{ .str = ins, .length = 1 };
        },

        //add a, imm8
        0xC6 => {
            const value = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "add a, {d}", .{value});
            return .{ .str = ins, .length = 2 };
        },

        //adc a, imm8
        0xCE => {
            const value = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "adc a, {d}", .{value});
            return .{ .str = ins, .length = 2 };
        },

        //sub a, imm8
        0xD6 => {
            const value = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "sub a, {d}", .{value});
            return .{ .str = ins, .length = 2 };
        },

        //sbc a, imm8
        0xDE => {
            const value = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "sbc a, {d}", .{value});
            return .{ .str = ins, .length = 2 };
        },

        //and a, imm8
        0xE6 => {
            const value = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "and a, {d}", .{value});
            return .{ .str = ins, .length = 2 };
        },

        //xor a, imm8
        0xEE => {
            const value = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "xor a, {d}", .{value});
            return .{ .str = ins, .length = 2 };
        },

        //or a, imm8
        0xF6 => {
            const value = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "or a, {d}", .{value});
            return .{ .str = ins, .length = 2 };
        },

        //cp a, imm8
        0xFE => {
            const value = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "cp a, {d}", .{value});
            return .{ .str = ins, .length = 2 };
        },

        //ret cond
        0xC0, 0xC8, 0xD0, 0xD8 => {
            const condVal: u2 = @truncate(instruction >> 3);
            const cond = condMap[condVal];
            const ins = try std.fmt.allocPrint(allocator, "ret {s}", .{cond});
            return .{ .str = ins, .length = 1 };
        },

        //ret
        0xC9 => return .{ .str = "ret", .length = 1 },

        //reti
        0xD9 => return .{ .str = "reti", .length = 1 },

        //jp cond imm16
        0xC2, 0xCA, 0xD2, 0xDA => {
            const cond: u2 = @truncate(instruction >> 3);
            const condName = condMap[cond];
            const val: u16 = u16LitteEndian(bytes[1], bytes[2]);
            const ins = try std.fmt.allocPrint(allocator, "jp {s}, {d}", .{ condName, val });
            return .{ .str = ins, .length = 3 };
        },

        //jp imm16
        0xC3 => {
            const val: u16 = u16LitteEndian(bytes[1], bytes[2]);
            const ins = try std.fmt.allocPrint(allocator, "jp {d}", .{val});
            return .{ .str = ins, .length = 3 };
        },

        //jp hl
        0xE9 => return .{ .str = "jp hl", .length = 1 },

        //call cond imm16
        0xC4, 0xCC, 0xD4, 0xDC => {
            const cond: u3 = @truncate(instruction >> 3);
            const condName = condMap[cond];
            const val: u16 = u16LitteEndian(bytes[1], bytes[2]);
            const ins = try std.fmt.allocPrint(allocator, "call {s}, {d}", .{ condName, val });
            return .{ .str = ins, .length = 3 };
        },

        //call imm16
        0xCD => {
            const val: u16 = u16LitteEndian(bytes[1], bytes[2]);
            const ins = try std.fmt.allocPrint(allocator, "call {d}", .{val});
            return .{ .str = ins, .length = 3 };
        },

        //rst tgt3
        0xC7, 0xCF, 0xD7, 0xDF, 0xE7, 0xEF, 0xF7, 0xFF => {
            const tgt: u3 = @truncate(instruction >> 3);
            const ins = try std.fmt.allocPrint(allocator, "rst {d}", .{tgt});
            return .{ .str = ins, .length = 1 };
        },

        //pop r16stk
        0xC1, 0xD1, 0xE1, 0xF1 => {
            const reg: u2 = @truncate(instruction >> 4);
            const regName = r16StkMap[reg];
            const ins = try std.fmt.allocPrint(allocator, "pop {s}", .{regName});
            return .{ .str = ins, .length = 1 };
        },

        //push r16stk
        0xC5, 0xD5, 0xE5, 0xF5 => {
            const reg: u2 = @truncate(instruction >> 4);
            const regName = r16StkMap[reg];
            const ins = try std.fmt.allocPrint(allocator, "push {s}", .{regName});
            return .{ .str = ins, .length = 1 };
        },

        //prefix
        0xCB => {
            const operand: u3 = @truncate(bytes[1]);
            switch (bytes[1]) {
                //rlc r8
                0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07 => {
                    const regName = r8Map[operand];
                    const ins = try std.fmt.allocPrint(allocator, "rlc {s}", .{regName});
                    return .{ .str = ins, .length = 2 };
                },

                //rrc r8
                0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F => {
                    const regName = r8Map[operand];
                    const ins = try std.fmt.allocPrint(allocator, "rrc {s}", .{regName});
                    return .{ .str = ins, .length = 2 };
                },

                //rl r8
                0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17 => {
                    const regName = r8Map[operand];
                    const ins = try std.fmt.allocPrint(allocator, "rl {s}", .{regName});
                    return .{ .str = ins, .length = 2 };
                },

                // rr r8
                0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F => {
                    const regName = r8Map[operand];
                    const ins = try std.fmt.allocPrint(allocator, "rr {s}", .{regName});
                    return .{ .str = ins, .length = 2 };
                },

                //sla r8
                0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27 => {
                    const regName = r8Map[operand];
                    const ins = try std.fmt.allocPrint(allocator, "sla {s}", .{regName});
                    return .{ .str = ins, .length = 2 };
                },

                //sra r8
                0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F => {
                    const regName = r8Map[operand];
                    const ins = try std.fmt.allocPrint(allocator, "sra {s}", .{regName});
                    return .{ .str = ins, .length = 2 };
                },

                //swap r8
                0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37 => {
                    const regName = r8Map[operand];
                    const ins = try std.fmt.allocPrint(allocator, "swap {s}", .{regName});
                    return .{ .str = ins, .length = 2 };
                },

                //srl r8
                0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F => {
                    const regName = r8Map[operand];
                    const ins = try std.fmt.allocPrint(allocator, "srl {s}", .{regName});
                    return .{ .str = ins, .length = 2 };
                },

                //bit b3, r8
                0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F, 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5A, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F, 0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7E, 0x7F => {
                    const bitIndex: u3 = @truncate(bytes[1] >> 3);
                    const operandName = r8Map[operand];
                    const ins = try std.fmt.allocPrint(allocator, "bit {d}, {s}", .{ bitIndex, operandName });
                    return .{ .str = ins, .length = 2 };
                },

                //res b3, r8
                0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8A, 0x8B, 0x8C, 0x8D, 0x8E, 0x8F, 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9A, 0x9B, 0x9C, 0x9D, 0x9E, 0x9F, 0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9, 0xAA, 0xAB, 0xAC, 0xAD, 0xAE, 0xAF, 0xB0, 0xB1, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6, 0xB7, 0xB8, 0xB9, 0xBA, 0xBB, 0xBC, 0xBD, 0xBE, 0xBF => {
                    const bitIndex: u3 = @truncate(bytes[1] >> 3);
                    const operandName = r8Map[operand];
                    const ins = try std.fmt.allocPrint(allocator, "res {d}, {s}", .{ bitIndex, operandName });
                    return .{ .str = ins, .length = 2 };
                },

                //set b3, r8
                0xC0, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9, 0xCA, 0xCB, 0xCC, 0xCD, 0xCE, 0xCF, 0xD0, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA, 0xDB, 0xDC, 0xDD, 0xDE, 0xDF, 0xE0, 0xE1, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, 0xE7, 0xE8, 0xE9, 0xEA, 0xEB, 0xEC, 0xED, 0xEE, 0xEF, 0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7, 0xF8, 0xF9, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF => {
                    const bitIndex: u3 = @truncate(bytes[1] >> 3);
                    const operandName = r8Map[operand];
                    const ins = try std.fmt.allocPrint(allocator, "set {d}, {s}", .{ bitIndex, operandName });
                    return .{ .str = ins, .length = 2 };
                },
            }
        },

        //ldh [c], a
        0xE2 => return .{ .str = "ldh [c], a", .length = 1 },

        //ldh [imm8], a
        0xE0 => {
            const val = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "ldh {d}, a", .{val});
            return .{ .str = ins, .length = 2 };
        },

        //ld [imm16], a
        0xEA => {
            const val = u16LitteEndian(bytes[1], bytes[2]);
            const ins = try std.fmt.allocPrint(allocator, "ld {d}, a", .{val});
            return .{ .str = ins, .length = 3 };
        },

        //ldh a, [c]
        0xF2 => return .{ .str = "ldh a, [c]", .length = 1 },

        //ldh a, [imm8]
        0xF0 => {
            const val = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "ldh a, {d}", .{val});
            return .{ .str = ins, .length = 2 };
        },

        //ldh a, [imm16]
        0xFA => {
            const val = u16LitteEndian(bytes[1], bytes[2]);
            const ins = try std.fmt.allocPrint(allocator, "ldh a, {d}", .{val});
            return .{ .str = ins, .length = 3 };
        },

        //add sp imm8
        0xE8 => {
            const val = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "add sp, {d}", .{val});
            return .{ .str = ins, .length = 2 };
        },

        //ld hl, sp + imm8
        0xF8 => {
            const val = bytes[1];
            const ins = try std.fmt.allocPrint(allocator, "ld hl, sp + {d}", .{val});
            return .{ .str = ins, .length = 2 };
        },

        //ld sp, hl
        0xF9 => return .{ .str = "ld sp, hl", .length = 1 },

        //di
        0xF3 => return .{ .str = "di", .length = 1 },

        //ei
        0xFB => return .{ .str = "ei", .length = 1 },

        //invlid opcodes
        0xD3, 0xDB, 0xDD, 0xE3, 0xE4, 0xEB, 0xEC, 0xED, 0xF4, 0xFC, 0xFD => return .{ .str = "CPU Hard Locked", .length = 1 },
    };
}

test "dissassemble single byte instruction" {
    const expect = std.testing.expect;
    const instructions = [_]u8{
        0b00000000,
        0b00000111,
        0b00001111,
        0b00010111,
        0b00011111,
        0b00100111,
        0b00101111,
        0b00110111,
        0b00111111,
        0b00010000,
        0b01110110,
        0b11001001,
        0b11011001,
        0b11101001,
        0b11100010,
        0b11110010,
        0b11111001,
        0b11110011,
        0b11111011,
    };

    const expected = [_][]const u8{
        "nop",
        "rlca",
        "rrca",
        "rla",
        "rra",
        "daa",
        "cpl",
        "scf",
        "ccf",
        "stop",
        "halt",
        "ret",
        "reti",
        "jp hl",
        "ldh [c], a",
        "ldh a, [c]",
        "ld sp, hl",
        "di",
        "ei",
    };

    for (0..instructions.len) |index| {
        const diss = try disassembleInstruction(std.testing.allocator, instructions[index..]);
        try expect(std.mem.eql(u8, diss.str, expected[index]));
        try expect(diss.length == 1);
    }
}

test "Arithmatic Dissassembly" {}
