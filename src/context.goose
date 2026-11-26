namespace nami;

struct Context {
    req: const http::Request,
    body: const u8[:],
    out: http::Reply,
    router: http::Router,
}

fn text(c: Context&, status: i32, body: const u8[:]) {
    http::respond(c.out, status, "text/plain", body);
}

fn method(c: const Context&) -> const u8[:] {
    return c.req.method;
}

fn path(c: const Context&) -> const u8[:] {
    return http::path_of(c.req.target);
}

fn param(c: Context&, name: const u8[:]) -> const u8[:] {
    return http::param(c.router, name);
}

fn query(c: Context&, name: const u8[:]) -> const u8[:] {
    let value, found = http::query_of(c.req.target, name);

    return value;
}