# Murder

Created for NCSS 2025(?)

Will this actually make it to prod? who knows!

## Development

1. Install rust - https://rustup.rs/
2. `cargo install cargo-watch` - install a watcher for rust projects
3. `RUST_LOG=info cargo watch -q -c -w src/ -w templates/ -x "run"` - run the project, and recompile upon any changes in src/ and templates/
