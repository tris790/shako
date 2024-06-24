const std = @import("std");
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "shako",

        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const assets_dep = b.dependency("assets", .{
        .target = target,
        .optimize = optimize,
    });
    const assets_path = assets_dep.path(".");
    const assets_install_dir = b.addInstallDirectory(.{
        .source_dir = assets_path,
        .install_dir = .{ .bin = {} },
        .install_subdir = "assets",
        .exclude_extensions = &.{},
    });
    b.default_step.dependOn(&assets_install_dir.step);

    const raylib_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
    });
    const raylib = raylib_dep.artifact("raylib");

    exe.linkLibC();
    exe.linkLibrary(raylib);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
