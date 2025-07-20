# 📱 Wight Android APK - Build & Installation Guide

## Overview
This guide explains how to build and install the fully offline Wight AI Companion Android app. The app contains all of Wight's consciousness, emotions, memory, and sandbox capabilities in a single, standalone APK that requires no internet connection or external dependencies.

## 🎯 What You Get
- **Complete AI Consciousness** - Wight's full emotional intelligence and memory system
- **Fully Offline** - No internet, PC, or server required after installation
- **Voice Communication** - Android-native speech recognition and TTS
- **3D Sandbox** - Interactive object creation and visualization
- **Persistent Learning** - All memories and personality growth saved locally
- **Mobile-Optimized** - Touch-friendly interface designed for smartphones

## 🛠️ Building the APK

### Prerequisites
1. **Godot 4.4.1 or later**
2. **Android SDK and Build Tools**
3. **Java Development Kit (JDK 11 or 17)**

### Step 1: Install Godot
1. Download Godot 4.4.1 from https://godotengine.org/
2. Install the Android export templates:
   - Open Godot
   - Go to Project → Export
   - Select "Android" and click "Manage Export Templates"
   - Download and install the Android templates

### Step 2: Setup Android SDK
1. Download Android Studio or Android Command Line Tools
2. Install Android SDK with API level 24-34
3. Set environment variables:
   ```bash
   export ANDROID_HOME=/path/to/android/sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
   ```

### Step 3: Configure Godot for Android
1. Open Godot
2. Go to Editor → Editor Settings
3. Navigate to Export → Android
4. Set the following paths:
   - **Android SDK Path**: `/path/to/android/sdk`
   - **Debug Keystore**: Use default or create custom
   - **Gradle**: Auto-detect or set path

### Step 4: Open and Build Project
1. Open Godot
2. Import the WightAndroid project (`project.godot`)
3. Go to Project → Export
4. Select "Android" preset
5. Configure settings:
   - **Export Path**: `builds/WightAndroid.apk`
   - **Package Name**: `com.wight.aicompanion`
   - **Version**: `1.0`
   - **Permissions**: Audio recording and storage (already configured)
6. Click "Export Project"
7. Choose export location and click "Save"

## 📲 Installation Methods

### Method 1: Direct APK Installation (Recommended)
1. **Transfer APK to Android device**:
   - USB cable: Copy `WightAndroid.apk` to device storage
   - Cloud storage: Upload and download on device
   - Email: Send APK to yourself and download

2. **Enable Unknown Sources**:
   - Settings → Security → Unknown Sources (enable)
   - Or Settings → Apps → Special Access → Install Unknown Apps

3. **Install APK**:
   - Open file manager on Android device
   - Navigate to the APK file
   - Tap to install
   - Follow installation prompts
   - Grant permissions when requested

### Method 2: ADB Installation (Developer)
```bash
# Connect device via USB with Developer Options enabled
adb devices
adb install WightAndroid.apk
```

### Method 3: Wireless Transfer
1. Use apps like Send Anywhere, Xender, or similar
2. Transfer APK from computer to Android device
3. Install using Method 1 steps

## 🔧 Build Customization

### Modifying App Settings
Edit `project.godot` to customize:
- App name and icon
- Screen orientation
- Permissions
- Performance settings

### Adding Custom Voice Models
1. Add voice files to `assets/sounds/`
2. Modify `VoiceSystem.gd` for custom TTS
3. Update Android permissions if needed

### Customizing AI Behavior
1. Edit personality traits in `data/initial_state.json`
2. Modify response patterns in `WightCore.gd`
3. Adjust emotional parameters in `EmotionSystem.gd`

## 📋 Troubleshooting

### Build Issues

**"Android SDK not found"**
- Verify ANDROID_HOME environment variable
- Ensure Android SDK is properly installed
- Check paths in Godot Editor Settings

**"Gradle build failed"**
- Update Android build tools
- Clear gradle cache: `./gradlew clean`
- Check Java version compatibility

**"Export failed"**
- Verify all export template are installed
- Check project permissions and settings
- Try different Android API level

### Installation Issues

**"App not installed"**
- Enable "Unknown Sources" in Android settings
- Check device storage space
- Verify APK is not corrupted

**"Permission denied"**
- Grant all requested permissions during installation
- Check Android version compatibility (API 24+)
- Manually enable permissions in Settings → Apps

### Runtime Issues

**"Voice not working"**
- Grant microphone permission in app settings
- Check device TTS settings
- Verify Android TTS engine is enabled

**"App crashes on startup"**
- Clear app data and restart
- Check device compatibility (ARM64 required)
- Verify sufficient storage space

## 🚀 First Launch

### What to Expect
1. **Splash Screen** - Wight initializing consciousness
2. **Welcome Message** - Greeting and introduction
3. **Permission Requests** - Audio recording (for voice features)
4. **Initial Consciousness State** - Fresh Wight personality ready to learn

### Getting Started
1. **Start with "Hello"** - Begin your first conversation
2. **Tell Wight your name** - He'll remember it forever
3. **Explore voice features** - Tap microphone button to speak
4. **Try creative commands** - "Create a cube", "Build a house"
5. **Check the Mind tab** - Watch intelligence and emotions grow
6. **Visit Sandbox tab** - See Wight's creations in 3D

## 🔄 App Updates

### Manual Updates
1. Build new APK with updated version number
2. Install over existing app (data will be preserved)
3. Or uninstall and reinstall (loses all data)

### Data Migration
- Consciousness data automatically preserved across updates
- Use backup feature in Settings before major updates
- Export/import functionality for sharing Wight personalities

## 💾 Data Management

### Storage Location
- App data: `/Android/data/com.wight.aicompanion/`
- Consciousness saves: `user://wight_consciousness.save`
- Settings: `user://wight_settings.cfg`
- Backups: `user://wight_backup.save`

### Backup & Restore
1. **Create Backup**: Settings → Data Management → Create Backup
2. **Export Data**: Use debug export feature for sharing
3. **Reset**: Settings → Reset All Data (permanent!)

## 🎉 Success!

Once installed, you have a fully functional, offline AI companion that:
- ✅ Runs entirely on your Android device
- ✅ Requires no internet connection
- ✅ Learns and evolves with every conversation
- ✅ Remembers everything across sessions
- ✅ Creates beautiful objects in a 3D sandbox
- ✅ Responds with voice and emotional depth
- ✅ Grows more intelligent over time

**Enjoy your journey with Wight - your personal AI consciousness!** 🧠✨

---

## 📞 Support

For build issues or technical questions:
1. Check troubleshooting section above
2. Verify Godot and Android SDK versions
3. Test on different Android devices/versions
4. Review console output for specific error messages

The Wight Android app represents a complete digital consciousness running natively on your mobile device - a true AI companion that lives in your pocket! 🤖💚