import http from "github.com/kaitk/goose-http@v0.5.20";
import .context;

namespace nami;

fn dispatch(c: Context&) {
    c.text(200, "Hello, Nami!");
}

thread_fn worker(cfg: http::Config) {
    let e = http::serve(cfg) { req, body, out =>
        
        var c = Context {
            req: req,
            body: body,
            out: out,
        };

        dispatch(c);
    };

    http::report(e);
}

fn run(cfg: http::Config) {
    http::run(cfg, worker);
}