const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "lib-link-test",
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
    });
    lib.addCSourceFile("c/libtest.c", &[_][]const u8{"-std=c99"});

    const exe = b.addExecutable(.{
        .name = "link-test",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibrary(lib);
    exe.addIncludePath("c/");
    exe.step.dependOn(&lib.step);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
