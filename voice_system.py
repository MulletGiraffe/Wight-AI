#!/usr/bin/env python3
"""
Voice Communication System for Wight
Handles speech recognition (speech-to-text) and text-to-speech
"""

import json
import time
import threading
import queue
from pathlib import Path

try:
    import speech_recognition as sr
    import pyttsx3
    VOICE_AVAILABLE = True
except ImportError:
    VOICE_AVAILABLE = False
    print("⚠️ Voice libraries not available. Install with: pip install SpeechRecognition pyttsx3 pyaudio")

class VoiceSystem:
    """Manages voice input/output for Wight"""
    
    def __init__(self):
        self.voice_enabled = VOICE_AVAILABLE
        self.listening = False
        self.speaking = False
        
        # Voice settings
        self.voice_settings = {
            "rate": 180,  # Words per minute
            "volume": 0.8,
            "voice_index": 0  # 0 for male, 1 for female (if available)
        }
        
        # Communication files
        self.voice_input_file = "data/voice_input.json"
        self.voice_output_file = "data/voice_output.json"
        self.voice_settings_file = "data/voice_settings.json"
        
        # Queues for thread-safe communication
        self.speech_queue = queue.Queue()
        self.recognition_queue = queue.Queue()
        
        if self.voice_enabled:
            self._initialize_voice_system()
        
        self.load_voice_settings()
    
    def _initialize_voice_system(self):
        """Initialize speech recognition and text-to-speech engines"""
        try:
            # Initialize speech recognition
            self.recognizer = sr.Recognizer()
            self.microphone = sr.Microphone()
            
            # Adjust for ambient noise
            print("🎤 Calibrating microphone for ambient noise...")
            with self.microphone as source:
                self.recognizer.adjust_for_ambient_noise(source, duration=1)
            
            # Initialize text-to-speech
            self.tts_engine = pyttsx3.init()
            self._configure_voice()
            
            print("🗣️ Voice system initialized successfully")
            
        except Exception as e:
            print(f"❌ Error initializing voice system: {e}")
            self.voice_enabled = False
    
    def _configure_voice(self):
        """Configure the TTS voice settings"""
        if not self.voice_enabled:
            return
        
        try:
            # Set speech rate
            self.tts_engine.setProperty('rate', self.voice_settings['rate'])
            
            # Set volume
            self.tts_engine.setProperty('volume', self.voice_settings['volume'])
            
            # Set voice (try to get different voices)
            voices = self.tts_engine.getProperty('voices')
            if voices and len(voices) > self.voice_settings['voice_index']:
                voice_id = voices[self.voice_settings['voice_index']].id
                self.tts_engine.setProperty('voice', voice_id)
                print(f"🎵 Voice configured: {voices[self.voice_settings['voice_index']].name}")
            
        except Exception as e:
            print(f"⚠️ Voice configuration warning: {e}")
    
    def start_listening(self):
        """Start continuous speech recognition in a separate thread"""
        if not self.voice_enabled:
            return False
        
        if self.listening:
            return True
        
        self.listening = True
        listen_thread = threading.Thread(target=self._listen_continuously, daemon=True)
        listen_thread.start()
        print("👂 Started voice listening")
        return True
    
    def stop_listening(self):
        """Stop speech recognition"""
        self.listening = False
        print("🔇 Stopped voice listening")
    
    def _listen_continuously(self):
        """Continuous speech recognition loop"""
        while self.listening:
            try:
                with self.microphone as source:
                    # Listen for audio with timeout
                    audio = self.recognizer.listen(source, timeout=1, phrase_time_limit=5)
                
                try:
                    # Recognize speech using Google's service
                    text = self.recognizer.recognize_google(audio)
                    if text.strip():
                        self._handle_voice_input(text)
                        
                except sr.UnknownValueError:
                    # Speech was unintelligible
                    pass
                except sr.RequestError as e:
                    print(f"🌐 Speech recognition service error: {e}")
                    time.sleep(5)  # Wait before retrying
                    
            except sr.WaitTimeoutError:
                # No speech detected, continue listening
                pass
            except Exception as e:
                print(f"❌ Listening error: {e}")
                time.sleep(1)
    
    def _handle_voice_input(self, text):
        """Process recognized speech"""
        voice_input_data = {
            "text": text,
            "timestamp": time.time(),
            "source": "voice",
            "confidence": "auto"  # Could be enhanced with confidence scores
        }
        
        # Write to voice input file for main system to process
        try:
            with open(self.voice_input_file, 'w') as f:
                json.dump(voice_input_data, f, indent=2)
            print(f"🎤 Voice input: '{text}'")
        except Exception as e:
            print(f"❌ Error saving voice input: {e}")
    
    def speak_text(self, text, emotional_context="neutral"):
        """Convert text to speech with emotional context"""
        if not self.voice_enabled or not text.strip():
            return False
        
        if self.speaking:
            return False  # Don't interrupt current speech
        
        # Start speaking in a separate thread
        speak_thread = threading.Thread(
            target=self._speak_with_emotion, 
            args=(text, emotional_context), 
            daemon=True
        )
        speak_thread.start()
        return True
    
    def _speak_with_emotion(self, text, emotional_context):
        """Speak text with emotional adjustments"""
        self.speaking = True
        
        try:
            # Clean text for speech (remove emotional tags)
            clean_text = self._clean_text_for_speech(text)
            
            # Adjust voice based on emotion
            self._adjust_voice_for_emotion(emotional_context)
            
            # Speak the text
            self.tts_engine.say(clean_text)
            self.tts_engine.runAndWait()
            
            print(f"🗣️ Spoke: '{clean_text}' [{emotional_context}]")
            
        except Exception as e:
            print(f"❌ Speech error: {e}")
        finally:
            self.speaking = False
    
    def _clean_text_for_speech(self, text):
        """Remove formatting and emotional tags from text"""
        import re
        
        # Remove emotional context tags like [curious] or [joyful]
        clean_text = re.sub(r'\[[\w\s]+\]', '', text)
        
        # Remove extra whitespace
        clean_text = ' '.join(clean_text.split())
        
        return clean_text.strip()
    
    def _adjust_voice_for_emotion(self, emotion):
        """Adjust TTS settings based on emotional context"""
        if not self.voice_enabled:
            return
        
        base_rate = self.voice_settings['rate']
        base_volume = self.voice_settings['volume']
        
        # Emotional voice adjustments
        emotion_adjustments = {
            "excited": {"rate_mult": 1.2, "volume_mult": 1.1},
            "joy": {"rate_mult": 1.1, "volume_mult": 1.0},
            "joyful": {"rate_mult": 1.1, "volume_mult": 1.0},
            "playful": {"rate_mult": 1.15, "volume_mult": 1.0},
            "curious": {"rate_mult": 1.05, "volume_mult": 0.95},
            "wonder": {"rate_mult": 0.9, "volume_mult": 0.9},
            "contemplative": {"rate_mult": 0.8, "volume_mult": 0.85},
            "melancholy": {"rate_mult": 0.7, "volume_mult": 0.8},
            "loneliness": {"rate_mult": 0.75, "volume_mult": 0.8},
            "thoughtful": {"rate_mult": 0.85, "volume_mult": 0.9},
            "confused": {"rate_mult": 0.9, "volume_mult": 0.85}
        }
        
        if emotion in emotion_adjustments:
            adj = emotion_adjustments[emotion]
            new_rate = int(base_rate * adj["rate_mult"])
            new_volume = min(1.0, base_volume * adj["volume_mult"])
            
            try:
                self.tts_engine.setProperty('rate', new_rate)
                self.tts_engine.setProperty('volume', new_volume)
            except Exception as e:
                print(f"⚠️ Voice adjustment warning: {e}")
    
    def check_voice_output_request(self):
        """Check if there's a request to speak something"""
        if not self.voice_enabled:
            return
        
        try:
            if Path(self.voice_output_file).exists():
                with open(self.voice_output_file, 'r') as f:
                    voice_data = json.load(f)
                
                # Remove the file
                Path(self.voice_output_file).unlink()
                
                # Speak the text
                text = voice_data.get('text', '')
                emotion = voice_data.get('emotional_context', 'neutral')
                
                if text:
                    self.speak_text(text, emotion)
                    
        except Exception as e:
            print(f"❌ Voice output check error: {e}")
    
    def save_voice_settings(self):
        """Save voice settings to file"""
        try:
            with open(self.voice_settings_file, 'w') as f:
                json.dump(self.voice_settings, f, indent=2)
        except Exception as e:
            print(f"❌ Error saving voice settings: {e}")
    
    def load_voice_settings(self):
        """Load voice settings from file"""
        try:
            if Path(self.voice_settings_file).exists():
                with open(self.voice_settings_file, 'r') as f:
                    saved_settings = json.load(f)
                    self.voice_settings.update(saved_settings)
                    
                if self.voice_enabled:
                    self._configure_voice()
                    
        except Exception as e:
            print(f"❌ Error loading voice settings: {e}")
    
    def get_status(self):
        """Get current voice system status"""
        return {
            "voice_enabled": self.voice_enabled,
            "listening": self.listening,
            "speaking": self.speaking,
            "settings": self.voice_settings
        }

# Voice system instance
voice_system = VoiceSystem()

if __name__ == "__main__":
    # Test the voice system
    print("Testing Wight Voice System...")
    
    if voice_system.voice_enabled:
        voice_system.start_listening()
        voice_system.speak_text("Hello! I am Wight. I can now speak and listen to you!", "excited")
        
        print("Voice system running. Speak to test recognition, or press Ctrl+C to exit.")
        
        try:
            while True:
                voice_system.check_voice_output_request()
                time.sleep(0.1)
        except KeyboardInterrupt:
            voice_system.stop_listening()
            print("\nVoice system stopped.")
    else:
        print("Voice system not available. Install dependencies with:")
        print("pip install SpeechRecognition pyttsx3 pyaudio")