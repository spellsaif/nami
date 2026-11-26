import http from "github.com/kaitk/goose-http@v0.5.20";
import nami from "../src";

fn main() {
    let cfg = http::Config{
        port: 8080,
        ..
    };

    let app = nami::new(cfg);

    app.run();
}