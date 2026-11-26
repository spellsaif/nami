import json;
import http from "github.com/kaitk/goose-http@v0.5.20";
import .context;

namespace nami;

struct App {
    config: http::Config,
}

fn new(config: http::Config) -> App {
    return App {
        config: config,
    };
}

fn execute<F: fn(Context&)>(c: Context&) {
    F(c);
}

fn dispatch(c: Context&) {

    if http::on(c.router, "GET", "/") {
        execute(c) {
            ctx => ctx.text(200, "Hello, Nami!");
        }
    } else if http::on(c.router, "GET", "/anime/:name") {
        let name = c.param("name");

        execute(c) {
            ctx => ctx.text(200, name);
        }
    } 
    else if http::on(c.router, "GET", "/search") {
        c.text(200, c.query("q"));
    }

    else if http::on(c.router, "GET", "/api/anime") {
        http::respond_json(c.out, 200) {
            b =>
            b.push('{');
            json::format_key(b, "id");
            json::format_int(b, 1);
            b.push('}')
        }
    }
    else {
        http::otherwise(c.router, c.out);
    }
}

thread_fn worker(cfg: http::Config) {
    let e = http::serve(cfg) { req, body, out =>
        
    let r = http::router(req);    
    var c = Context {
        req: req,
        body: body,
        out: out,
        router: r,
    };

        dispatch(c);
    };

    http::report(e);
}

fn run(app: App) {
    http::run(app.config, worker);
}