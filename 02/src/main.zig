const std = @import("std");

const GameSettings = struct {
    maxRed: u32,
    maxGreen: u32,
    maxBlue: u32,
};

const DiceCount = struct {
    red: u32 = 0,
    green: u32 = 0,
    blue: u32 = 0,

    fn maxWith(self: *DiceCount, other: *DiceCount) void {
        self.red = @max(self.red, other.red);
        self.green = @max(self.green, other.green);
        self.blue = @max(self.blue, other.blue);
    }
};

fn processShow(show: []const u8) !DiceCount {
    var dices = std.mem.split(u8, show, ",");
    var counts = DiceCount{};
    while (dices.next()) |dice| {
        var diceTrimmed = std.mem.trim(u8, dice, " ");
        var diceIt = std.mem.split(u8, diceTrimmed, " ");
        var num = diceIt.next() orelse "";
        var color = diceIt.next() orelse "";
        var numInt = try std.fmt.parseInt(u32, num, 10);
        // std.debug.print("{s} {s}=={d}\n", .{ color, num, numInt });
        if (std.mem.eql(u8, color, "red")) {
            counts.red = numInt;
        } else if (std.mem.eql(u8, color, "green")) {
            counts.green = numInt;
        } else if (std.mem.eql(u8, color, "blue")) {
            counts.blue = numInt;
        } else {
            std.debug.print("Unknown color {s}\n", .{color});
        }
    }
    return counts;
}

fn processLine(line: []u8, gs: GameSettings) !u32 {
    _ = gs;
    var it = std.mem.split(u8, line, ":");
    var game = it.first();
    var dices = it.rest();
    if (!std.mem.startsWith(u8, game, "Game ")) {
        return error.InvalidChar;
    }
    var gameno = try std.fmt.parseInt(u32, game[5..], 10);

    std.debug.print("Processing line {d}\n", .{gameno});

    var shows = std.mem.split(u8, dices, ";");
    var maxDices = DiceCount{};
    while (shows.next()) |show| {
        var result = try processShow(show);
        maxDices.maxWith(&result);
    }
    return maxDices.red * maxDices.green * maxDices.blue;
}

pub fn main() !void {
    var gs = GameSettings{
        .maxRed = 12,
        .maxGreen = 13,
        .maxBlue = 14,
    };

    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var sumOfPower: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        sumOfPower += try processLine(line, gs);
    }
    std.debug.print("Sum of power: {d}\n", .{sumOfPower});
}
