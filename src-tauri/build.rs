use std::path::PathBuf;
use std::{env, fs};

fn main() {
    stage_tika_lib();
    tauri_build::build()
}

/// extractous builds libtika_native into a hash-suffixed directory under `target/`, but the bundler config needs a stable path, so copy it to `frameworks/`. akhtabooti-core's build script has already made the library's own name relocatable by the time this runs.
fn stage_tika_lib() {
    // In a build script `cfg!(target_os)` reports the host, not the build target, so read the target from Cargo instead.
    let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap_or_default();

    let lib_name = match target_os.as_str() {
        "macos" => "libtika_native.dylib",
        "linux" => "libtika_native.so",
        _ => return,
    };

    // a .deb/.rpm installs to absolute paths and has no so the binary needs an explicit search path. $ORIGIN is resolved by the loader at runtime relative to the executable, so /usr/bin/akhtabooti finds /usr/lib/akhtabooti/.
    if target_os == "linux" {
        println!("cargo:rustc-link-arg-bins=-Wl,-rpath,$ORIGIN/../lib/akhtabooti");
    }

    let Some(src) = find_tika_lib(lib_name) else {
        println!("cargo:warning={lib_name} not found; the bundled app will not start");
        return;
    };

    let dest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("frameworks");
    let dest = dest_dir.join(lib_name);

    if let Err(e) = fs::create_dir_all(&dest_dir).and_then(|_| fs::copy(&src, &dest)) {
        panic!("failed to stage {} -> {}: {e}", src.display(), dest.display());
    }
}

fn find_tika_lib(lib_name: &str) -> Option<PathBuf> {
    // Our OUT_DIR is a sibling of extractous's under `target/<profile>/build/`, so walk up two levels and look across for it.
    let out_dir = PathBuf::from(env::var("OUT_DIR").ok()?);
    let build_dir = out_dir.parent()?.parent()?;

    fs::read_dir(build_dir)
        .ok()?
        .filter_map(Result::ok)
        .map(|e| e.path())
        .filter(|p| {
            p.file_name()
                .and_then(|n| n.to_str())
                .is_some_and(|n| n.starts_with("extractous-"))
        })
        .map(|p| p.join("out").join("libs").join(lib_name))
        .find(|p| p.exists())
}
