import http;

struct Context {
    method: const u8[:],
    target: const u8[:],
    path: const u8[:],
    body: const u8[:],
    out: http::Reply,
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