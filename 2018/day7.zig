const std = @import("std");

pub fn main() !void {
    const stdout = try std.io.getStdOut();
    const stream = &stdout.outStream().stream;
    try order(stream, input_text);
    try stream.writeByte('\n');
}

test "sample input" {
    const sample_text =
        \\Step C must be finished before step A can begin.
        \\Step C must be finished before step F can begin.
        \\Step A must be finished before step B can begin.
        \\Step A must be finished before step D can begin.
        \\Step B must be finished before step E can begin.
        \\Step D must be finished before step E can begin.
        \\Step F must be finished before step E can begin.
    ;
    var out_buf: [32]u8 = undefined;
    var slice_out_stream = std.io.SliceOutStream.init(&out_buf);
    try order(&slice_out_stream.stream, sample_text);
    const result = out_buf[0..slice_out_stream.pos];
    std.debug.assert(std.mem.eql(u8, result, "CABDFE"));
}

fn order(out: var, text: []const u8) !void {
    // [step_that_must_be_done][in_order_to_do_this_step]
    var is_dependency_of_table: [26][26]bool = [1][26]bool{[1]bool{false} ** 26} ** 26;
    var step_needs_doing: [26]bool = [1]bool{false} ** 26;

    // parse the text into the structures
    var line_it = std.mem.split(text, "\n");
    while (line_it.next()) |line| {
        const step_that_must_be_done = line[5] - 'A';
        const in_order_to_do_this_step = line[36] - 'A';
        step_needs_doing[step_that_must_be_done] = true;
        step_needs_doing[in_order_to_do_this_step] = true;

        is_dependency_of_table[step_that_must_be_done][in_order_to_do_this_step] = true;
    }

    while (true) {
        var best_step: ?usize = null;
        var potential_step: usize = 0;
        while (potential_step < 26) : (potential_step += 1) {
            if (!step_needs_doing[potential_step]) continue;

            const can_we_do_it = blk: {
                var i: usize = 0;
                while (i < 26) : (i += 1) {
                    if (is_dependency_of_table[i][potential_step] and step_needs_doing[i])
                        break :blk false;
                }
                break :blk true;
            };
            if (can_we_do_it) {
                if (best_step) |prev_best_step| {
                    best_step = std.math.min(prev_best_step, potential_step);
                } else {
                    best_step = potential_step;
                }
            }
        }
        const step = best_step orelse return;
        try out.writeByte(@intCast(u8, 'A' + step));
        step_needs_doing[step] = false;
    }
}

const input_text =
    \\Step A must be finished before step L can begin.
    \\Step B must be finished before step U can begin.
    \\Step S must be finished before step K can begin.
    \\Step L must be finished before step R can begin.
    \\Step C must be finished before step I can begin.
    \\Step F must be finished before step N can begin.
    \\Step X must be finished before step H can begin.
    \\Step Z must be finished before step U can begin.
    \\Step P must be finished before step T can begin.
    \\Step R must be finished before step U can begin.
    \\Step H must be finished before step T can begin.
    \\Step V must be finished before step G can begin.
    \\Step E must be finished before step D can begin.
    \\Step G must be finished before step W can begin.
    \\Step N must be finished before step J can begin.
    \\Step U must be finished before step D can begin.
    \\Step Y must be finished before step K can begin.
    \\Step K must be finished before step J can begin.
    \\Step D must be finished before step M can begin.
    \\Step I must be finished before step O can begin.
    \\Step M must be finished before step Q can begin.
    \\Step Q must be finished before step J can begin.
    \\Step T must be finished before step J can begin.
    \\Step W must be finished before step O can begin.
    \\Step J must be finished before step O can begin.
    \\Step C must be finished before step F can begin.
    \\Step C must be finished before step J can begin.
    \\Step Z must be finished before step I can begin.
    \\Step K must be finished before step I can begin.
    \\Step L must be finished before step W can begin.
    \\Step I must be finished before step W can begin.
    \\Step N must be finished before step O can begin.
    \\Step B must be finished before step G can begin.
    \\Step S must be finished before step O can begin.
    \\Step P must be finished before step H can begin.
    \\Step R must be finished before step J can begin.
    \\Step N must be finished before step U can begin.
    \\Step U must be finished before step J can begin.
    \\Step E must be finished before step T can begin.
    \\Step T must be finished before step O can begin.
    \\Step L must be finished before step T can begin.
    \\Step P must be finished before step Y can begin.
    \\Step L must be finished before step C can begin.
    \\Step D must be finished before step O can begin.
    \\Step H must be finished before step Y can begin.
    \\Step Q must be finished before step T can begin.
    \\Step P must be finished before step G can begin.
    \\Step G must be finished before step D can begin.
    \\Step F must be finished before step H can begin.
    \\Step G must be finished before step M can begin.
    \\Step F must be finished before step V can begin.
    \\Step X must be finished before step O can begin.
    \\Step V must be finished before step Y can begin.
    \\Step Y must be finished before step D can begin.
    \\Step H must be finished before step G can begin.
    \\Step A must be finished before step S can begin.
    \\Step E must be finished before step U can begin.
    \\Step Y must be finished before step O can begin.
    \\Step C must be finished before step K can begin.
    \\Step R must be finished before step W can begin.
    \\Step G must be finished before step I can begin.
    \\Step V must be finished before step E can begin.
    \\Step V must be finished before step T can begin.
    \\Step E must be finished before step K can begin.
    \\Step X must be finished before step R can begin.
    \\Step Q must be finished before step W can begin.
    \\Step X must be finished before step P can begin.
    \\Step K must be finished before step T can begin.
    \\Step I must be finished before step T can begin.
    \\Step P must be finished before step R can begin.
    \\Step T must be finished before step W can begin.
    \\Step X must be finished before step I can begin.
    \\Step N must be finished before step Q can begin.
    \\Step G must be finished before step Y can begin.
    \\Step Y must be finished before step W can begin.
    \\Step L must be finished before step D can begin.
    \\Step F must be finished before step D can begin.
    \\Step A must be finished before step T can begin.
    \\Step R must be finished before step H can begin.
    \\Step E must be finished before step I can begin.
    \\Step W must be finished before step J can begin.
    \\Step F must be finished before step M can begin.
    \\Step V must be finished before step W can begin.
    \\Step I must be finished before step J can begin.
    \\Step Z must be finished before step P can begin.
    \\Step H must be finished before step U can begin.
    \\Step R must be finished before step V can begin.
    \\Step V must be finished before step M can begin.
    \\Step Y must be finished before step M can begin.
    \\Step P must be finished before step M can begin.
    \\Step K must be finished before step D can begin.
    \\Step C must be finished before step T can begin.
    \\Step Y must be finished before step T can begin.
    \\Step U must be finished before step I can begin.
    \\Step A must be finished before step O can begin.
    \\Step E must be finished before step J can begin.
    \\Step H must be finished before step V can begin.
    \\Step F must be finished before step W can begin.
    \\Step M must be finished before step T can begin.
    \\Step S must be finished before step H can begin.
    \\Step S must be finished before step G can begin.
;
