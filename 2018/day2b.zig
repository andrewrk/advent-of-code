const std = @import("std");

pub fn main() !void {
    var direct_allocator = std.heap.DirectAllocator.init();
    defer direct_allocator.deinit();

    var arena = std.heap.ArenaAllocator.init(&direct_allocator.allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    std.debug.warn("{}\n", try commonLetters(allocator, main_input));
}

test "sample inputs" {
    const sample_input =
        \\abcde
        \\fghij
        \\klmno
        \\pqrst
        \\fguij
        \\axcye
        \\wvxyz
    ;
    const result = try commonLetters(std.debug.global_allocator, sample_input);
    std.debug.assert(std.mem.eql(u8, result, "fgij"));
}

fn commonLetters(allocator: *std.mem.Allocator, text: []const u8) ![]u8 {
    var list = std.ArrayList([]const u8).init(allocator);
    var it = std.mem.split(text, "\n");
    while (it.next()) |line| {
        try list.append(line);
    }
    var smallest_diff: u64 = std.math.maxInt(u64);
    var smallest_index_1: usize = undefined;
    var smallest_index_2: usize = undefined;
    const slice = list.toSlice();
    for (slice) |a, index1| {
        for (slice[index1 + 1 ..]) |b, off2| {
            const this_diff = diff(a, b);
            if (this_diff < smallest_diff) {
                const index2 = index1 + 1 + off2;
                smallest_diff = this_diff;
                smallest_index_1 = index1;
                smallest_index_2 = index2;
            }
        }
    }
    var buf = try std.Buffer.initSize(allocator, 0);
    for (slice[smallest_index_1]) |c1, i| {
        const c2 = slice[smallest_index_2][i];
        if (c1 == c2)
            try buf.appendByte(c1);
    }
    return buf.toOwnedSlice();
}

fn diff(a: []const u8, b: []const u8) u64 {
    var diff_count: u64 = 0;
    for (a) |c1, i| {
        const c2 = b[i];
        diff_count += @boolToInt(c1 != c2);
    }
    return diff_count;
}

const main_input =
    \\oiwcdpbseqgxryfmlpktnupvza
    \\oiwddpbsuqhxryfmlgkznujvza
    \\ziwcdpbsechxrvfmlgktnujvza
    \\oiwcgpbseqhxryfmmgktnhjvza
    \\owwcdpbseqhxryfmlgktnqjvze
    \\oiscdkbseqhxrffmlgktnujvza
    \\oiwcdibseqoxrnfmlgktnujvza
    \\oiwcdpbsejhxryfmlektnujiza
    \\oewcdpbsephxryfmlgkwnujvza
    \\riwcdpbseqhxryfmlgktnujzaa
    \\omwcdpbseqwxryfmlgktnujvqa
    \\oiwcdqqneqhxryfmlgktnujvza
    \\oawcdvaseqhxryfmlgktnujvza
    \\oiwcdabseqhxcyfmlkktnujvza
    \\oiwcdpbseqhxryfmlrktrufvza
    \\oiwcdpbseqhxdyfmlgqtnujkza
    \\oiwcdpbseqhxrmfolgktnujvzy
    \\oiwcdpeseqhxnyfmlgktnejvza
    \\oiwcdpbseqhxrynmlaktlujvza
    \\oiwcdpbseqixryfmlektncjvza
    \\liwtdpbseqhxryfylgktnujvza
    \\ouwcdpbszqhxryfmlgktnajvza
    \\oiwzdpbseqhxryfmngktnujvga
    \\wiwcfpbseqhxryfmlgktnuhvza
    \\oiwcdpbselhfryfmlrktnujvza
    \\oywcdpbveqhxryfmlgktnujdza
    \\oiwcdpbsiqhxryfmqiktnujvza
    \\obwcdhbseqhxryfmlgktnujvqa
    \\oitcdpbseqhfryfmlyktnujvza
    \\oiwcdpbseqhxryfmlnutnujqza
    \\oiwcdpbseqhxnyfmlhktnujtza
    \\oiwcdpbseqhbryfmlgkunuwvza
    \\oiwcopbseqhiryfmlgktnkjvza
    \\oiwcdpsseqhxryfklrktnujvza
    \\oiwcdpsrsqhxryfmlgktnujvza
    \\oiwcdpbsyqrxryfmlgktnujvzc
    \\ojwcepbseqhxryfmlgktnujvfa
    \\oiwcdpbseqhxrlfmlgvtnujvzr
    \\oiycdpbsethsryfmlgktnujvza
    \\eiwcdpbseqwxryfmlgktnujcza
    \\oiocdpbseqhxryfxlgktaujvza
    \\qiwydpbseqhpryfmlgktnujvza
    \\ziwcdpbseqhxryfmlgktsuuvza
    \\oiwcdpbseqheryfmygxtnujvza
    \\oiwidpbseqhxryfulgktnujvzm
    \\oiscdpdseqhxryfmlgktnujvya
    \\oiwmypbseqhxryfmlgktnuxvza
    \\oizcwbbseqhxryfmlgktnujvza
    \\oiwcdpbseqpxryfmlgxfnujvza
    \\oiwpdpbscqhxryxmlgktnujvza
    \\oiwcdpbseqhxrifrlgkxnujvza
    \\oiwcdpbsrqhxrifmlgktnzjvza
    \\tiwcdpbseqhxryfmegkvjujvza
    \\oiwcddbseqhxryfingktnujvza
    \\oiwcdpbsiqhiryfmlgktnucvza
    \\oiwcipbseqhxrkfmlgktnuvvza
    \\kiwcdpbseqhxryfmlbkonujvza
    \\qiwcdhbsedhxryfmlgktnujvza
    \\siwcdpbseqhxryfmsgktnujvua
    \\oqwcdpbseqhxryfmlyktndjvza
    \\oiwcqnbseehxryfmlgktnujvza
    \\oiwcdybseqhxryfmlgbtnujvia
    \\oiwcdpbsejhxryfdlgktngjvza
    \\oawcdpbseqhxrbfmlkktnujvza
    \\oilcdpbseqhhrjfmlgktnujvza
    \\oibcdpbseqhxryfmngktnucvza
    \\niwcdpbseqhxryfmlgkuaujvza
    \\oiwcdpbseqhxryfmqgmtnujvha
    \\oiwcdpbseqhcryfxlgktnzjvza
    \\oiwcdpaseqhxryfmqgktnujvzl
    \\oiwcdpbseqhxjyfmlgkonujvzx
    \\oiwmdzbseqlxryfmlgktnujvza
    \\oiwhdpbsexhxryfmlgktnujvzw
    \\oiwctpbseqhxryfmlgktnummza
    \\oiwcdpbseqoxrydmlgktnujvoa
    \\oiwkdpvseqhxeyfmlgktnujvza
    \\oixcdpbsemhxryfmlgctnujvza
    \\oimcdpbseqhxryfmlgktnujvlr
    \\oiwcdpbseehxrywmlgktnejvza
    \\oiwcdpbseqoxhyfmlgktnujyza
    \\oiwcdpbsethxryfmlgktnrjvxa
    \\oiwcdpbxeqhxryfmlgktnrjvzb
    \\ogeadpbseqhxryfmlgktnujvza
    \\eiwcdpbseqhxryfmlgktnvuvza
    \\oiwcdpbseqhxryfmlgktnujaxv
    \\siwcdpbsuqhxryfmlgktnuavza
    \\oixcdpbseqhxryfmlgatnujvzy
    \\oiwcdpbzeghmryfmlgktnujvza
    \\oiwcdpbieqhxryfmlgktyujvzr
    \\oiwcdpbseqhxeyfhlgktngjvza
    \\oiwcdpbseqhjoyrmlgktnujvza
    \\iiwcdpbseqhxryfmwhktnujvza
    \\oixcdpbsiqhxryfmagktnujvza
    \\oiwcdpfljqhxryfmlgktnujvza
    \\oivcdpbseqhxrqfmlgktnujvca
    \\ovwcdpbseqhxzyfmlgkenujvza
    \\oiwxdpgseqhxryfmlgktnhjvza
    \\oibcdpbbeohxryfmlgktnujvza
    \\oiwcrpbseqhxrygmlgwtnujvza
    \\jiwcdpbseqkxryfmlgntnujvza
    \\oiwcdbbseqhxrywmlgktnujvra
    \\oiwcdpbteqyxoyfmlgktnujvza
    \\oiwcdjbsvqvxryfmlgktnujvza
    \\obwcdukseqhxryfmlgktnujvza
    \\oifcdpdseqhxryfmlgktnujsza
    \\oiwcdpbseqhxryfalgktnujyda
    \\oiwcwpbseqhxrnfmkgktnujvza
    \\oswcdpbsethcryfmlgktnujvza
    \\oiwcdpbieqhxryfmlgktnuoiza
    \\oiwcdibsehhxryfmzgktnujvza
    \\oisjdpbseqhxryfmfgktnujvza
    \\oiwcjpbseqkxqyfmlgktnujvza
    \\obwcdpbshqhgryfmlgktnujvza
    \\oiwcspbseqhxryxmlgktnujvzl
    \\oiwcdvbswqhxryfmlgklnujvza
    \\oiwcdhuseqhxryfmlgdtnujvza
    \\oiwcdpbkeqdxryfmlgktnujvzv
    \\oiwcdpzseqhxcyfmlgksnujvza
    \\oiwcdpbseqhxryfmbkkvnujvza
    \\qiwcdpbseqhxrnfmlgktnujvha
    \\okwcdpbseqhxryfmdgktgujvza
    \\oiwcdpbkeqhxryfmldktnujvzu
    \\oiwctpxseqhxgyfmlgktnujvza
    \\oiwcdpbseqhxrykmlgktnujita
    \\oiwcdpbseqhxryfmldktyujnza
    \\oiwcdpbszqhxrjfmlgktnuqvza
    \\oiwcdpbeeqhxrykmlgktnujrza
    \\oiwcvpbseqhxryhmlgwtnujvza
    \\oiwcdpbpeehxryfmlgktnujvzz
    \\oiwcdbbsxqhxyyfmlgktnujvza
    \\oiwkdpbseqhxryfplgktnujeza
    \\opwcdpbseqhxdyfmlgctnujvza
    \\oowcdpbseqhnryfmlgktnujvga
    \\oawzdibseqhxryfmlgktnujvza
    \\oiwcdpbfeqzxrjfmlgktnujvza
    \\oiwcdpbseqaxryfmlgkonulvza
    \\oiacdpbseqvxryfmlgktvujvza
    \\oiwudpbseqhxryfwlgktnujvka
    \\oiwcdpbjeqhxryfymgktnujvza
    \\oiwcdpbweqhxrynmlgktnujaza
    \\oiwcdpbseqdxryfclgvtnujvza
    \\oiwcdppseqhxryfmlgmtzujvza
    \\oiwcdpbseqhxrhfelektnujvza
    \\kiwcdpbsnqhxryfmegktnujvza
    \\oiwcdpbseqpxryfmlgzwnujvza
    \\eiwcdpbseqnxryfplgktnujvza
    \\oiwcdbbseqhxryfmlmktnujvha
    \\oiwcdpbseqhxryfmlgktjhjvka
    \\oiwcdpbseqhxnyfylgktnujvzs
    \\oiwcdpbbxqhxryfmzgktnujvza
    \\opwcdpbseqhfryfmlgktnujzza
    \\oiwcdpbsjqpxryfmtgktnujvza
    \\oiwcdpbseqhyqbfmlgktnujvza
    \\oxwcdpbseqhxrffmlgktiujvza
    \\oiwcdpbseqhxgyfmlgytnujvzq
    \\oiwidpbseqhxryfmlgxtnujvzd
    \\oiwcdpbshqhxryzmlpktnujvza
    \\oifcdpbseqbxryfmlgktdujvza
    \\biwcdzbseqhxtyfmlgktnujvza
    \\oiwcdpbswqhxryfmlgutnujvca
    \\xiwcdpbseqhxryxmlnktnujvza
    \\oiwcdpzseqhxryfrlgktdujvza
    \\oiwudpbseqhxryfmlgkqnurvza
    \\oiwqdpbseihiryfmlgktnujvza
    \\iiwjdpbseqhxryamlgktnujvza
    \\oiwcdplseqhqryfmmgktnujvza
    \\oiwcdppseqhxrmfmlgklnujvza
    \\oiwcdobseqhxryfmmgkttujvza
    \\odwcdpbseqhxryfmlgktnujvyk
    \\oiwcdpkseqhxrhfmlgktntjvza
    \\oiocdpbseqhxryfmlgjknujvza
    \\oiicdpbieqhxryfmlgksnujvza
    \\oiwcdpbseqhxryemlgktnujdla
    \\oiwcdpbseqdxryfmlgktsujvzt
    \\oiwcdcksnqhxryfmlgktnujvza
    \\oowcdpbseqhxryfmlgsfnujvza
    \\oawcdpbseqhxryfmljktnuevza
    \\oiwcdpbsaqhxrffmzgktnujvza
    \\oiwcipbseqhcryfmlgktnujvga
    \\oiwcdpbsewhxrbfmlgktnuuvza
    \\oiwcdpbsewhxryfmlgkunujvzc
    \\oiwcdpbseqhxryfmlgktiujkga
    \\jiwcdpbseqhxrlfmlgktnurvza
    \\tiwcdpbseqoxryfmliktnujvza
    \\oiwcdpbsenhxryfmlgkskujvza
    \\oiwcdpbseqhxvyfmlhktoujvza
    \\oiwcdpbseqhxeyfmlgmtnunvza
    \\oiwcdpbseqhxdyfmloktnujvzu
    \\oiwcdpbseqgxryfmlgkynejvza
    \\oudcdpbseqhxryfmlgktmujvza
    \\oiwcdpbseqhxryfmvgktnucvzc
    \\oiwcdpbseqhxrysalgwtnujvza
    \\odwodpbseqhgryfmlgktnujvza
    \\oiwcdpbseqheryzmlgktnujgza
    \\oiwcdpbseqhxryfalgwtnujvba
    \\oiwcdpbseqhxryfmlgtdnuhvza
    \\oiocdpbseqhxrefulgktnujvza
    \\kiwcdpbseqhxrywolgktnujvza
    \\niwcdpbseksxryfmlgktnujvza
    \\oiwcdybseqexryfalgktnujvza
    \\oiwcdpbbeqhxryamlgktnujpza
    \\oiecdqbseqhxryfmlgktnujcza
    \\oiwcdpbsqqhxlyfmlpktnujvza
    \\oiwcdpbsaqheryfmlgktnujlza
    \\oiecdpbseqhxryfmlgkknujvzz
    \\oiwcapbsdqhxryfmlgktvujvza
    \\ojwcdxbseqhxryfmlgktrujvza
    \\oiwhdpbseqvxrzfmlgktnujvza
    \\oiwcdppseqhtryfmlgktnujvzs
    \\oikcdpbsfqhxryfmdgktnujvza
    \\owwczpbseqhxryfilgktnujvza
    \\oifwdpbseqhxryfmlgktnujfza
    \\oowcdpbseqhxrprmlgktnujvza
    \\oiwcapbseqhxryfmjgktnujvze
    \\oiwcdpaseqhdrybmlgktnujvza
    \\tiwcdpbseqhxryfmlgkvjujvza
    \\xiwcdpbseqhoryfmlgktnujvqa
    \\eiwrdpbsyqhxryfmlgktnujvza
    \\oiwcdpbseqhxranmlgktnujvzt
    \\oiwcdpbseqhxryfqlgktnudaza
    \\oiwcdpbsvqhxrywmlgktnsjvza
    \\oewcdpbseqhxryfmlgkunujvma
    \\oiwcdpbseqhjrywmlgktnujvzb
    \\omwcdpbseqhxryfmlgktwujsza
    \\oiwcdpbyxqhxryfmlgrtnujvza
    \\oiwidpbseqhxryfhlgktnunvza
    \\oqwcdpbweqhxrybmlgktnujvza
    \\oiwcdqbseqhxryfrlgktnujfza
    \\oiacdpbseqhdryfmlgktaujvza
    \\oiwcdpbstqhxmyfmlgktyujvza
    \\oiwcdpbseqhxeyfclgktjujvza
    \\wiwcdpeseqhxryfmlgktnujvzx
    \\viwcdpbseqhxryfmlgvtvujvza
    \\oircdpbseqhxcyfmlgktnujvma
    \\miwcdpbseqtwryfmlgktnujvza
    \\oiwcppbseqhxcyfmlgxtnujvza
    \\giwcrpbseqhxryfmlgktnudvza
    \\onwcvpbseqhxryfmlgktnujqza
    \\oiwcipbseqhxryfmlgitnuqvza
    \\oiwcdpbseqhxryjmlgkonufvza
    \\oiwnwpbseqhxtyfmlgktnujvza
    \\oiwcypbseqhxryfmlgetnujvzv
    \\oiwcdpbseqhxryqmljktnkjvza
    \\olwcdpbseqhxryfmlgkenujvba
    \\biwcdpbseqwxrywmlgktnujvza
    \\oiwcdpbsevhmryjmlgktnujvza
    \\oiwcdpbseqhxryfmlzktnkjvzv
    \\oiwudpbseqhxrefmlgktnujvia
    \\oiicdpbseqhxryfdloktnujvza
    \\oihcjpbsxqhxryfmlgktnujvza
;
