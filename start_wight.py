#!/usr/bin/env python3
"""
Wight AI Agent Startup Script
Launches the AI backend and provides instructions for the Godot frontend
"""

import subprocess
import sys
import os
import time
from pathlib import Path

def check_dependencies():
    """Check if required dependencies are installed"""
    try:
        import numpy
        import scipy
        print("✓ Python dependencies found")
        return True
    except ImportError as e:
        print(f"✗ Missing Python dependency: {e}")
        print("Please run: pip install -r requirements.txt")
        return False

def check_godot_project():
    """Check if Godot project exists"""
    godot_project = Path("godot_frontend/project.godot")
    if godot_project.exists():
        print("✓ Godot project found")
        return True
    else:
        print("✗ Godot project not found")
        return False

def create_data_directory():
    """Ensure data directory exists"""
    Path("data").mkdir(exist_ok=True)
    print("✓ Data directory ready")

def main():
    print("=" * 50)
    print("🤖 WIGHT AI AGENT STARTUP")
    print("=" * 50)
    
    # Check dependencies
    if not check_dependencies():
        return 1
    
    if not check_godot_project():
        return 1
    
    create_data_directory()
    
    print("\n📋 STARTUP INSTRUCTIONS:")
    print("1. Keep this terminal open (AI backend)")
    print("2. Open Godot 4.4.1")
    print("3. Import project from: godot_frontend/project.godot")
    print("4. Press F5 to run the frontend")
    print("5. Start chatting with Wight!")
    
    print("\n🚀 Starting AI backend...")
    print("Press Ctrl+C to stop")
    print("-" * 50)
    
    # Start the Godot bridge
    try:
        from godot_bridge import GodotBridge
        bridge = GodotBridge()
        bridge.start_listening()
    except KeyboardInterrupt:
        print("\n👋 Wight AI Agent stopped")
        return 0
    except Exception as e:
        print(f"❌ Error starting AI backend: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())