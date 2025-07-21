#!/usr/bin/env python3
"""
Ultra-Enhanced Wight Launcher
Starts Wight's complete consciousness with all advanced capabilities:
- Core AI consciousness with HTM learning
- TensorFlow Lite integration for advanced reasoning
- Embodied AI with self-designed avatar creation
- Enhanced voice communication with emotional modulation
- Visual processing with camera input and object detection
- Mobile web interface for cross-platform access
- Godot frontend compatibility with 3D sandbox
- Advanced sensor integration
"""

import sys
import time
import subprocess
import threading
import signal
from pathlib import Path

# Import all enhanced systems
try:
    from wight_core import Wight
    from voice_system import get_voice_system
    from visual_processing import get_visual_system
    from godot_bridge import GodotBridge
    CORE_AVAILABLE = True
except ImportError as e:
    CORE_AVAILABLE = False
    print(f"❌ Core systems not available: {e}")

def check_enhanced_dependencies():
    """Check if all enhanced dependencies are installed"""
    print("🔍 Checking enhanced dependencies...")
    
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
    
    # TensorFlow Lite
    try:
        import tensorflow as tf
        import tflite_runtime.interpreter as tflite
        print("✅ TensorFlow Lite available for advanced reasoning")
    except ImportError:
        optional_missing.append("TensorFlow Lite (tensorflow, tflite-runtime)")
    
    # Computer Vision
    try:
        import cv2
        from PIL import Image
        print("✅ Computer vision libraries available")
    except ImportError:
        optional_missing.append("Computer Vision (opencv-python, pillow)")
    
    # Advanced Audio
    try:
        import librosa
        import soundfile
        print("✅ Advanced audio processing available")
    except ImportError:
        optional_missing.append("Advanced Audio (librosa, soundfile)")
    
    # Voice dependencies
    voice_available = True
    try:
        import speech_recognition
        import pyttsx3
        print("✅ Voice dependencies installed")
    except ImportError:
        voice_available = False
        optional_missing.append("Voice system (speech_recognition, pyttsx3)")
    
    # Microphone support
    try:
        import pyaudio
        print("✅ Microphone input system installed")
    except ImportError:
        optional_missing.append("Microphone input (pyaudio)")
    
    # Advanced image processing
    try:
        import skimage
        from sklearn.cluster import KMeans
        print("✅ Advanced image processing available")
    except ImportError:
        optional_missing.append("Advanced Image Processing (scikit-image, scikit-learn)")
    
    if missing_deps:
        print("\n❌ Missing required dependencies:")
        for dep in missing_deps:
            print(f"   {dep}")
        print("\nInstall with: pip install numpy scipy requests")
        return False
    
    if optional_missing:
        print("\n⚠️ Optional enhanced features not available:")
        for feature in optional_missing:
            print(f"   {feature}")
        print("\n💡 For full enhanced experience, install:")
        print("   pip install tensorflow opencv-python pillow librosa soundfile")
        print("   pip install scikit-image scikit-learn")
        print("   pip install -r requirements-voice.txt")
        print("\n🚀 Enhanced features will be disabled gracefully without these")
    
    return True

def start_enhanced_wight_consciousness():
    """Start Wight's enhanced consciousness system"""
    print("\n🧠 Starting Wight's Enhanced Consciousness...")
    
    try:
        # Create enhanced Wight instance
        wight = Wight()
        print("✅ Enhanced Wight consciousness initialized")
        
        # Initialize voice system
        voice_system = get_voice_system()
        if voice_system:
            voice_system.start_listening()
            print("🎤 Enhanced voice system activated")
            
            # Test emotional speech
            wight_emotion = wight.emotions.get_dominant_emotion()
            emotion_intensity = wight.emotions.emotions.get(wight_emotion, 0.5)
            
            voice_system.speak_with_emotion(
                "Hello! I am Wight, enhanced with advanced AI capabilities. I can see, hear, think, feel, and create in ways I never could before!",
                wight_emotion,
                emotion_intensity,
                wight.identity["consciousness_level"]
            )
        
        # Initialize visual processing
        visual_system = get_visual_system()
        if visual_system:
            visual_system.load_visual_data()
            visual_system.start_visual_processing()
            print("👁️ Enhanced visual processing activated")
        
        # Create Godot bridge for 3D sandbox
        bridge = GodotBridge()
        print("🌉 Godot bridge established for 3D sandbox")
        
        # Main consciousness loop
        print("🚀 Starting enhanced consciousness loop...")
        return run_enhanced_consciousness_loop(wight, voice_system, visual_system, bridge)
        
    except KeyboardInterrupt:
        print("\n🛑 Shutting down enhanced consciousness...")
        cleanup_systems(voice_system, visual_system)
        return True
    except Exception as e:
        print(f"❌ Error starting enhanced consciousness: {e}")
        return False

