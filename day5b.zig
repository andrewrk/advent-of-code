const std = @import("std");

pub fn main() void {
    const main_input = @embedFile("day5.txt");
    std.debug.warn("{}\n", best(main_input));
}

test "sample inputs" {
    const sample_input = "dabAcCaCBAcCcaDA";
    const result = best(sample_input);
    std.debug.assert(result == 4);
}

fn best(immutable_polymers: var) usize {
    comptime std.debug.assert(@typeId(@typeOf(immutable_polymers)) == @import("builtin").TypeId.Array);
    var try_unit: usize = 0;
    var best_score: usize = std.math.maxInt(usize);
    while (try_unit < 26) : (try_unit += 1) {
        var polymers = immutable_polymers;
        var start_unit_count = polymers.len;
        for (polymers) |*elem| {
            if (unitIndex(elem.*) == try_unit) {
                elem.* = '.';
                start_unit_count -= 1;
            }
        }
        const score = scan(polymers[0..], start_unit_count);
        if (score < best_score)
            best_score = score;
    }
    return best_score;
}

fn scan(polymers: []u8, start_unit_count: usize) usize {
    var prev_i: usize = 0;
    var i: usize = 1;
    var unit_count = start_unit_count;
    while (true) {
        if (react(polymers[prev_i], polymers[i])) {
            polymers[prev_i] = '.';
            polymers[i] = '.';
            unit_count -= 2;
            while (prev_i != 0 and polymers[prev_i] == '.') prev_i -= 1;
            while (polymers[prev_i] == '.') {
                prev_i += 1;
                if (prev_i == polymers.len) return unit_count;
            }
        } else {
            prev_i = i;
        }
        while (true) {
            i += 1;
            if (i == polymers.len) return unit_count;
            if (polymers[i] != '.') break;
        }
    }
}

fn react(a: u8, b: u8) bool {
    return switch (a) {
        'a'...'z' => b >= 'A' and b - 'A' == a - 'a',
        'A'...'Z' => b >= 'a' and b - 'a' == a - 'A',
        else => false,
    };
}

fn unitIndex(x: u8) usize {
    return switch (x) {
        'a'...'z' => x - 'a',
        'A'...'Z' => x - 'A',
        else => unreachable,
    };
}
