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
    std.debug.assert(findBestArea(sample_input) == 17);
}

pub fn main() void {
    std.debug.warn("{}\n", findBestArea(main_input));
}

const Cell = union(enum) {
    Empty,
    Coord: usize,
};

const max_grid_size = 500;
const max_coord_size = 100;
var grid: [max_grid_size][max_grid_size][max_coord_size]usize = undefined;

fn findBestArea(text: []const u8) usize {
    var max_x: usize = 0;
    var max_y: usize = 0;

    var line_it = std.mem.split(text, "\n");
    var coord_index_end: usize = 0;
    while (line_it.next()) |line| : (coord_index_end += 1) {
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
                grid[y][x][coord_index_end] = manhattan(coord_x, coord_y, x, y);
            }
        }
    }

    const end_x = max_x + 1;
    const end_y = max_y + 1;

    const Coord = union(enum) {
        Disqualified,
        Area: usize,
    };

    var coord_info = [1]Coord{Coord{ .Area = 0 }} ** max_coord_size;

    var y: usize = 0;
    while (y < end_y) : (y += 1) {
        var x: usize = 0;
        while (x < end_x) : (x += 1) {
            var smallest_dist: usize = std.math.maxInt(usize);
            var opt_best_coord: ?usize = null;
            var coord_index: usize = 0;
            while (coord_index < coord_index_end) : (coord_index += 1) {
                const this_dist = grid[y][x][coord_index];
                if (opt_best_coord) |best_coord| {
                    if (smallest_dist == this_dist) {
                        opt_best_coord = null;
                    } else if (this_dist < smallest_dist) {
                        smallest_dist = this_dist;
                        opt_best_coord = coord_index;
                    }
                } else if (this_dist < smallest_dist) {
                    opt_best_coord = coord_index;
                    smallest_dist = this_dist;
                }
            }
            if (opt_best_coord) |best_coord_index| {
                const disqualify = x == 0 or y == 0 or x == end_x - 1 or y == end_y - 1;
                if (disqualify) {
                    coord_info[best_coord_index] = Coord.Disqualified;
                } else switch (coord_info[best_coord_index]) {
                    Coord.Disqualified => {},
                    Coord.Area => |*area| area.* += 1,
                }
            }
        }
    }

    var best_area: usize = 0;
    var coord_index: usize = 0;
    while (coord_index < coord_index_end) : (coord_index += 1) {
        switch (coord_info[coord_index]) {
            Coord.Disqualified => {},
            Coord.Area => |area| best_area = std.math.max(area, best_area),
        }
    }
    return best_area;
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
