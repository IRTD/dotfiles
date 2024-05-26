GO="$PWD/main.go"
CARGO="$PWD/Cargo.toml"
HASKELL="$PWD/main.hs"
C="$PWD/Makefile"
PY="$PWD/main.py"
RUST_TAURI="$PWD/src-tauri"
OS_FLAG_FILE="$PWD/.autorun_os"

if [ -f "$OS_FLAG_FILE" ]; then
    if [ -f "$CARGO" ]; then
        cargo bootimage
    fi
    cargo run &
    sleep 0.5
    2>/dev/null 1>/dev/null vncviewer 127.0.0.1::5900 
    exit
fi

if [ -f "$GO" ]; then
    go run .
fi

if [ -d "$RUST_TAURI" ]; then
    echo "Found Tauri project... running 'cargo tauri dev'"
    cargo tauri dev
    exit
fi

if [ -f "$CARGO" ]; then
    echo "Found Cargo project... running 'cargo run'"
    cargo run
fi

if [ -f "$HASKELL" ]; then
    runghc -dynamic "$HASKELL"
fi

if [ -f "$C" ]; then
    make run
fi

if [ -f "$PY" ]; then
    python "$PY"
fi

