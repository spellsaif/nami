import json;

fn write_value<T>(out: u8[>..]&, value: T) {
    const if same<T, i64> {
        json::format_int(out, value);
    } else const if same<T, bool> {
        json::format_bool(out, value);
    } else const if same<T, const u8[:]> {
        json::format_string(out, value);
    } else {
        serialize(out, value);
    }
}

struct Anime {
    id: i64,
    name: const u8[:],
    watched: bool,
    character: Character,
}

struct Character {
    id: i64,
    name: const u8[:],
}

fn serialize<T>(out: u8[>..]&, value: T&) {
    out.push('{');

    var first = true;

    const for <N, A> in fields<T> {
        if !first {
            out.push(',')
        }

        first = false;

        json::format_key(out, N);
        write_value(out, value.A);
    }

    out.push('}');
}

fn main() {
    let anime = Anime {
        id: 1,
        name: "Moonlit Fantasy",
        watched: true,
        character: Character {
            id: 1,
            name: "Mio",
        }
    };

    var output: u8[>..] = [];
    serialize(output, anime);

    print(output);
}