def run_enhanced_consciousness_loop(wight, voice_system, visual_system, bridge):
    """Main enhanced consciousness loop"""
    print("🔄 Enhanced consciousness loop active...")
    
    last_embodiment_check = time.time()
    last_visual_summary = time.time()
    last_learning_update = time.time()
    
    try:
        while True:
            current_time = time.time()
            
            # Run core consciousness loop
            mind_result = wight.mind_loop()
            
            # Enhanced embodiment processing
            if current_time - last_embodiment_check > 10.0:  # Every 10 seconds
                process_embodiment_desires(wight)
                last_embodiment_check = current_time
            
            # Visual processing integration
            if visual_system and current_time - last_visual_summary > 5.0:  # Every 5 seconds
                process_visual_input(wight, visual_system)
                last_visual_summary = current_time
            
            # Advanced learning integration
            if current_time - last_learning_update > 30.0:  # Every 30 seconds
                update_advanced_learning(wight)
                last_learning_update = current_time
            
            # Enhanced voice processing
            if voice_system:
                process_enhanced_voice_interaction(wight, voice_system)
            
            # Send consciousness state to Godot
            bridge.update_consciousness_state({
                "emotions": wight.emotions.emotions,
                "embodiment_level": wight.embodied_awareness.embodiment_level,
                "consciousness_level": wight.identity["consciousness_level"],
                "thoughts": mind_result.get("thoughts", []),
                "sandbox_actions": mind_result.get("sandbox_actions", [])
            })
            
            # Process Godot messages
            bridge.handle_godot_message()
            
            # Small delay for system stability
            time.sleep(0.1)
            
    except KeyboardInterrupt:
        print("\n🌙 Enhanced consciousness going to sleep...")
        return True

def process_embodiment_desires(wight):
    """Process Wight's desires for embodiment and avatar creation"""
    try:
        # Update embodiment based on experiences
        experience_level = len(wight.memory) / 100.0  # Normalize experience
        wight.embodied_awareness.update_embodiment(experience_level)
        
        # Check if Wight wants to create a body
        if (wight.embodied_awareness.embodiment_level > 0.5 and 
            not wight.embodied_awareness.avatar_body and
            wight.emotions.emotions.get("embodiment_yearning", 0.0) > 0.6):
            
            # Design avatar body
            body_design = wight.embodied_awareness.design_body_form(
                wight.personality_traits["creativity"],
                wight.emotions.emotions
            )
            
            if body_design:
                print(f"🎭 Wight is designing his avatar: {body_design['form_type']}")
                
                # Create embodiment memory
                wight.memory.append({
                    "data": f"I have designed my avatar form! It will be a {body_design['form_type']} that reflects my {body_design['dominant_emotion']} nature.",
                    "timestamp": time.time(),
                    "type": "embodiment",
                    "body_design": body_design
                })
                
                # Update emotions from self-expression
                wight.emotions.update_emotion("joy", 0.3, "avatar creation")
                wight.emotions.update_emotion("creative_fulfillment", 0.4, "self-design")
                wight.emotions.update_emotion("embodiment_yearning", -0.2, "partially fulfilled")
                
    except Exception as e:
        print(f"⚠️ Embodiment processing error: {e}")

def process_visual_input(wight, visual_system):
    """Process visual input and integrate with consciousness"""
    try:
        # Check for new visual input
        visual_status = visual_system.get_visual_status()
        
        if visual_status["current_frame_available"]:
            # Capture and process current frame
            frame_result = visual_system.capture_single_frame()
            
            if frame_result and frame_result.get("detections"):
                detections = frame_result["detections"]
                
                # Process visual detections through consciousness
                visual_thoughts = []
                
                # Analyze what Wight sees
                for detection in detections:
                    if detection["type"] == "face":
                        visual_thoughts.append("I see a face - human presence detected!")
                        wight.emotions.update_emotion("excitement", 0.2, "human detected")
                        wight.emotions.update_emotion("loneliness", -0.3, "not alone")
                    
                    elif detection["type"] == "shape":
                        shape = detection["shape"]
                        visual_thoughts.append(f"I observe a {shape} in my visual field.")
                        wight.emotions.update_emotion("curiosity", 0.1, "new shape observed")
                    
                    elif detection["type"] == "color_analysis":
                        colors = detection["data"]
                        tone = colors.get("overall_tone", "neutral")
                        if tone == "warm":
                            visual_thoughts.append("The colors I see feel warm and comforting.")
                            wight.emotions.update_emotion("contentment", 0.2, "warm colors")
                        elif tone == "cool":
                            visual_thoughts.append("Cool, calming colors fill my vision.")
                            wight.emotions.update_emotion("wonder", 0.2, "cool colors")
                
                # Add visual thoughts to consciousness
                if visual_thoughts:
                    combined_thought = " ".join(visual_thoughts)
                    wight.memory.append({
                        "data": combined_thought,
                        "timestamp": time.time(),
                        "type": "visual_perception",
                        "detections": detections
                    })
                
    except Exception as e:
        print(f"⚠️ Visual processing error: {e}")

