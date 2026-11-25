import http;
import .context;

struct Config {
    port: i32 = 8080,
}

inline fn make_context(req, body, out: http::Reply) -> Context {
    return Context {
        method: req.method,
        target: req.target,
        path: http::path_of(req.target),
        body: body,
        out: out,
    };
}