import http;

struct Context {
    method: const u8[:],
    target: const u8[:],
    path: const u8[:],
    body: const u8[:],
    out: http::Reply,
    handled: bool = false,
}

fn text(c: Context, status: i32, msg: const u8[:]) {
    http::respond(c.out, status, "text/plain", msg);
}

fn json_raw(c:Context, status: i32, raw_json: const u8[:]){
    http::respond(c.out, status, "application/json", raw_json);
}

fn not_found(c: Context) {
    c.json_raw(404, "{\"error\":\"not_found\"}");
}

fn query(c: Context, key: const u8[:]) -> const u8[:] {
    let val, ok = http::query_of(c.target, key);

    if !ok {
        return "";
    }
    return val;
}


fn route(c: Context, method: const u8[:], path: const u8[:]) -> bool {
    if !c.handled && c.method == method && c.path == path {
        return true;
    }
    return false;
}

fn match_prefix(c: Context&, method: const u8[:], prefix: const u8[:]) -> bool {
    if c.handled || c.method != method {
        return false;
    }
    let p_len = prefix.len;
    if c.path.len < p_len {
        return false;
    }
    var i = 0;
    while i < p_len {
        if c.path[i] != prefix[i] {
            return false;
        }
        i = i + 1;
    }
    return true;
}

fn path_tail(c: Context, prefix: const u8[:]) -> const u8[:] {
    let p_len = prefix.len;
    if c.path.len <= p_len {
        return "";
    }
    return c.path;
}