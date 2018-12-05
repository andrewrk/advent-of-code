const std = @import("std");

pub fn main() void {
    std.debug.warn("{}\n", scan(main_input[0..]));
}

test "sample inputs" {
    var sample_input = "dabAcCaCBAcCcaDA";
    const result = scan(sample_input[0..]);
    std.debug.assert(result == 10);
}

fn scan(polymers: []u8) usize {
    var prev_i: usize = 0;
    var i: usize = 1;
    var unit_count = polymers.len;
    while (i < polymers.len) : (i += 1) {
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
    }
    return unit_count;
}

fn react(a: u8, b: u8) bool {
    return switch (a) {
        'a'...'z' => b >= 'A' and b - 'A' == a - 'a',
        'A'...'Z' => b >= 'a' and b - 'a' == a - 'A',
        else => false,
    };
}

var main_input = @embedFile("day5.txt");
