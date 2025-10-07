// ============================================================
// RUST — DEVELOPMENT & TOOLS
// ============================================================

use std::fs;
use std::io::{self, Read, Write};
use std::net::{TcpListener, TcpStream};
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

// ------------------------------------------------------------
// Core language
// ------------------------------------------------------------
// Ownership, borrowing, lifetimes
// Structs, enums, traits, generics
// Pattern matching: match, if let, while let
// Result<T, E> and Option<T> for error handling

// ------------------------------------------------------------
// Standard library highlights
// ------------------------------------------------------------
// std::fs, std::io, std::net, std::process, std::thread, std::time
// std::mem, std::ptr, std::collections, std::sync, std::env

// ------------------------------------------------------------
// Tools & workflow
// ------------------------------------------------------------
// Cargo: cargo build, cargo run, cargo test, cargo fmt, cargo clippy
// Rustup for toolchains, rust-analyzer for IDE integration
// Crates.io for dependency management

// ------------------------------------------------------------
// Async and concurrency
// ------------------------------------------------------------
// async/await, futures, tokio, async-std for async runtimes

// ------------------------------------------------------------
// Unsafe / low-level operations
// ------------------------------------------------------------
// unsafe { } blocks
// std::ptr::read_volatile / write_volatile
// std::mem::transmute
// Inline assembly via asm! macro

fn read_file(path: &str) -> io::Result<Vec<u8>> {
    let mut f = fs::File::open(path)?;
    let mut buf = Vec::new();
    f.read_to_end(&mut buf)?;
    Ok(buf)
}

fn main() {
    println!("Rust cheatsheet snippets");
}