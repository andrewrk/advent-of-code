const std = @import("std");

test "sample input" {
    const sample_input =
        \\1, 1
        \\1, 6
        \\8, 3
        \\3, 4
        \\5, 5
        \\8, 9
    ;
    std.debug.assert(findBestArea(sample_input, 32) == 16);
}

pub fn main() void {
    std.debug.warn("{}\n", findBestArea(main_input, 10000));
}

const max_grid_size = 500;
var grid: [max_grid_size][max_grid_size]usize = undefined;

fn findBestArea(text: []const u8, dist_upper_bound: usize) usize {
    var max_x: usize = 0;
    var max_y: usize = 0;

    for (grid) |*row| {
        std.mem.set(usize, row, 0);
    }

    var line_it = std.mem.split(text, "\n");
    while (line_it.next()) |line| {
        var coord_it = std.mem.split(line, ", ");
        const coord_x = std.fmt.parseInt(usize, coord_it.next().?, 10) catch unreachable;
        const coord_y = std.fmt.parseInt(usize, coord_it.next().?, 10) catch unreachable;
        std.debug.assert(coord_x < max_grid_size);
        std.debug.assert(coord_y < max_grid_size);

        max_x = std.math.max(max_x, coord_x);
        max_y = std.math.max(max_y, coord_y);

        var y: usize = 0;
        while (y < max_grid_size) : (y += 1) {
            var x: usize = 0;
            while (x < max_grid_size) : (x += 1) {
                grid[y][x] += manhattan(coord_x, coord_y, x, y);
            }
        }
    }

    const end_x = max_x + 1;
    const end_y = max_y + 1;

    var count: usize = 0;
    var y: usize = 0;
    while (y < end_y) : (y += 1) {
        var x: usize = 0;
        while (x < end_x) : (x += 1) {
            if (grid[y][x] < dist_upper_bound) {
                count += 1;
            }
        }
    }

    return count;
}

fn manhattan(x1: usize, y1: usize, x2: usize, y2: usize) usize {
    return (if (x1 > x2) x1 - x2 else x2 - x1) +
        (if (y1 > y2) y1 - y2 else y2 - y1);
}

const main_input =
    \\341, 330
    \\85, 214
    \\162, 234
    \\218, 246
    \\130, 67
    \\340, 41
    \\206, 342
    \\232, 295
    \\45, 118
    \\93, 132
    \\258, 355
    \\187, 302
    \\181, 261
    \\324, 246
    \\150, 203
    \\121, 351
    \\336, 195
    \\44, 265
    \\51, 160
    \\63, 133
    \\58, 117
    \\109, 276
    \\292, 241
    \\81, 56
    \\281, 284
    \\226, 104
    \\98, 121
    \\178, 234
    \\319, 332
    \\279, 234
    \\143, 163
    \\109, 333
    \\80, 188
    \\106, 242
    \\65, 59
    \\253, 137
    \\287, 317
    \\185, 50
    \\193, 132
    \\96, 319
    \\193, 169
    \\100, 155
    \\113, 161
    \\182, 82
    \\157, 148
    \\132, 67
    \\339, 296
    \\243, 208
    \\196, 234
    \\87, 335
;
