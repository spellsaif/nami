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

    if c.match_prefix("GET", "/users/") {
        c.text(200, c.path);
    }

    if c.route("POST", "/echo") {
        if c.body.len == 0 {
            c.json_raw(400, "{\"error\":\"empty_body\"}\n");
        } else {
            c.json_raw(200, c.body);
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