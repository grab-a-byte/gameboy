const std = @import("std");
const cartridge = @import("cartridge.zig");

const allocator = std.heap.page_allocator;

pub fn main() !void {
    const bytes = try std.fs.cwd().readFileAlloc(allocator, "example.gb", 1024 * 200);

    const cart = cartridge.New(bytes);
    std.debug.print("{s}\n", .{cart.Title});
}
