const std = @import("std");

const Program = struct {
    original_state: []const usize,
    memory_bank: []usize,

    fn run(p: *Program, noun: usize, verb: usize) usize {
        std.mem.copy(usize, p.memory_bank, p.original_state);

        p.memory_bank[1] = noun;
        p.memory_bank[2] = verb;

        var pc: usize = 0;
        while (true) {
            const opcode = p.memory_bank[pc];
            pc += 1;
            switch (opcode) {
                1, 2 => {
                    const operand1 = p.memory_bank[pc];
                    pc += 1;
                    const operand2 = p.memory_bank[pc];
                    pc += 1;
                    const dest = p.memory_bank[pc];
                    pc += 1;
                    switch (opcode) {
                        1 => p.memory_bank[dest] = p.memory_bank[operand1] + p.memory_bank[operand2],
                        2 => p.memory_bank[dest] = p.memory_bank[operand1] * p.memory_bank[operand2],
                        else => unreachable,
                    }
                },
                99 => break,
                else => @panic("Illegal instruction"),
            }
        }

        return p.memory_bank[0];
    }
};

pub fn main() anyerror!void {
    const allocator = &std.heap.ArenaAllocator.init(std.heap.page_allocator).allocator;
    const limit = 1 * 1024 * 1024 * 1024;
    const text = try std.fs.cwd().readFileAlloc(allocator, "problem1.txt", limit);
    const int_count = blk: {
        var int_count: usize = 0;
        var it = std.mem.separate(text, ",");
        while (it.next()) |_| int_count += 1;
        break :blk int_count;
    };
    const memory_bank = try allocator.alloc(usize, int_count);
    {
        var it = std.mem.separate(text, ",");
        var i: usize = 0;
        while (it.next()) |n_text| : (i += 1) {
            const trimmed = std.mem.trim(u8, n_text, " \n\r\t");
            memory_bank[i] = try std.fmt.parseInt(usize, trimmed, 10);
        }
    }
    var program = Program{
        .original_state = memory_bank,
        .memory_bank = try allocator.alloc(usize, int_count),
    };
    var noun: usize = 0;
    while (noun <= 99) : (noun += 1) {
        var verb: usize = 0;
        while (verb <= 99) : (verb += 1) {
            if (program.run(noun, verb) == 19690720) {
                const out = &std.io.getStdOut().outStream().stream;
                try out.print("{}\n", 100 * noun + verb);
                return;
            }
        }
    }
    return error.SolutionNotFound;
}
