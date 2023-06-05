const std = @import("std");

const libtest = @cImport({
    @cInclude("libtest.h");
});

export fn zig_count_one(x: i32) callconv(.C) i32 {
    if (x <= 0) {
        return 0;
    }
    return 1 + libtest.c_count_one(x - 1);
}

export fn zig_count_two(c_count: *libtest.CCount) callconv(.C) i32 {
    if (c_count.*.x <= 0) {
        return 0;
    }

    c_count.*.x -= 1;

    return 1 + libtest.c_count_two(c_count);
}

pub fn main() !void {
    // Link a static library and call that function
    const first_count = zig_count_one(2);
    std.debug.print("Counting to 2: {d}\n", .{first_count});

    const second_count = zig_count_one(100);
    std.debug.print("Counting to 100: {d}\n", .{second_count});

    const third_count = libtest.c_start_counting(50);
    std.debug.print("Counting to 50: {d}\n", .{third_count});

    var count = libtest.CCount{ .x = 75 };
    const fourth_count = zig_count_two(&count);
    std.debug.print("Counting to 75: {d}\n", .{fourth_count});
}
