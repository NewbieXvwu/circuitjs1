// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::fs;
use std::path::PathBuf;
use tauri::{Manager, Window};

#[tauri::command]
async fn show_save_dialog(window: Window) -> Result<Option<String>, String> {
    use tauri::api::dialog::FileDialogBuilder;
    
    let (tx, rx) = std::sync::mpsc::channel();
    
    FileDialogBuilder::new()
        .set_title("Save Circuit")
        .add_filter("Circuit Files", &["txt"])
        .add_filter("All Files", &["*"])
        .save_file(move |file_path| {
            tx.send(file_path).ok();
        });
    
    match rx.recv() {
        Ok(Some(path)) => Ok(Some(path.to_string_lossy().to_string())),
        Ok(None) => Ok(None),
        Err(_) => Err("Failed to receive file path".to_string()),
    }
}

#[tauri::command]
async fn save_file(path: String, content: String) -> Result<(), String> {
    fs::write(&path, content).map_err(|e| e.to_string())
}

#[tauri::command]
async fn open_file_dialog(window: Window) -> Result<Option<FileData>, String> {
    use tauri::api::dialog::FileDialogBuilder;
    
    let (tx, rx) = std::sync::mpsc::channel();
    
    FileDialogBuilder::new()
        .set_title("Open Circuit")
        .add_filter("Circuit Files", &["txt"])
        .add_filter("All Files", &["*"])
        .pick_file(move |file_path| {
            tx.send(file_path).ok();
        });
    
    match rx.recv() {
        Ok(Some(path)) => {
            let content = fs::read_to_string(&path).map_err(|e| e.to_string())?;
            let file_name = path
                .file_name()
                .and_then(|n| n.to_str())
                .unwrap_or("unknown")
                .to_string();
            Ok(Some(FileData {
                content,
                file_name,
                file_path: path.to_string_lossy().to_string(),
            }))
        }
        Ok(None) => Ok(None),
        Err(_) => Err("Failed to receive file path".to_string()),
    }
}

#[derive(serde::Serialize)]
struct FileData {
    content: String,
    file_name: String,
    file_path: String,
}

#[tauri::command]
fn toggle_dev_tools(window: Window) {
    #[cfg(debug_assertions)]
    {
        if window.is_devtools_open() {
            window.close_devtools();
        } else {
            window.open_devtools();
        }
    }
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            show_save_dialog,
            save_file,
            open_file_dialog,
            toggle_dev_tools
        ])
        .setup(|app| {
            let window = app.get_window("main").unwrap();
            
            // Handle command line arguments
            let args: Vec<String> = std::env::args().collect();
            if args.len() > 1 {
                let file_path = &args[1];
                if let Ok(content) = fs::read_to_string(file_path) {
                    let _ = window.eval(&format!(
                        "window.startCircuitText = {};",
                        serde_json::to_string(&content).unwrap_or_else(|_| "null".to_string())
                    ));
                }
            }
            
            Ok(())
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
