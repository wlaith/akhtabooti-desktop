use akhtabooti_core::{search_directory, search_file, FilePIIs};
use std::path::Path;
use tauri_plugin_dialog::DialogExt;

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

#[tauri::command]
async fn export_report(app: tauri::AppHandle, contents: String) -> Result<bool, String> {
    let picked = app
        .dialog()
        .file()
        .set_file_name("scan-report.json")
        .add_filter("JSON", &["json"])
        .blocking_save_file();

    let Some(picked) = picked else {
        return Ok(false);
    };
    let path = picked.into_path().map_err(|e| e.to_string())?;

    tauri::async_runtime::spawn_blocking(move || std::fs::write(&path, contents))
        .await
        .map_err(|e| e.to_string())?
        .map_err(|e| e.to_string())?;

    Ok(true)
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .plugin(tauri_plugin_dialog::init())
        .invoke_handler(tauri::generate_handler![scan_path, export_report])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
