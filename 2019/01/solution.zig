const std = @import("std");

pub fn main() anyerror!void {
    var stdin_unbuf = std.io.getStdIn().inStream();
    // damn that is pretty painful, isn't it?
    const in = &std.io.BufferedInStream(@typeOf(stdin_unbuf).Error).init(&stdin_unbuf.stream).stream;

    var sum: u64 = 0;
    var line_buf: [50]u8 = undefined;
    while (try in.readUntilDelimiterOrEof(&line_buf, '\n')) |line| {
        if (line.len == 0) break;
        const module_mass = try std.fmt.parseInt(u64, line, 10);
        const fuel_required = (module_mass / 3) - 2;
        sum += fuel_required;
    }

    const out = &std.io.getStdOut().outStream().stream;
    try out.print("{}\n", sum);
}
