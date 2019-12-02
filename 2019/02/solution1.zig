const std = @import("std");

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
    // BOOT SEQUENCE
    memory_bank[1] = 12;
    memory_bank[2] = 2;

    var pc: usize = 0;
    while (true) {
        const opcode = memory_bank[pc];
        pc += 1;
        switch (opcode) {
            1, 2 => {
                const operand1 = memory_bank[pc];
                pc += 1;
                const operand2 = memory_bank[pc];
                pc += 1;
                const dest = memory_bank[pc];
                pc += 1;
                switch (opcode) {
                    1 => memory_bank[dest] = memory_bank[operand1] + memory_bank[operand2],
                    2 => memory_bank[dest] = memory_bank[operand1] * memory_bank[operand2],
                    else => unreachable,
                }
            },
            99 => break,
            else => return error.IllegalInstruction,
        }
    }

    const out = &std.io.getStdOut().outStream().stream;
    try out.print("{}\n", memory_bank[0]);
}
