const std = @import("std");
const Build = std.Build;

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const dep_test_zon = b.dependency("test_zon", .{
        .target = target,
        .optimize = optimize,
    });

    // _ = b.addModule("test-zon", .{ .source_file = .{ .path = "src/root.zig" } });
    _ = b.addModule("funny", .{ .source_file = .{ .path = "src/funny.zig" } });
    _ = b.addModule("hello", .{ .source_file = .{ .path = "src/hello.zig" } });

    const mod_funny = b.createModule(.{ .source_file = .{ .path = "src/funny.zig" } });
    const mod_hello = b.createModule(.{ .source_file = .{ .path = "src/hello.zig" } });
    _ = mod_funny;
    _ = mod_hello;

    const lib_hello = b.addStaticLibrary(.{
        .name = "hello",
        .root_source_file = .{ .path = "src/hello.zig" },
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(lib_hello);
    lib_hello.addModule("test_zon", dep_test_zon.module("test-zon"));

    const lib_funny = b.addStaticLibrary(.{
        .name = "hello",
        .root_source_file = .{ .path = "src/funny.zig" },
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(lib_funny);

    const unit_tests_hello = b.addTest(.{
        .root_source_file = .{ .path = "src/hello.zig" },
        .target = target,
        .optimize = optimize,
    });
    unit_tests_hello.addModule("test_zon", dep_test_zon.module("test-zon"));

    const unit_tests_funny = b.addTest(.{
        .root_source_file = .{ .path = "src/funny.zig" },
        .target = target,
        .optimize = optimize,
    });

    const step_tests = b.step("test", "Run unit tests");

    const run_unit_tests_hello = b.addRunArtifact(unit_tests_hello);
    const run_unit_tests_funny = b.addRunArtifact(unit_tests_funny);

    step_tests.dependOn(&run_unit_tests_hello.step);
    step_tests.dependOn(&run_unit_tests_funny.step);
}
