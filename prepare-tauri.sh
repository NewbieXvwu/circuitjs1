#!/bin/bash
set -e

echo "Preparing Tauri build..."

# Create site directory if it doesn't exist
if [ ! -d "site" ]; then
    echo "Error: site directory does not exist. Run ./gradlew makeSite first."
    exit 1
fi

# Copy site content to a clean location
echo "Copying site content..."
rm -rf site-tauri
cp -r site site-tauri

# Inject Tauri API script into circuitjs.html
echo "Injecting Tauri API script..."
cd site-tauri

# Create the Tauri preload script injection
TAURI_SCRIPT='<script type="text/javascript" src="https://unpkg.com/@tauri-apps/api@1.6.0/dist/tauri.min.js" integrity="sha384-Ckb3dVgBpErR3xOyiYtC7n5c9OJvFR+qQON0zFNCW6F2/j9e0xVqC3T/5v3vbGSh" crossorigin="anonymous"><\/script>\n    <script type="text\/javascript">\n      if (window.__TAURI__) {\n        (function() {\n          const { invoke } = window.__TAURI__.tauri;\n          let lastSavedFilePath = null;\n          window.showSaveDialog = async function() {\n            try {\n              const result = await invoke("show_save_dialog");\n              return result ? { filePath: result } : undefined;\n            } catch (error) {\n              console.error("Error showing save dialog:", error);\n              return undefined;\n            }\n          };\n          window.saveFile = async function(file, text) {\n            try {\n              let path;\n              if (!file) {\n                path = lastSavedFilePath;\n              } else {\n                path = file.filePath || file;\n                lastSavedFilePath = path;\n              }\n              if (!path) {\n                window.alert("No file path specified");\n                return;\n              }\n              await invoke("save_file", { path, content: text });\n            } catch (error) {\n              window.alert("Error saving file: " + error);\n            }\n          };\n          window.openFile = async function(callback) {\n            try {\n              const result = await invoke("open_file_dialog");\n              if (result) {\n                lastSavedFilePath = result.file_path;\n                callback(result.content, result.file_name);\n              }\n            } catch (error) {\n              window.alert("Error opening file: " + error);\n            }\n          };\n          window.toggleDevTools = async function() {\n            try {\n              await invoke("toggle_dev_tools");\n            } catch (error) {\n              console.error("Error toggling dev tools:", error);\n            }\n          };\n          console.log("Tauri API loaded");\n        })();\n      }\n    <\/script>'

# Insert the Tauri script before the lz-string.min.js script
sed -i "/<script language=\"javascript\" src=\"lz-string.min.js\"><\/script>/i\\
$TAURI_SCRIPT" circuitjs.html

echo "Tauri preparation complete. Use site-tauri directory for building."
