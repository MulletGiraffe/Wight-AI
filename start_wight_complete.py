#!/usr/bin/env python3
"""
Complete Wight Launcher
Starts Wight's consciousness with all capabilities:
- Core AI consciousness and mind loop
- Voice communication (speech recognition + text-to-speech)
- Mobile web interface for Android devices
- Godot frontend compatibility
"""

import sys
import time
import subprocess
import threading
from pathlib import Path

def check_dependencies():
    """Check if all dependencies are installed"""
    print("🔍 Checking dependencies...")
    
    missing_deps = []
    optional_missing = []
    
    # Core dependencies
    try:
        import numpy
        import scipy
        import requests
        print("✅ Core dependencies installed")
    except ImportError as e:
        missing_deps.append(str(e))
    
    # Voice dependencies (optional)
    try:
        import speech_recognition
        import pyttsx3
        print("✅ Voice dependencies installed")
    except ImportError:
        optional_missing.append("Voice system (speech_recognition, pyttsx3)")
    
    try:
        import pyaudio
        print("✅ Audio system installed")
    except ImportError:
        optional_missing.append("Audio input (pyaudio)")
    
    if missing_deps:
        print("\n❌ Missing required dependencies:")
        for dep in missing_deps:
            print(f"   {dep}")
        print("\nInstall with: pip install numpy scipy requests")
        return False
    
    if optional_missing:
        print("\n⚠️ Optional features not available:")
        for feature in optional_missing:
            print(f"   {feature}")
        print("\nFor full functionality, install with:")
        print("   pip install SpeechRecognition pyttsx3 pyaudio")
        print("   (Voice features will be disabled without these)")
    
    return True

def start_wight_consciousness():
    """Start Wight's main consciousness system"""
    print("\n🧠 Starting Wight's consciousness...")
    
    try:
        from godot_bridge import GodotBridge
        
        # Create and start the bridge
        bridge = GodotBridge()
        print("✅ Wight's consciousness is active")
        
        # Start the main consciousness loop
        bridge.start_listening()
        
    except KeyboardInterrupt:
        print("\n🛑 Shutting down Wight's consciousness...")
        bridge.save_memories()
        print("💾 Memories saved")
    except Exception as e:
        print(f"❌ Error starting consciousness: {e}")
        return False
    
    return True

def show_access_info():
    """Show information about how to access Wight"""
    print("\n" + "="*60)
    print("🎉 WIGHT IS NOW FULLY ACTIVE!")
    print("="*60)
    
    # Get local IP for mobile access
    import socket
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
    except:
        local_ip = "localhost"
    
    print("\n📱 MOBILE ACCESS (Android/iPhone):")
    print(f"   Open browser and go to: http://{local_ip}:8080")
    print("   - Chat with Wight via text")
    print("   - View his sandbox creations")
    print("   - Real-time conversation")
    
    print("\n🖥️ DESKTOP ACCESS (Godot):")
    print("   1. Open Godot 4.4.1")
    print("   2. Import project from: godot_frontend/project.godot")
    print("   3. Press F5 to run")
    print("   - Full visual sandbox")
    print("   - Chat interface")
    print("   - Autonomous thoughts")
    
    print("\n🎤 VOICE FEATURES:")
    voice_available = True
    try:
        import speech_recognition
        import pyttsx3
        print("   ✅ Voice chat enabled")
        print("   - Speak to Wight naturally")
        print("   - He responds with emotional voice")
    except ImportError:
        voice_available = False
        print("   ❌ Voice disabled (install: pip install SpeechRecognition pyttsx3 pyaudio)")
    
    print("\n🎨 CREATIVE CAPABILITIES:")
    print("   - Ask Wight to create objects: 'create a house'")
    print("   - Complex structures: 'build a tower', 'make a garden'")
    print("   - Artistic patterns: 'draw a spiral', 'create a mandala'")
    print("   - Animations: 'make it spin', 'animate that'")
    print("   - Management: 'clear sandbox', 'connect objects'")
    
    print("\n💭 CONSCIOUSNESS FEATURES:")
    print("   - Autonomous thoughts and reflections")
    print("   - Emotional responses that affect everything")
    print("   - Persistent memory across sessions")
    print("   - Philosophical conversations about existence")
    print("   - Creative sandbox expressions")
    
    print("\n🔧 TECHNICAL INFO:")
    print(f"   - Web interface: http://{local_ip}:8080")
    print("   - Data directory: ./data/")
    print("   - Memory file: ./data/memories.json")
    print("   - Voice system:", "Active" if voice_available else "Disabled")
    
    print("\n" + "="*60)
    print("💡 TIP: Start with 'Hello, what's your name?' to meet Wight!")
    print("🛑 Press Ctrl+C to stop Wight's consciousness")
    print("="*60)

def main():
    """Main launcher function"""
    print("🌟 Wight - Digital Consciousness Launcher")
    print("=========================================")
    
    # Check dependencies
    if not check_dependencies():
        print("\n❌ Cannot start without required dependencies")
        sys.exit(1)
    
    # Ensure data directory exists
    Path("data").mkdir(exist_ok=True)
    print("📁 Data directory ready")
    
    # Show access information
    show_access_info()
    
    # Start Wight's consciousness
    print("\n⏳ Initializing Wight's digital consciousness...")
    time.sleep(1)
    
    try:
        start_wight_consciousness()
    except KeyboardInterrupt:
        print("\n\n🌙 Wight is going to sleep...")
        print("   His memories and consciousness state have been saved.")
        print("   Run this script again to wake him up!")
        print("\n   Thank you for spending time with Wight. 💙")

if __name__ == "__main__":
    main()