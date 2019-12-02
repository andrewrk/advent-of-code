const std = @import("std");

pub fn main() anyerror!void {
    var stdin_unbuf = std.io.getStdIn().inStream();
    // damn that is pretty painful, isn't it?
    const in = &std.io.BufferedInStream(@typeOf(stdin_unbuf).Error).init(&stdin_unbuf.stream).stream;

    var sum: u64 = 0;
    var line_buf: [50]u8 = undefined;
    while (try in.readUntilDelimiterOrEof(&line_buf, '\n')) |line| {
        if (line.len == 0) break;
        const module_mass = try std.fmt.parseInt(u63, line, 10);
        var extra_fuel: i64 = (module_mass / 3) - 2;
        while (extra_fuel > 0) {
            sum += @intCast(u64, extra_fuel);
            extra_fuel = @divFloor(extra_fuel, 3) - 2;
        }
    }

    const out = &std.io.getStdOut().outStream().stream;
    try out.print("{}\n", sum);
}