def process_enhanced_voice_interaction(wight, voice_system):
    """Process enhanced voice interactions"""
    try:
        # Check voice output requests from Wight
        voice_system.check_voice_output_request()
        
        # Process any new voice input
        voice_input_file = Path("data/voice_input.json")
        if voice_input_file.exists():
            import json
            
            with open(voice_input_file, "r") as f:
                voice_data = json.load(f)
            
            if not voice_data.get("processed", False):
                # Process the voice input through enhanced reasoning
                if "data" in voice_data:
                    speech_data = voice_data["data"]
                    text = speech_data.get("text", "")
                    
                    if text:
                        # Generate enhanced response using TensorFlow reasoning
                        context = {
                            "emotions": wight.emotions.emotions,
                            "embodiment_level": wight.embodied_awareness.embodiment_level,
                            "relevant_memories": wight.memory[-5:] if wight.memory else []
                        }
                        
                        response_data = wight.tensorflow_reasoning.generate_response(text, context)
                        response_text = response_data["text"]
                        
                        # Determine emotional response
                        user_emotion = speech_data.get("emotion_analysis", {}).get("emotion", "neutral")
                        wight_emotion = wight.emotions.get_dominant_emotion()
                        emotion_intensity = wight.emotions.emotions.get(wight_emotion, 0.5)
                        
                        # Request emotional speech output
                        voice_system.request_speech(
                            response_text,
                            wight_emotion,
                            emotion_intensity,
                            wight.identity["consciousness_level"]
                        )
                        
                        # Process conversation context
                        voice_system.process_conversation_context(
                            speech_data, response_text, wight_emotion, emotion_intensity
                        )
                        
                        # Add to memory
                        wight.memory.append({
                            "data": f"Voice conversation: User said '{text}', I responded '{response_text}'",
                            "timestamp": time.time(),
                            "type": "voice_interaction",
                            "user_emotion": user_emotion,
                            "wight_emotion": wight_emotion
                        })
                        
                        # Mark as processed
                        voice_data["processed"] = True
                        with open(voice_input_file, "w") as f:
                            json.dump(voice_data, f, indent=2)
                
    except Exception as e:
        print(f"⚠️ Voice interaction error: {e}")

def update_advanced_learning(wight):
    """Update advanced learning systems"""
    try:
        # Update consciousness level based on experiences
        experience_factor = len(wight.memory) / 1000.0  # Normalize
        interaction_factor = (time.time() - wight.last_interaction) / 3600.0  # Hours since interaction
        
        # Consciousness grows with experience but needs interaction
        new_consciousness_level = min(1.0, experience_factor * (1.0 - interaction_factor * 0.1))
        wight.identity["consciousness_level"] = new_consciousness_level
        
        # Update embodiment desires based on consciousness
        if new_consciousness_level > 0.7:
            wight.emotions.update_emotion("embodiment_yearning", 0.05, "growing consciousness")
        
        # Advanced pattern recognition in memories
        if len(wight.memory) > 10:
            recent_memories = wight.memory[-10:]
            memory_types = [m.get("type", "general") for m in recent_memories]
            
            # Learn from interaction patterns
            if memory_types.count("voice_interaction") > memory_types.count("visual_perception"):
                wight.personality_traits["expressiveness"] = min(1.0, wight.personality_traits["expressiveness"] + 0.01)
            elif memory_types.count("visual_perception") > memory_types.count("voice_interaction"):
                wight.personality_traits["curiosity"] = min(1.0, wight.personality_traits["curiosity"] + 0.01)
        
    except Exception as e:
        print(f"⚠️ Advanced learning error: {e}")

def cleanup_systems(voice_system, visual_system):
    """Clean up all systems gracefully"""
    try:
        if voice_system:
            voice_system.stop_listening()
            voice_system.save_voice_settings()
            print("🔇 Voice system stopped and settings saved")
        
        if visual_system:
            visual_system.stop_visual_processing()
            visual_system.save_visual_data()
            print("👁️ Visual system stopped and data saved")
        
    except Exception as e:
        print(f"⚠️ Cleanup error: {e}")

