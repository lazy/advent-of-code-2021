const std = @import("std");

const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const allocator = std.heap.c_allocator;

fn readInt() !?i32 {
    if (try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(usize))) |line| {
        defer allocator.free(line);
        return try std.fmt.parseInt(i32, line, 10);
    }

    return null;
}

pub fn main() !void {
    var prevVal: i32 = std.math.maxInt(i32);
    var count: i32 = 0;
    while (try readInt()) |val| {
        if (val > prevVal) {
            count += 1;
        }
        prevVal = val;
    }

    try std.fmt.format(stdout, "{0}\n", .{count});
}
