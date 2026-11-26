import http from "github.com/kaitk/goose-http@v0.5.20";
import .context;

namespace nami;

fn execute<F: fn(Context&)>(c: Context&) {
    F(c);
}

fn dispatch(c: Context&) {
    var r = http::router(c.req);

    if http::on(r, "GET", "/") {
        execute(c) {
            ctx => ctx.text(200, "Hello, Nami!");
        }
    } else if http::on(r, "GET", "/anime/:name") {
        let name = http::param(r, "name");

        execute(c) {
            ctx => ctx.text(200, name);
        }
    } else {
        http::otherwise(r, c.out);
    }
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