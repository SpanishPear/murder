use tower_http::trace::{self, TraceLayer};

use axum::{
    http::StatusCode,
    response::{IntoResponse, Html},
    routing::{get, post},
    Json, Router, extract::State,
};
use minijinja::{path_loader, Environment, context};
use tracing::Level;

type AppEngine = Environment<'static>;

// the application state
#[derive(Clone)]
struct AppState {
    engine: AppEngine,
}

#[tokio::main]
async fn main() {
    // initialize tracing
    // tracing is a library for instrumenting rust programs to collect
    // diagnostics and report them in a structured way
    // specifically, we're using tracing-subscriber to format and output
    // tracing data to stdout
    tracing_subscriber::fmt::init();

    // minijinja is a templating engine for rust 
    // it's a port of the popular jinja2 templating engine for python 
    // and actualy written by the same author
    // setup the environment and tell it to load templates from the `templates` directory
    let mut jinja = minijinja::Environment::new();
    jinja.set_loader(path_loader("./templates"));

    let app = Router::new()
        // `GET /` goes to `home`
        // `GET /healthcheck` goes to `root`
        .route("/", get(healthcheck))
        .with_state(AppState { engine: jinja })
        .layer(
            // Setup tracing:
            //  - Request Start -- INFO
            //  - Response Start -- TRACE
            TraceLayer::new_for_http()
                .make_span_with(trace::DefaultMakeSpan::new().level(Level::INFO))
                .on_request(trace::DefaultOnRequest::new().level(Level::INFO))
                .on_response(trace::DefaultOnResponse::new().level(Level::TRACE)),
        )
        .fallback(handler_404);

    // run our app with hyper, listening globally on port 3000
    let address = "0.0.0.0:3000";
    let listener = tokio::net::TcpListener::bind(address).await.unwrap();

    tracing::info!("🚀 listening on {address}");

    // start the server!
    axum::serve(listener, app).await.unwrap();
}

// basic healthcheck handler
// renders `templates/healthcheck.html` with the context `{ name: "world" }`
async fn healthcheck(State(state): State<AppState>) -> impl IntoResponse {
    let template = state.engine.get_template("healthcheck.html").unwrap();
    let rendered = template.render(context! {
        name => "world",
    }).unwrap();
    Html(rendered).into_response()
}

async fn handler_404() -> impl IntoResponse {
    (StatusCode::NOT_FOUND, "ohnoes")
}
