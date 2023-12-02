const std = @import("std");

const GameSettings = struct {
    maxRed: u32,
    maxGreen: u32,
    maxBlue: u32,
};

fn processShow(game: u32, show: []const u8, gs: GameSettings) !bool {
    var dices = std.mem.split(u8, show, ",");
    while (dices.next()) |dice| {
        var diceTrimmed = std.mem.trim(u8, dice, " ");
        var diceIt = std.mem.split(u8, diceTrimmed, " ");
        var num = diceIt.next() orelse "";
        var color = diceIt.next() orelse "";
        var numInt = try std.fmt.parseInt(u32, num, 10);
        // std.debug.print("{s} {s}=={d}\n", .{ color, num, numInt });
        if (std.mem.eql(u8, color, "red")) {
            if (numInt > gs.maxRed) {
                std.debug.print("Game {d} is not valid as red is show {d} times\n", .{ game, numInt });
                return false;
            }
        } else if (std.mem.eql(u8, color, "green")) {
            if (numInt > gs.maxGreen) {
                std.debug.print("Game {d} is not valid as green is show {d} times\n", .{ game, numInt });
                return false;
            }
        } else if (std.mem.eql(u8, color, "blue")) {
            if (numInt > gs.maxBlue) {
                std.debug.print("Game {d} is not valid as blue is show {d} times\n", .{ game, numInt });
                return false;
            }
        } else {
            std.debug.print("Unknown color {s}\n", .{color});
        }
    }
    return true;
}

fn processLine(line: []u8, gs: GameSettings) !u32 {
    var it = std.mem.split(u8, line, ":");
    var game = it.first();
    var dices = it.rest();
    if (!std.mem.startsWith(u8, game, "Game ")) {
        return error.InvalidChar;
    }
    var gameno = try std.fmt.parseInt(u32, game[5..], 10);

    std.debug.print("Processing line {d}\n", .{gameno});

    var shows = std.mem.split(u8, dices, ";");
    while (shows.next()) |show| {
        var result = try processShow(gameno, show, gs);
        std.debug.print("Game {d} is valid: {}\n", .{ gameno, result });
        if (!result) {
            return 0;
        }
    }
    return gameno;
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
    var numInvalid: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        numInvalid += try processLine(line, gs);
    }
    std.debug.print("Sum of valid: {d}\n", .{numInvalid});
}
