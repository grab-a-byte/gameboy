const std = @import("std");
const cartridge = @import("cartridge.zig");
const opcodes = @import("opcodes.zig");

const allocator = std.heap.page_allocator;

pub fn main() !void {
    const bytes = try std.fs.cwd().readFileAlloc(allocator, "example.gb", 1024 * 200);

    const cart = cartridge.New(bytes);
    const str = cart.String(allocator) catch "WARNING!";
    std.debug.print("{s}\n", .{str});
    const v = opcodes.getArithmaticOperand(0b10101010);
    std.debug.print("{d}", .{v});
}
