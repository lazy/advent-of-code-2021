const std = @import("std");

const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const allocator = std.heap.c_allocator;

const Command = union(enum) {
    forward: i32,
    down: i32,
    up: i32,
};

fn readCommand() !?Command {
    if (try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(usize))) |line| {
        defer allocator.free(line);
        var parts = std.mem.split(u8, line, " ");
        var command = parts.next() orelse return error.InvalidCommand;
        var strAmount = parts.next() orelse return error.InvalidCommand;
        var amount = try std.fmt.parseInt(i32, strAmount, 10);
        if (std.mem.eql(u8, command, "forward")) {
            return Command{ .forward = amount };
        } else if (std.mem.eql(u8, command, "down")) {
            return Command{ .down = amount };
        } else if (std.mem.eql(u8, command, "up")) {
            return Command{ .up = amount };
        } else {
            return error.InvalidCommand;
        }
    }

    return null;
}

pub fn main() !void {
    var x: i32 = 0;
    var depth: i32 = 0;
    var aim: i32 = 0;
    while (try readCommand()) |command| {
        switch (command) {
            Command.forward => |amount| {
                x = x + amount;
                depth = depth + (amount * aim);
            },
            Command.down => |amount| aim = aim + amount,
            Command.up => |amount| aim = aim - amount,
        }
    }

    try std.fmt.format(stdout, "{0}\n", .{x * depth});
}
