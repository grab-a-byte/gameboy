const std = @import("std");

const nop = 0b00000000;
const rlca = 0b00000111;
const rrca = 0b00001111;
const rla = 0b00010111;
const rra = 0b00011111;
const daa = 0b00100111;
const cpl = 0b00101111;
const scf = 0b00110111;
const ccf = 0b00111111;

const add_imm = 0b11000110;
const adc_imm = 0b11001110;
const sub_imm = 0b11010110;
const sbc_imm = 0b11011110;
const and_imm = 0b11100110;
const xor_imm = 0b11101110;
const or_imm = 0b11110110;
const cp_imm = 0b11111110;

pub fn getArithmaticOperand(value: u8) u3 {
    return @truncate(value & 0b00000111);
}

test "get arithmatic operand" {
    const expect = std.testing.expect;

    const testValues = [_]u8{
        0b00000111,
        0b00000000,
        0b00000001,
        0b00000010,
        0b00000011,
    };
    const testAnswers = [_]u8{ 7, 0, 1, 2, 3 };

    for (0..testValues.len) |index| {
        const result = getArithmaticOperand(testValues[index]);
        std.debug.print("result: {}, {}\n", .{result, testAnswers[index]});
        std.debug.print("{}", .{index});
        try expect(result == testAnswers[index]);
    }
}
