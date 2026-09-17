#!/bin/sh
# Stages libtika_native into frameworks/ and points the binary at it.
# Runs as beforeBundleCommand: after cargo links, before the bundler runs.
#
# GraalVM stamps the library's absolute build path into it as its install name
# (LC_ID_DYLIB / SONAME), and the linker copies that into the binary so the
# app only finds the library on the machine that built it.
#
# Done here rather than in build.rs because a build script can't tell which copy
# was linked (Cargo doesn't order it after ordinary deps, and extractous has no
# `links` key). After linking, the binary's load commands name the exact file.
#
# No signing here: the bundler signs the finished bundle. Signing the bare
# binary now would seal resources that don't exist yet, and macOS rejects the
# result as "damaged".

set -e

# beforeBundleCommand runs from wherever `tauri build` was invoked.
script_dir=$(cd "$(dirname "$0")" && pwd)
cd "$script_dir/.."

BIN_NAME=akhtabooti
STAGE_DIR=frameworks

# `tauri build --target <triple>` nests the binary one level deeper.
find_binary() {
    for candidate in "target/release/$BIN_NAME" target/*/release/"$BIN_NAME"; do
        [ -f "$candidate" ] && { echo "$candidate"; return; }
    done
}

BIN=$(find_binary)
[ -n "$BIN" ] || { echo "relocate-native-libs: no built $BIN_NAME binary found" >&2; exit 1; }

# Fallback for when the binary was already relocated but frameworks/ was cleaned.
find_lib_in_build_dirs() {
    find target -path "*/extractous-*/out/libs/$1" -type f 2>/dev/null | head -1
}

case "$(uname)" in
Darwin)
    LIB=libtika_native.dylib
    INSTALL_NAME="@executable_path/../Frameworks/$LIB"

    current=$(otool -L "$BIN" | awk -v lib="$LIB" '$1 ~ lib {print $1; exit}')
    [ -n "$current" ] || { echo "relocate-native-libs: $BIN does not link $LIB" >&2; exit 1; }

    case "$current" in
        @*) src="$STAGE_DIR/$LIB"
            [ -f "$src" ] || src=$(find_lib_in_build_dirs "$LIB") ;;
        *)  src="$current" ;;
    esac
    [ -n "$src" ] && [ -f "$src" ] || { echo "relocate-native-libs: cannot locate $LIB (binary references '$current')" >&2; exit 1; }

    mkdir -p "$STAGE_DIR"
    [ "$src" = "$STAGE_DIR/$LIB" ] || cp -f "$src" "$STAGE_DIR/$LIB"

    # Otherwise anything linking it later inherits the absolute path again.
    install_name_tool -id "$INSTALL_NAME" "$STAGE_DIR/$LIB"

    if [ "$current" != "$INSTALL_NAME" ]; then
        install_name_tool -change "$current" "$INSTALL_NAME" "$BIN"
        echo "relocate-native-libs: $BIN -> $INSTALL_NAME"
    else
        echo "relocate-native-libs: $BIN already relocated"
    fi
    ;;

Linux)
    LIB=libtika_native.so
    command -v patchelf >/dev/null 2>&1 || { echo "relocate-native-libs: patchelf is required" >&2; exit 1; }

    current=$(patchelf --print-needed "$BIN" | grep "$LIB" | head -1)
    [ -n "$current" ] || { echo "relocate-native-libs: $BIN does not link $LIB" >&2; exit 1; }

    case "$current" in
        /*) src="$current" ;;
        *)  src="$STAGE_DIR/$LIB"
            [ -f "$src" ] || src=$(find_lib_in_build_dirs "$LIB") ;;
    esac
    [ -n "$src" ] && [ -f "$src" ] || { echo "relocate-native-libs: cannot locate $LIB (binary needs '$current')" >&2; exit 1; }

    mkdir -p "$STAGE_DIR"
    [ "$src" = "$STAGE_DIR/$LIB" ] || cp -f "$src" "$STAGE_DIR/$LIB"

    patchelf --set-soname "$LIB" "$STAGE_DIR/$LIB"
    [ "$current" = "$LIB" ] || patchelf --replace-needed "$current" "$LIB" "$BIN"

    # tauri.conf.json installs the library to /usr/lib/akhtabooti. Append, so an
    # existing rpath survives; skip if present so reruns don't duplicate it.
    RPATH='$ORIGIN/../lib/akhtabooti'
    existing=$(patchelf --print-rpath "$BIN" 2>/dev/null || true)
    case ":$existing:" in
        *":$RPATH:"*) ;;
        *) patchelf --set-rpath "${existing:+$existing:}$RPATH" "$BIN" ;;
    esac
    echo "relocate-native-libs: $BIN -> $LIB (rpath $RPATH)"
    ;;

MINGW*|MSYS*|CYGWIN*)
      LIB=libtika_native.dll

    src="$STAGE_DIR/$LIB"
    [ -f "$src" ] || src=$(find_lib_in_build_dirs "$LIB")
    [ -n "$src" ] && [ -f "$src" ] || { echo "relocate-native-libs: cannot locate $LIB" >&2; exit 1; }

    mkdir -p "$STAGE_DIR"
    [ "$src" = "$STAGE_DIR/$LIB" ] || cp -f "$src" "$STAGE_DIR/$LIB"
    echo "relocate-native-libs: staged $STAGE_DIR/$LIB"
    ;;

*)
    exit 0
    ;;
esac
