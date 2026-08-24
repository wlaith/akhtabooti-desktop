use akhtabooti_core::{search_directory, search_file, FilePIIs};
use std::path::Path;

#[tauri::command]
async fn scan_path(path: String) -> Result<Vec<FilePIIs>, String> {
    tauri::async_runtime::spawn_blocking(move || {
        if Path::new(&path).is_dir() {
            search_directory(&path)
        } else {
            search_file(&path).map(|pii| vec![pii])
        }
    })
    .await
    .map_err(|e| e.to_string())?
    .map_err(|e| e.to_string())
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .plugin(tauri_plugin_dialog::init())
        .invoke_handler(tauri::generate_handler![scan_path])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
