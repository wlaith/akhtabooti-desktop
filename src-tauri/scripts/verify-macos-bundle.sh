#!/bin/sh
# Checks a built .app will actually run on a machine other than this one.
# Guards against absolute library paths baked in at link time and against
# signing mistakes that make macOS report the app as damaged.
#
# Usage: verify-macos-bundle.sh [path/to/App.app]

set -e

APP=${1:-target/release/bundle/macos/akhtabooti.app}
BIN="$APP/Contents/MacOS/akhtabooti"

[ -d "$APP" ] || { echo "verify: no such bundle: $APP" >&2; exit 1; }
[ -f "$BIN" ] || { echo "verify: no executable at $BIN" >&2; exit 1; }

fail=0
note() { echo "  $1"; }
bad() { echo "  FAIL: $1" >&2; fail=1; }

echo "verify-macos-bundle: $APP"

# 1. Paths outside the bundle, /usr/lib or /System only exist on this machine.
echo "[1] load commands are relocatable"
for macho in "$BIN" "$APP"/Contents/Frameworks/*.dylib; do
    [ -f "$macho" ] || continue
    otool -L "$macho" | tail -n +2 | awk '{print $1}' | while read -r ref; do
        case "$ref" in
            @executable_path/*|@loader_path/*|@rpath/*) ;;
            /usr/lib/*|/System/*) ;;
            *) echo "BADREF $(basename "$macho") -> $ref" ;;
        esac
    done
done > /tmp/verify-badrefs.$$ 2>/dev/null || true

if [ -s /tmp/verify-badrefs.$$ ]; then
    while read -r line; do bad "absolute load path: ${line#BADREF }"; done < /tmp/verify-badrefs.$$
else
    note "ok - all load commands use @executable_path/@rpath or system paths"
fi
rm -f /tmp/verify-badrefs.$$

# 2. Every non-system load path must actually resolve inside the bundle.
echo "[2] referenced libraries are present in the bundle"
otool -L "$BIN" | tail -n +2 | awk '{print $1}' | grep '^@executable_path/' | while read -r ref; do
    resolved="$APP/Contents/MacOS/${ref#@executable_path/}"
    if [ -f "$resolved" ]; then
        echo "  ok - $(basename "$ref") present"
    else
        echo "  FAIL: $ref does not resolve to a file in the bundle" >&2
        exit 1
    fi
done || fail=1

# 3. Patching a Mach-O invalidates its seal, so a stale signature here means
#    something re-wrote the binary after signing.
echo "[3] code signature is valid"
if codesign --verify --deep --strict "$APP" 2>/dev/null; then
    note "ok - signature verifies"
else
    bad "code signature is missing or stale (re-sign after patching Mach-O files)"
fi

# 4. Hardened runtime enables library validation, which rejects bundled
#    libraries that don't share the app's Team ID — and ad-hoc has none.
echo "[4] library validation will not reject bundled libraries"
if codesign -dv "$BIN" 2>&1 | grep -q "runtime"; then
    if [ -d "$APP/Contents/Frameworks" ] && [ -n "$(ls -A "$APP/Contents/Frameworks" 2>/dev/null)" ]; then
        if codesign -d --entitlements - --xml "$APP" 2>/dev/null | grep -q "disable-library-validation"; then
            note "ok - hardened runtime with disable-library-validation entitlement"
        elif codesign -dv "$BIN" 2>&1 | grep -q "TeamIdentifier=not set"; then
            bad "hardened runtime + ad-hoc signature + bundled libraries, and no
        disable-library-validation entitlement: dyld will refuse to load
        Contents/Frameworks (\"different Team IDs\") at launch"
        else
            note "ok - signed with a Team ID; bundled libraries share it"
        fi
    else
        note "ok - no bundled libraries to validate"
    fi
else
    note "ok - hardened runtime not enabled"
fi

# 5. The decisive check — everything above is static analysis. A dyld failure
#    aborts immediately, so a process still alive after a few seconds is fine.
echo "[5] the app actually launches"
launch_log=$(mktemp)
"$BIN" >"$launch_log" 2>&1 &
launch_pid=$!
sleep 4
if kill -0 "$launch_pid" 2>/dev/null; then
    kill "$launch_pid" 2>/dev/null
    wait "$launch_pid" 2>/dev/null || true
    note "ok - still running after 4s"
else
    wait "$launch_pid" 2>/dev/null || true
    if grep -q "Library not loaded\|dyld\[" "$launch_log"; then
        bad "exited at launch: $(grep -m1 'Library not loaded\|Reason:' "$launch_log")"
    else
        bad "exited immediately at launch; output: $(head -c 300 "$launch_log")"
    fi
fi
rm -f "$launch_log"

echo "[6] notarization ticket is stapled"
if xcrun stapler validate "$APP" >/dev/null 2>&1; then
    note "ok - notarization ticket stapled"
else
    bad "no notarization ticket stapled; macOS will refuse this on a user's machine
        (sign with a Developer ID, notarize, then staple)"
fi

echo "[7] Gatekeeper accepts the app"
assessment=$(spctl -a -t exec -vv "$APP" 2>&1 || true)
case "$assessment" in
    *accepted*) note "ok - $(echo "$assessment" | grep -i 'source=' | head -1)" ;;
    *) bad "Gatekeeper rejects this bundle: $(echo "$assessment" | head -1)" ;;
esac

if [ "$fail" -ne 0 ]; then
    echo "verify-macos-bundle: FAILED — this build will not run for your users" >&2
    exit 1
fi
echo "verify-macos-bundle: PASSED"
