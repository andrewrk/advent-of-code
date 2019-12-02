const std = @import("std");

pub fn main() void {
    const result = getDuration(input_text, 5, 61);
    std.debug.warn("{}\n", result);
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
    const result = getDuration(sample_text, 2, 1);
    std.debug.assert(result == 15);
}

fn getDuration(text: []const u8, comptime worker_count: usize, duration_base: usize) usize {
    // [step_that_must_be_done][in_order_to_do_this_step]
    var is_dependency_of_table: [26][26]bool = [1][26]bool{[1]bool{false} ** 26} ** 26;
    var seconds_until_done: [26]usize = [1]usize{0} ** 26;
    var worker_to_step: [worker_count]?usize = [1]?usize{null} ** worker_count;
    var step_to_worker: [26]?usize = [1]?usize{null} ** 26;

    // parse the text into the structures
    var line_it = std.mem.split(text, "\n");
    while (line_it.next()) |line| {
        const step_that_must_be_done = line[5] - 'A';
        const in_order_to_do_this_step = line[36] - 'A';
        seconds_until_done[step_that_must_be_done] = duration_base + step_that_must_be_done;
        seconds_until_done[in_order_to_do_this_step] = duration_base + in_order_to_do_this_step;

        is_dependency_of_table[step_that_must_be_done][in_order_to_do_this_step] = true;
    }

    var time: usize = 0;

    while (true) {
        // Give all the workers jobs, keeping track of smallest
        // seconds until done.
        var worker_i: usize = 0;
        var smallest_seconds_until_done: ?usize = null;
        while (worker_i < worker_count) : (worker_i += 1) {
            // If the worker has a job already and the job isn't
            // already done, skip them.
            if (worker_to_step[worker_i]) |step| {
                if (seconds_until_done[step] != 0) {
                    if (smallest_seconds_until_done) |prev| {
                        smallest_seconds_until_done = std.math.min(
                            prev,
                            seconds_until_done[step],
                        );
                    } else {
                        smallest_seconds_until_done = seconds_until_done[step];
                    }
                    continue;
                }
            }

            var best_step: ?usize = null;
            var potential_step: usize = 0;
            while (potential_step < 26) : (potential_step += 1) {
                // If it's already done or assigned, skip.
                if (seconds_until_done[potential_step] == 0 or
                    step_to_worker[potential_step] != null)
                {
                    continue;
                }

                const can_we_do_it = blk: {
                    var i: usize = 0;
                    while (i < 26) : (i += 1) {
                        if (is_dependency_of_table[i][potential_step] and
                            seconds_until_done[i] != 0)
                        {
                            break :blk false;
                        }
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
            const step = best_step orelse continue;
            worker_to_step[worker_i] = step;
            step_to_worker[step] = worker_i;
            if (smallest_seconds_until_done) |prev| {
                smallest_seconds_until_done = std.math.min(prev, seconds_until_done[step]);
            } else {
                smallest_seconds_until_done = seconds_until_done[step];
            }
        }
        const time_delta = smallest_seconds_until_done orelse return time;

        time += time_delta;
        for (seconds_until_done) |*item, step| {
            if (step_to_worker[step] != null and item.* != 0) {
                item.* -= time_delta;
            }
        }
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
