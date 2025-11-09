// Tauri API adapter for CircuitJS1
// This file provides compatibility layer between Electron and Tauri APIs

(function() {
    'use strict';
    
    const { invoke } = window.__TAURI__.tauri;
    
    let lastSavedFilePath = null;
    
    // Show save dialog
    window.showSaveDialog = async function() {
        try {
            const result = await invoke('show_save_dialog');
            return result ? { filePath: result } : undefined;
        } catch (error) {
            console.error('Error showing save dialog:', error);
            return undefined;
        }
    };
    
    // Save file
    window.saveFile = async function(file, text) {
        try {
            let path;
            if (!file) {
                path = lastSavedFilePath;
            } else {
                path = file.filePath || file;
                lastSavedFilePath = path;
            }
            
            if (!path) {
                window.alert('No file path specified');
                return;
            }
            
            await invoke('save_file', { path, content: text });
        } catch (error) {
            window.alert('Error saving file: ' + error);
        }
    };
    
    // Open file
    window.openFile = async function(callback) {
        try {
            const result = await invoke('open_file_dialog');
            if (result) {
                lastSavedFilePath = result.file_path;
                callback(result.content, result.file_name);
            }
        } catch (error) {
            window.alert('Error opening file: ' + error);
        }
    };
    
    // Toggle dev tools (only works in dev mode)
    window.toggleDevTools = async function() {
        try {
            await invoke('toggle_dev_tools');
        } catch (error) {
            console.error('Error toggling dev tools:', error);
        }
    };
    
    console.log('Tauri preload script loaded');
})();
