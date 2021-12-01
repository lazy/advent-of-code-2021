const std = @import("std");

const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const allocator = std.heap.c_allocator;

const Reader = struct {
    const Self = @This();

    buf: [3]i32,
    idx: u32,

    pub fn new() Reader {
        return Self{ .idx = 0, .buf = .{ 0, 0, 0 } };
    }

    pub fn next(self: *Self) !?i32 {
        if (try readInt()) |val| {
            self.buf[self.idx] = val;
            self.idx = (self.idx + 1) % 3;
            return self.buf[0] + self.buf[1] + self.buf[2];
        }

        return null;
    }

    fn readInt() !?i32 {
        if (try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(usize))) |line| {
            defer allocator.free(line);
            return try std.fmt.parseInt(i32, line, 10);
        }

        return null;
    }
};

pub fn main() !void {
    var reader = Reader.new();
    _ = try reader.next();
    _ = try reader.next();
    if (try reader.next()) |initVal| {
        var prevVal = initVal;
        var count: i32 = 0;
        while (try reader.next()) |val| {
            if (val > prevVal) {
                count += 1;
            }
            prevVal = val;
        }

        try std.fmt.format(stdout, "{0}\n", .{count});
    }
}
