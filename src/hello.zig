const std = @import("std");
const testing = std.testing;
const print = std.debug.print;
const fmt = std.fmt;
const Allocator = std.mem.Allocator;

const test_zon = @import("test_zon");

pub fn hello(allocator: Allocator, name: []const u8) ![]u8 {
    const counter = test_zon.static_counter();
    return fmt.allocPrint(allocator, "{}: hello: {s}", .{ counter.fetch_bump(), name });
}

test "basic" {
    const allocator = testing.allocator;

    {
        const s = try hello(allocator, "foo");
        defer allocator.free(s);
        try testing.expectEqualSlices(u8, s, "0: hello: foo");
    }
    {
        const s = try hello(allocator, "bar");
        defer allocator.free(s);
        try testing.expectEqualSlices(u8, s, "1: hello: bar");
    }
    {
        const s = try hello(allocator, "baz");
        defer allocator.free(s);
        try testing.expectEqualSlices(u8, s, "2: hello: baz");
    }
}
