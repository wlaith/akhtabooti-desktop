use std::path::PathBuf;
use std::{env, fs};

// Forces akhtabooti-core's extractous/GraalVM build to finish before this runs.
// See the note in Cargo.toml's [build-dependencies].
use akhtabooti_core as _;

fn main() {
    stage_tika_lib();
    tauri_build::build()
}

/// Copies libtika_native into `frameworks/`, where tauri.conf.json expects it.
/// Staging happens here because `tauri_build` checks those paths exist while
/// this script runs.
///
/// Only the copy happens here. Fixing the absolute install name GraalVM stamped
/// into the library is left to scripts/relocate-native-libs.sh, which runs after
/// linking, a build script can't tell which copy the binary actually linked.
/// Any copy is fine to stage: every extractous unit builds the same library.
fn stage_tika_lib() {
    // cfg!(target_os) reports the host here, not the build target.
    let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap_or_default();

    let lib_name = match target_os.as_str() {
        "macos" => "libtika_native.dylib",
        "linux" => "libtika_native.so",
        "windows" => "libtika_native.dll",
        _ => return,
    };

    let Some(src) = find_tika_lib(lib_name) else {
        panic!("{lib_name} not found; is akhtabooti-core building correctly?");
    };

    let dest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("frameworks");
    let dest = dest_dir.join(lib_name);

    if let Err(e) = fs::create_dir_all(&dest_dir).and_then(|_| fs::copy(&src, &dest)) {
        panic!("failed to stage {} -> {}: {e}", src.display(), dest.display());
    }

    println!("cargo:rerun-if-changed={}", src.display());
}

fn find_tika_lib(lib_name: &str) -> Option<PathBuf> {
    // Our OUT_DIR is a sibling of extractous's, two levels up under build/.
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
