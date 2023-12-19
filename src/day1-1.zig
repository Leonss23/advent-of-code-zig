const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn run() void {
    const input_filename = "./input/1";

    const input = @embedFile(input_filename);

    var iter = comptime std.mem.split(u8, input[0 .. input.len - 1], "\n");

    const sum: usize = blk: {
        var sum: usize = 0;
        while (iter.next()) |line| {
            const digits = [2]u8{ findFirstDigit(line, .asc), findFirstDigit(line, .desc) };
            sum += std.fmt.parseUnsigned(usize, &digits, 10) catch unreachable;
        }
        break :blk sum;
    };

    const answer = comptime sum;
    stdout.print("Answer: {any}", .{answer}) catch unreachable;
}

/// Returns the first digit in a string as a character
fn findFirstDigit(str: []const u8, comptime order: enum { asc, desc }) u8 {
    var idx: usize = switch (order) {
        .asc => 0,
        .desc => str.len - 1,
    };

    while (idx < str.len and idx >= 0) : (switch (order) {
        .asc => idx += 1,
        .desc => idx -= 1,
    }) {
        const char = str[idx];

        switch (char) {
            '0'...'9' => return char,
            else => continue,
        }
    } else unreachable; // found line without digits
}
