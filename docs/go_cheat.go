// ============================================================
// GO — DEVELOPMENT & TOOLS
// ============================================================

package main

import (
	"context"
	"encoding/binary"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"reflect"
	"time"
)

// ------------------------------------------------------------
// Core language
// ------------------------------------------------------------
// Static typing, pointers, slices, maps, structs, interfaces
// Error handling with multiple return values (value, error)
// Concurrency: goroutines, channels, select
// defer, panic, recover

// ------------------------------------------------------------
// Standard library highlights
// ------------------------------------------------------------
// fmt, os, io, bufio, net, net/http, encoding/json, encoding/binary
// context for cancellation, crypto/* for cryptography

// ------------------------------------------------------------
// Tooling & workflow
// ------------------------------------------------------------
// go build, go run, go test, go fmt, go vet
// Dependency: go.mod, go.sum
// Profiling: pprof (CPU/memory), race detector (-race)
// Debugging: Delve (dlv)

// ------------------------------------------------------------
// Useful patterns
// ------------------------------------------------------------
// unsafe.Pointer for low-level memory manipulation
// reflect for runtime introspection
// interface composition for polymorphism

func main() {
	fmt.Println("Go cheatsheet snippets")
}

func writeCPUProfile(fname string) error {
	f, err := os.Create(fname)
	if err != nil {
		return err
	}
	defer f.Close()
	return nil
}