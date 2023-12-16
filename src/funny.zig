const std = @import("std");
const testing = std.testing;
const print = std.debug.print;

pub fn funny(name: []const u8) void {
    print("funny {s}\n", .{name});
}
