const std = @import("std");
const testing = std.testing;
const print = std.debug.print;

export fn hello(name: []const u8) void {
    print("{}\n", .{name});
}
