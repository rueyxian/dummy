const std = @import("std");
const testing = std.testing;
const print = std.debug.print;
const fmt = std.fmt;
const Allocator = std.mem.Allocator;

// pub fn funny(name: []const u8) void {
//     print("funny {s}\n", .{name});
// }

pub fn funny(allocator: Allocator, name: []const u8) ![]u8 {
    return fmt.allocPrint(allocator, "funny: {s}", .{name});
}

test "basic" {
    const allocator = testing.allocator;

    {
        const s = try funny(allocator, "foo");
        defer allocator.free(s);
        try testing.expectEqualSlices(u8, s, "funny: foo");
    }
    {
        const s = try funny(allocator, "bar");
        defer allocator.free(s);
        try testing.expectEqualSlices(u8, s, "funny: bar");
    }
}
