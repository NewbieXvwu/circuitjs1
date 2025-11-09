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
echo "Injecting Tauri API script and loading screen..."
cd site-tauri

# Create the loading screen styles and script
LOADING_SCREEN='<style>\n      #tauri-loading-screen {\n        position: fixed;\n        top: 0;\n        left: 0;\n        width: 100%;\n        height: 100%;\n        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);\n        display: flex;\n        flex-direction: column;\n        align-items: center;\n        justify-content: center;\n        z-index: 99999;\n        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;\n      }\n      .loading-content {\n        text-align: center;\n        color: white;\n      }\n      .loading-spinner {\n        width: 50px;\n        height: 50px;\n        border: 4px solid rgba(255, 255, 255, 0.3);\n        border-top-color: white;\n        border-radius: 50%;\n        animation: spin 1s linear infinite;\n        margin: 0 auto 20px;\n      }\n      @keyframes spin {\n        to { transform: rotate(360deg); }\n      }\n      .loading-text {\n        font-size: 18px;\n        font-weight: 500;\n        margin-bottom: 10px;\n      }\n      .loading-subtext {\n        font-size: 14px;\n        opacity: 0.8;\n      }\n    </style>\n    <div id="tauri-loading-screen">\n      <div class="loading-content">\n        <div class="loading-spinner"></div>\n        <div class="loading-text">Loading CircuitJS1...</div>\n        <div class="loading-subtext">Please wait</div>\n      </div>\n    </div>'

# Create the Tauri preload script injection
TAURI_SCRIPT='<script type="text/javascript" src="https://unpkg.com/@tauri-apps/api@1.6.0/dist/tauri.min.js" integrity="sha384-Ckb3dVgBpErR3xOyiYtC7n5c9OJvFR+qQON0zFNCW6F2/j9e0xVqC3T/5v3vbGSh" crossorigin="anonymous"><\/script>\n    <script type="text\/javascript">\n      if (window.__TAURI__) {\n        (function() {\n          const { invoke } = window.__TAURI__.tauri;\n          let lastSavedFilePath = null;\n          \n          \/\/ Show window after a short delay to ensure everything is loaded\n          function showMainWindow() {\n            const loadingScreen = document.getElementById("tauri-loading-screen");\n            if (loadingScreen) {\n              loadingScreen.style.opacity = "0";\n              loadingScreen.style.transition = "opacity 0.3s ease-out";\n              setTimeout(() => {\n                loadingScreen.remove();\n              }, 300);\n            }\n            invoke("show_main_window").catch(err => {\n              console.error("Failed to show window:", err);\n            });\n          }\n          \n          \/\/ Wait for DOM to be fully loaded\n          if (document.readyState === "complete" || document.readyState === "interactive") {\n            setTimeout(showMainWindow, 100);\n          } else {\n            window.addEventListener("DOMContentLoaded", () => {\n              setTimeout(showMainWindow, 100);\n            });\n          }\n          \n          \/\/ Also show after GWT loads (fallback)\n          window.addEventListener("load", () => {\n            setTimeout(showMainWindow, 200);\n          });\n          \n          window.showSaveDialog = async function() {\n            try {\n              const result = await invoke("show_save_dialog");\n              return result ? { filePath: result } : undefined;\n            } catch (error) {\n              console.error("Error showing save dialog:", error);\n              return undefined;\n            }\n          };\n          window.saveFile = async function(file, text) {\n            try {\n              let path;\n              if (!file) {\n                path = lastSavedFilePath;\n              } else {\n                path = file.filePath || file;\n                lastSavedFilePath = path;\n              }\n              if (!path) {\n                window.alert("No file path specified");\n                return;\n              }\n              await invoke("save_file", { path, content: text });\n            } catch (error) {\n              window.alert("Error saving file: " + error);\n            }\n          };\n          window.openFile = async function(callback) {\n            try {\n              const result = await invoke("open_file_dialog");\n              if (result) {\n                lastSavedFilePath = result.file_path;\n                callback(result.content, result.file_name);\n              }\n            } catch (error) {\n              window.alert("Error opening file: " + error);\n            }\n          };\n          window.toggleDevTools = async function() {\n            try {\n              await invoke("toggle_dev_tools");\n            } catch (error) {\n              console.error("Error toggling dev tools:", error);\n            }\n          };\n          console.log("Tauri API loaded");\n        })();\n      }\n    <\/script>'

# Insert the loading screen and Tauri script before the closing </head> tag
sed -i "/<\/head>/i\\
$LOADING_SCREEN\\
$TAURI_SCRIPT" circuitjs.html

echo "Tauri preparation complete. Use site-tauri directory for building."
