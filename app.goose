import std;
import http from "github.com/kaitk/goose-http@v0.5.20";
import .adapter;
import .context;

fn handle(c:Context) {
    if c.route("GET", "/greet") {
        let name = c.query("name");
        if name == "" {
            c.text(200, "hello, world\n");
        } else {
            c.text(200, name);
        }
    }

    if !c.handled {
        c.not_found();
    }
}

fn main() {
    let cfg = Config {
        port: 3000,
    };

    print("Listening on http://localhost:3000");

    let http_cfg = http::Config {
        port: cfg.port,
        ..
    };

    http::serve(http_cfg) {req, body, out =>
        let c = make_context(req, body, out);
        handle(c);
    };

}