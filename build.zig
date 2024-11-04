const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const slint_dep = b.dependency("slint", .{
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addSharedLibrary(.{
        .name = "HelloVST3",
        .root_source_file = .{
            .src_path = .{
                .owner = b,
                .sub_path = "src/plugin.zig",
            },
        },
        .target = target,
        .optimize = optimize,
    });

    const slint = slint_dep.module("slint");
    lib.addObjectFile(slint.root_source_file.?);
    lib.linkLibrary(slint_dep.artifact("slint"));
    lib.linkLibC();

    b.installArtifact(lib);
}
