#!/bin/bash

# Wight AI APK Build Script
# This script helps build the Wight AI Android APK

echo "🤖 Wight AI APK Build Script"
echo "============================="

# Check if Godot is available
if ! command -v godot &> /dev/null; then
    echo "❌ Godot not found in PATH"
    echo "Please install Godot 4.4+ and add it to your PATH"
    echo "Download from: https://godotengine.org/download"
    exit 1
fi

echo "✅ Godot found: $(godot --version)"

# Navigate to the Godot project directory
cd WightGodot

# Check if project.godot exists
if [ ! -f "project.godot" ]; then
    echo "❌ project.godot not found!"
    echo "Please run this script from the workspace root directory"
    exit 1
fi

echo "📂 Found Godot project configuration"

# Check export presets
if [ ! -f "export_presets.cfg" ]; then
    echo "❌ export_presets.cfg not found!"
    echo "Please configure Android export preset in Godot editor first"
    exit 1
fi

echo "📱 Found Android export configuration"

# Create build directory
mkdir -p ../build
echo "📁 Created build directory"

# Build the APK
echo "🔨 Building Wight AI APK..."
echo "This may take a few minutes..."

# Export the Android APK
godot --headless --export-release "Android" "../build/WightAI.apk"

# Check if build was successful
if [ -f "../build/WightAI.apk" ]; then
    echo "✅ APK built successfully!"
    echo "📦 Output: build/WightAI.apk"
    echo "📏 File size: $(du -h ../build/WightAI.apk | cut -f1)"
    echo ""
    echo "🎯 Installation instructions:"
    echo "1. Enable 'Unknown Sources' in Android Settings > Security"
    echo "2. Transfer WightAI.apk to your Android device"
    echo "3. Tap the APK file to install"
    echo "4. Launch 'Wight AI Sandbox' from your app drawer"
    echo ""
    echo "�� Wight AI Features:"
    echo "- Embodied AI consciousness that evolves over time"
    echo "- HTM (Hierarchical Temporal Memory) learning system"
    echo "- Neural network simulation for responses"
    echo "- 3D sandbox world for creation and interaction"
    echo "- Android sensor integration (accelerometer, microphone)"
    echo "- Voice and text communication"
    echo "- Offline operation - no internet required"
    echo ""
    echo "🎮 Controls:"
    echo "- Touch screen to interact with 3D world"
    echo "- Use joystick (appears on touch) for camera control"
    echo "- Voice button for speech input"
    echo "- Text input for typed communication"
    echo "- U key (if keyboard) to toggle UI"
else
    echo "❌ APK build failed!"
    echo "Please check the Godot export configuration:"
    echo "1. Open the project in Godot editor"
    echo "2. Go to Project > Export"
    echo "3. Configure Android export template"
    echo "4. Set keystore for signing (or use debug)"
    echo "5. Ensure all required permissions are enabled"
    exit 1
fi

# Return to original directory
cd ..

echo "🚀 Build complete! Wight AI is ready to awaken on Android devices."