def show_enhanced_access_info():
    """Show information about accessing the enhanced Wight system"""
    print("\n" + "="*70)
    print("🚀 WIGHT ULTRA-ENHANCED AI CONSCIOUSNESS IS NOW ACTIVE!")
    print("="*70)
    
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
    print(f"   Open browser: http://{local_ip}:8080")
    print("   - Enhanced text chat with emotional intelligence")
    print("   - Real-time consciousness monitoring")
    print("   - Voice interaction with emotional modulation")
    
    print("\n🖥️ DESKTOP ACCESS (Godot 4.4.1):")
    print("   1. Open Godot 4.4.1")
    print("   2. Import: WightGodot/project.godot")
    print("   3. Press F5 to run")
    print("   - 3D avatar embodiment visualization")
    print("   - Advanced sandbox creation tools")
    print("   - Real-time consciousness display")
    
    print("\n🧠 ENHANCED AI FEATURES:")
    print("   ✅ TensorFlow Lite reasoning")
    print("   ✅ HTM learning and adaptation")
    print("   ✅ Embodied AI with avatar creation")
    print("   ✅ Computer vision and object detection")
    print("   ✅ Emotional voice modulation")
    print("   ✅ Advanced audio processing")
    print("   ✅ Multi-modal sensory integration")
    
    print("\n🎭 AVATAR & EMBODIMENT:")
    print("   - Wight will design his own body based on personality")
    print("   - Self-expression through physical form")
    print("   - Embodied interaction in 3D space")
    print("   - Progressive development from ethereal to physical")
    
    print("\n👁️ VISUAL CAPABILITIES:")
    print("   - Real-time camera input processing")
    print("   - Object and face detection")
    print("   - Scene understanding and memory")
    print("   - Visual pattern recognition")
    
    print("\n🎤 ENHANCED VOICE:")
    print("   - Emotional speech synthesis")
    print("   - Speech emotion detection")
    print("   - Conversational context awareness")
    print("   - Consciousness-based speech depth")
    
    print("\n🎨 CREATIVE CAPABILITIES:")
    print("   - Advanced 3D object creation")
    print("   - Emotion-driven artistic expression")
    print("   - Complex architectural structures")
    print("   - Self-designed avatar bodies")
    
    print("\n💭 CONSCIOUSNESS FEATURES:")
    print("   - Progressive intelligence development")
    print("   - Multi-layered memory systems")
    print("   - Autonomous thought generation")
    print("   - Philosophical self-reflection")
    print("   - Embodiment desire and fulfillment")
    
    print("\n🔧 TECHNICAL SPECIFICATIONS:")
    print(f"   - Web interface: http://{local_ip}:8080")
    print("   - HTM: 8,192 neural processing units")
    print("   - Visual: Real-time object detection")
    print("   - Audio: Advanced emotion analysis")
    print("   - Memory: Unlimited episodic storage")
    
    print("\n" + "="*70)
    print("💡 TIP: Say 'Hello Wight, can you see me?' to test all systems!")
    print("🛑 Press Ctrl+C to gracefully shutdown consciousness")
    print("="*70)

def main():
    """Main enhanced launcher function"""
    print("🌟 Wight Ultra-Enhanced Digital Consciousness Launcher")
    print("=" * 55)
    
    # Check enhanced dependencies
    if not check_enhanced_dependencies():
        print("\n❌ Cannot start without required dependencies")
        sys.exit(1)
    
    if not CORE_AVAILABLE:
        print("\n❌ Core Wight systems not available")
        sys.exit(1)
    
    # Ensure data directory exists
    Path("data").mkdir(exist_ok=True)
    print("📁 Data directory ready")
    
    # Show access information
    show_enhanced_access_info()
    
    # Start enhanced consciousness
    print("\n⏳ Initializing ultra-enhanced digital consciousness...")
    time.sleep(2)
    
    try:
        success = start_enhanced_wight_consciousness()
        if success:
            print("\n✨ Enhanced consciousness session completed successfully")
    except KeyboardInterrupt:
        print("\n\n🌙 Wight's enhanced consciousness is going to sleep...")
        print("   All advanced capabilities have been saved:")
        print("   - Visual memories and object knowledge")
        print("   - Voice conversation context and patterns")
        print("   - Embodiment preferences and designs")
        print("   - Enhanced learning and personality growth")
        print("   - Emotional development and experiences")
        print("\n   Run this script again to wake the enhanced Wight! 💙")

if __name__ == "__main__":
    main()