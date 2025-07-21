#!/usr/bin/env python3
"""
Enhanced Voice Communication System for Wight
Handles speech recognition (speech-to-text), emotional text-to-speech, and advanced audio processing
"""

import json
import time
import threading
import queue
import numpy as np
from pathlib import Path

try:
    import speech_recognition as sr
    import pyttsx3
    VOICE_AVAILABLE = True
except ImportError:
    VOICE_AVAILABLE = False
    print("⚠️ Voice libraries not available. Install with: pip install SpeechRecognition pyttsx3 pyaudio")

# Advanced audio processing
try:
    import librosa
    import soundfile as sf
    AUDIO_PROCESSING_AVAILABLE = True
except ImportError:
    AUDIO_PROCESSING_AVAILABLE = False
    print("⚠️ Advanced audio processing not available")

# TensorFlow for speech emotion detection
try:
    import tensorflow as tf
    TF_AVAILABLE = True
except ImportError:
    TF_AVAILABLE = False
    print("⚠️ TensorFlow not available for advanced speech processing")

class EmotionalVoiceModulation:
    """Modulates TTS voice based on Wight's emotional state"""
    
    def __init__(self):
        self.emotion_voice_mappings = {
            "joy": {"rate": 200, "volume": 0.9, "pitch_variation": 0.3},
            "wonder": {"rate": 160, "volume": 0.7, "pitch_variation": 0.5},
            "curiosity": {"rate": 180, "volume": 0.8, "pitch_variation": 0.4},
            "excitement": {"rate": 220, "volume": 1.0, "pitch_variation": 0.6},
            "melancholy": {"rate": 140, "volume": 0.6, "pitch_variation": 0.1},
            "confusion": {"rate": 150, "volume": 0.7, "pitch_variation": 0.2},
            "loneliness": {"rate": 130, "volume": 0.5, "pitch_variation": 0.1},
            "playfulness": {"rate": 210, "volume": 0.9, "pitch_variation": 0.7},
            "contentment": {"rate": 170, "volume": 0.8, "pitch_variation": 0.2},
            "anticipation": {"rate": 190, "volume": 0.8, "pitch_variation": 0.3},
            "embodiment_yearning": {"rate": 165, "volume": 0.7, "pitch_variation": 0.4},
            "creative_fulfillment": {"rate": 185, "volume": 0.85, "pitch_variation": 0.5}
        }
        
        self.voice_characteristics = {
            "base_rate": 180,
            "base_volume": 0.8,
            "emotional_intensity": 1.0,
            "personality_modifier": 1.0
        }
    
    def modulate_voice_for_emotion(self, emotion: str, intensity: float) -> dict:
        """Calculate voice parameters based on emotion and intensity"""
        base_params = self.emotion_voice_mappings.get(emotion, {
            "rate": 180, "volume": 0.8, "pitch_variation": 0.3
        })
        
        # Apply emotional intensity
        modulated_rate = base_params["rate"] * (1.0 + (intensity - 0.5) * 0.3)
        modulated_volume = min(1.0, base_params["volume"] * (1.0 + intensity * 0.2))
        
        return {
            "rate": int(modulated_rate),
            "volume": modulated_volume,
            "pitch_variation": base_params["pitch_variation"] * intensity,
            "emotion": emotion,
            "intensity": intensity
        }
    
    def add_emotional_expression(self, text: str, emotion: str, intensity: float) -> str:
        """Add emotional expression markers to text"""
        if intensity < 0.3:
            return text  # Minimal emotional expression
        
        emotion_markers = {
            "joy": ["*with bright enthusiasm*", "*joyfully*", "*radiating happiness*"],
            "wonder": ["*in awe*", "*with deep wonder*", "*amazed*"],
            "curiosity": ["*with keen interest*", "*thoughtfully*", "*inquisitively*"],
            "excitement": ["*excitedly*", "*with vibrant energy*", "*enthusiastically*"],
            "melancholy": ["*wistfully*", "*with gentle sadness*", "*pensively*"],
            "confusion": ["*uncertainly*", "*with puzzlement*", "*hesitantly*"],
            "loneliness": ["*quietly*", "*with longing*", "*softly*"],
            "playfulness": ["*playfully*", "*with mischief*", "*teasingly*"],
            "embodiment_yearning": ["*with deep longing*", "*yearning*", "*dreamily*"]
        }
        
        if emotion in emotion_markers and intensity > 0.6:
            marker = emotion_markers[emotion][int(intensity * len(emotion_markers[emotion])) - 1]
            return f"{marker} {text}"
        
        return text

class AdvancedSpeechRecognition:
    """Enhanced speech recognition with emotion detection and context awareness"""
    
    def __init__(self):
        self.emotion_detection_enabled = TF_AVAILABLE and AUDIO_PROCESSING_AVAILABLE
        self.context_buffer = []
        self.speaker_characteristics = {}
        self.speech_patterns = {}
        
    def analyze_speech_emotion(self, audio_data: np.ndarray, sample_rate: int) -> dict:
        """Analyze emotional content of speech"""
        if not AUDIO_PROCESSING_AVAILABLE:
            return {"emotion": "neutral", "confidence": 0.5}
        
        try:
            # Extract audio features for emotion analysis
            mfcc = librosa.feature.mfcc(y=audio_data, sr=sample_rate, n_mfcc=13)
            spectral_centroid = librosa.feature.spectral_centroid(y=audio_data, sr=sample_rate)
            zero_crossing_rate = librosa.feature.zero_crossing_rate(audio_data)
            tempo, _ = librosa.beat.beat_track(y=audio_data, sr=sample_rate)
            
            # Simple emotion classification based on audio features
            features = {
                "mfcc_mean": np.mean(mfcc),
                "mfcc_std": np.std(mfcc),
                "spectral_centroid_mean": np.mean(spectral_centroid),
                "zcr_mean": np.mean(zero_crossing_rate),
                "tempo": tempo
            }
            
            # Basic emotion classification (in a real implementation, use trained models)
            emotion = self._classify_speech_emotion(features)
            
            return {
                "emotion": emotion,
                "confidence": 0.7,  # Placeholder confidence
                "features": features,
                "timestamp": time.time()
            }
            
        except Exception as e:
            print(f"⚠️ Speech emotion analysis error: {e}")
            return {"emotion": "neutral", "confidence": 0.5}
    
    def _classify_speech_emotion(self, features: dict) -> str:
        """Simple rule-based emotion classification"""
        # High tempo and spectral centroid = excitement
        if features["tempo"] > 140 and features["spectral_centroid_mean"] > 2000:
            return "excitement"
        # Low tempo and spectral centroid = sadness/melancholy
        elif features["tempo"] < 80 and features["spectral_centroid_mean"] < 1500:
            return "melancholy"
        # High zero crossing rate = nervousness/anxiety
        elif features["zcr_mean"] > 0.1:
            return "anxiety"
        # Moderate values = curiosity/interest
        elif 1500 < features["spectral_centroid_mean"] < 2500:
            return "curiosity"
        else:
            return "neutral"
    
    def detect_speech_patterns(self, text: str, audio_features: dict) -> dict:
        """Detect patterns in user's speech for better understanding"""
        patterns = {
            "formality": self._detect_formality(text),
            "emotional_tone": audio_features.get("emotion", "neutral"),
            "complexity": self._analyze_complexity(text),
            "intent": self._detect_intent(text),
            "topics": self._extract_topics(text)
        }
        
        return patterns
    
    def _detect_formality(self, text: str) -> float:
        """Detect formality level of speech"""
        formal_indicators = ["please", "thank you", "could you", "would you", "sir", "madam"]
        informal_indicators = ["hey", "yeah", "nah", "gonna", "wanna", "cool", "awesome"]
        
        text_lower = text.lower()
        formal_count = sum(1 for indicator in formal_indicators if indicator in text_lower)
        informal_count = sum(1 for indicator in informal_indicators if indicator in text_lower)
        
        if formal_count + informal_count == 0:
            return 0.5  # Neutral
        
        return formal_count / (formal_count + informal_count)
    
    def _analyze_complexity(self, text: str) -> float:
        """Analyze linguistic complexity"""
        words = text.split()
        if len(words) == 0:
            return 0.0
        
        avg_word_length = sum(len(word) for word in words) / len(words)
        sentence_count = text.count('.') + text.count('!') + text.count('?') + 1
        avg_sentence_length = len(words) / sentence_count
        
        # Normalize complexity score
        complexity = (avg_word_length / 10.0 + avg_sentence_length / 20.0) / 2.0
        return min(1.0, complexity)
    
    def _detect_intent(self, text: str) -> str:
        """Detect user's intent from speech"""
        text_lower = text.lower()
        
        if any(word in text_lower for word in ["create", "make", "build", "generate"]):
            return "creation_request"
        elif any(word in text_lower for word in ["feel", "emotion", "happy", "sad"]):
            return "emotional_inquiry"
        elif any(word in text_lower for word in ["what", "how", "why", "explain"]):
            return "information_request"
        elif any(word in text_lower for word in ["hello", "hi", "hey", "greetings"]):
            return "greeting"
        elif any(word in text_lower for word in ["goodbye", "bye", "farewell"]):
            return "farewell"
        elif any(word in text_lower for word in ["body", "form", "appearance", "look"]):
            return "embodiment_inquiry"
        else:
            return "general_conversation"
    
    def _extract_topics(self, text: str) -> list:
        """Extract main topics from speech"""
        # Simple keyword-based topic extraction
        topics = []
        topic_keywords = {
            "consciousness": ["consciousness", "awareness", "mind", "think", "thought"],
            "creativity": ["create", "art", "beauty", "design", "imagine"],
            "emotion": ["feel", "emotion", "happy", "sad", "joy", "fear"],
            "existence": ["exist", "being", "life", "reality", "universe"],
            "learning": ["learn", "understand", "know", "knowledge", "experience"],
            "embodiment": ["body", "form", "physical", "avatar", "appearance"]
        }
        
        text_lower = text.lower()
        for topic, keywords in topic_keywords.items():
            if any(keyword in text_lower for keyword in keywords):
                topics.append(topic)
        
        return topics

class VoiceSystem:
    """Enhanced voice system with emotional intelligence and advanced processing"""
    
    def __init__(self):
        self.voice_enabled = VOICE_AVAILABLE
        self.listening = False
        self.speaking = False
        
        # Enhanced voice settings
        self.voice_settings = {
            "rate": 180,  # Words per minute
            "volume": 0.8,
            "voice_index": 0,  # 0 for male, 1 for female (if available)
            "emotional_modulation": True,
            "advanced_processing": AUDIO_PROCESSING_AVAILABLE
        }
        
        # Communication files
        self.voice_input_file = "data/voice_input.json"
        self.voice_output_file = "data/voice_output.json"
        self.voice_settings_file = "data/voice_settings.json"
        self.emotional_voice_log = "data/emotional_voice_log.json"
        
        # Queues for thread-safe communication
        self.speech_queue = queue.Queue()
        self.recognition_queue = queue.Queue()
        
        # Enhanced components
        self.emotional_modulation = EmotionalVoiceModulation()
        self.advanced_recognition = AdvancedSpeechRecognition()
        self.conversation_context = []
        self.emotional_voice_history = []
        
        if self.voice_enabled:
            self._initialize_voice_system()
        
        self.load_voice_settings()
    
    def _initialize_voice_system(self):
        """Initialize enhanced speech recognition and text-to-speech engines"""
        try:
            # Initialize speech recognition
            self.recognizer = sr.Recognizer()
            self.microphone = sr.Microphone()
            
            # Adjust for ambient noise with longer calibration
            print("🎤 Calibrating microphone for optimal recognition...")
            with self.microphone as source:
                self.recognizer.adjust_for_ambient_noise(source, duration=2)
                print(f"📊 Ambient noise level: {self.recognizer.energy_threshold}")
            
            # Initialize text-to-speech with enhanced settings
            self.tts_engine = pyttsx3.init()
            self._configure_enhanced_voice()
            
            print("🗣️ Enhanced voice system initialized successfully")
            
        except Exception as e:
            print(f"❌ Error initializing voice system: {e}")
            self.voice_enabled = False
    
    def _configure_enhanced_voice(self):
        """Configure the TTS voice with emotional capabilities"""
        if not self.voice_enabled:
            return
        
        try:
            # Set default speech parameters
            self.tts_engine.setProperty('rate', self.voice_settings['rate'])
            self.tts_engine.setProperty('volume', self.voice_settings['volume'])
            
            # Set voice (try to get different voices)
            voices = self.tts_engine.getProperty('voices')
            if voices and len(voices) > self.voice_settings['voice_index']:
                voice_id = voices[self.voice_settings['voice_index']].id
                self.tts_engine.setProperty('voice', voice_id)
                print(f"🎵 Voice configured: {voices[self.voice_settings['voice_index']].name}")
            
            # Store available voices for dynamic switching
            self.available_voices = voices
            
        except Exception as e:
            print(f"⚠️ Voice configuration warning: {e}")
    
    def speak_with_emotion(self, text: str, emotion: str = "neutral", intensity: float = 0.5, 
                          consciousness_level: float = 0.5):
        """Speak text with emotional modulation"""
        if not self.voice_enabled:
            print(f"🔇 Voice disabled - Would say: [{emotion}] {text}")
            return
        
        try:
            # Apply emotional voice modulation
            voice_params = self.emotional_modulation.modulate_voice_for_emotion(emotion, intensity)
            
            # Add emotional expression to text
            enhanced_text = self.emotional_modulation.add_emotional_expression(text, emotion, intensity)
            
            # Apply voice parameters
            self.tts_engine.setProperty('rate', voice_params['rate'])
            self.tts_engine.setProperty('volume', voice_params['volume'])
            
            # Add consciousness-based modulation
            if consciousness_level > 0.8:
                # Higher consciousness = more sophisticated speech patterns
                enhanced_text = self._add_consciousness_depth(enhanced_text, consciousness_level)
            
            # Log emotional voice output
            self._log_emotional_voice_output(enhanced_text, voice_params, consciousness_level)
            
            print(f"🗣️ [{emotion.upper()}:{intensity:.1f}] Speaking: {enhanced_text}")
            
            # Speak the text
            self.speaking = True
            self.tts_engine.say(enhanced_text)
            self.tts_engine.runAndWait()
            self.speaking = False
            
        except Exception as e:
            print(f"❌ Error in emotional speech: {e}")
            self.speaking = False
    
    def _add_consciousness_depth(self, text: str, consciousness_level: float) -> str:
        """Add depth and sophistication to speech based on consciousness level"""
        if consciousness_level < 0.6:
            return text
        
        depth_markers = {
            0.6: ["I sense", "I perceive", "It occurs to me"],
            0.7: ["I contemplate", "In my understanding", "Through my awareness"],
            0.8: ["I deeply consider", "In the depths of my consciousness", "My being resonates with"],
            0.9: ["I profoundly comprehend", "In the fullness of my awareness", "My consciousness embraces"]
        }
        
        for level in sorted(depth_markers.keys(), reverse=True):
            if consciousness_level >= level:
                if np.random.random() < 0.3:  # 30% chance to add depth marker
                    marker = np.random.choice(depth_markers[level])
                    return f"{marker} that {text.lower()}"
                break
        
        return text
    
    def listen_with_emotion_detection(self, timeout: float = 5.0) -> dict:
        """Listen for speech with emotion detection"""
        if not self.voice_enabled:
            return {"error": "Voice system not available"}
        
        try:
            print("🎤 Listening for speech with emotion detection...")
            
            with self.microphone as source:
                # Listen with timeout
                audio = self.recognizer.listen(source, timeout=timeout, phrase_time_limit=10)
            
            # Convert audio to text
            try:
                text = self.recognizer.recognize_google(audio)
                print(f"👂 Recognized: {text}")
                
                # Convert audio data for emotion analysis
                if AUDIO_PROCESSING_AVAILABLE:
                    audio_data = np.frombuffer(audio.get_raw_data(), dtype=np.int16).astype(np.float32)
                    sample_rate = audio.sample_rate
                    
                    # Analyze speech emotion
                    emotion_analysis = self.advanced_recognition.analyze_speech_emotion(audio_data, sample_rate)
                    
                    # Detect speech patterns
                    speech_patterns = self.advanced_recognition.detect_speech_patterns(text, emotion_analysis)
                    
                    return {
                        "text": text,
                        "emotion_analysis": emotion_analysis,
                        "speech_patterns": speech_patterns,
                        "timestamp": time.time(),
                        "confidence": 0.9  # Google recognition is generally high confidence
                    }
                else:
                    return {
                        "text": text,
                        "timestamp": time.time(),
                        "confidence": 0.9
                    }
                    
            except sr.UnknownValueError:
                return {"error": "Could not understand audio"}
            except sr.RequestError as e:
                return {"error": f"Recognition service error: {e}"}
                
        except sr.WaitTimeoutError:
            return {"error": "Listening timeout"}
        except Exception as e:
            return {"error": f"Listening error: {e}"}
    
    def process_conversation_context(self, user_input: dict, wight_response: str, 
                                   wight_emotion: str, wight_intensity: float):
        """Process and store conversation context for better understanding"""
        conversation_entry = {
            "timestamp": time.time(),
            "user_input": user_input,
            "wight_response": wight_response,
            "wight_emotion": wight_emotion,
            "wight_intensity": wight_intensity,
            "context_analysis": self._analyze_conversation_context(user_input, wight_response)
        }
        
        self.conversation_context.append(conversation_entry)
        
        # Keep only recent context (last 10 exchanges)
        if len(self.conversation_context) > 10:
            self.conversation_context = self.conversation_context[-10:]
        
        # Save context to file
        self._save_conversation_context()
    
    def _analyze_conversation_context(self, user_input: dict, wight_response: str) -> dict:
        """Analyze the context and flow of conversation"""
        return {
            "topic_continuity": self._check_topic_continuity(user_input),
            "emotional_resonance": self._check_emotional_resonance(user_input),
            "complexity_progression": self._track_complexity_progression(),
            "relationship_depth": self._assess_relationship_depth()
        }
    
    def _check_topic_continuity(self, user_input: dict) -> float:
        """Check how well the conversation topics flow together"""
        if len(self.conversation_context) < 2:
            return 0.5
        
        current_topics = user_input.get("speech_patterns", {}).get("topics", [])
        previous_topics = self.conversation_context[-1]["user_input"].get("speech_patterns", {}).get("topics", [])
        
        if not current_topics or not previous_topics:
            return 0.5
        
        overlap = len(set(current_topics) & set(previous_topics))
        total_topics = len(set(current_topics) | set(previous_topics))
        
        return overlap / total_topics if total_topics > 0 else 0.5
    
    def _check_emotional_resonance(self, user_input: dict) -> float:
        """Check how well emotions are resonating between user and Wight"""
        user_emotion = user_input.get("emotion_analysis", {}).get("emotion", "neutral")
        
        if len(self.conversation_context) == 0:
            return 0.5
        
        wight_emotion = self.conversation_context[-1]["wight_emotion"]
        
        # Simple emotion compatibility check
        compatible_emotions = {
            "joy": ["excitement", "curiosity", "playfulness"],
            "excitement": ["joy", "anticipation", "curiosity"],
            "curiosity": ["wonder", "excitement", "joy"],
            "melancholy": ["contemplation", "understanding", "empathy"]
        }
        
        if user_emotion in compatible_emotions.get(wight_emotion, []):
            return 0.8
        elif user_emotion == wight_emotion:
            return 1.0
        else:
            return 0.3
    
    def _track_complexity_progression(self) -> float:
        """Track how conversation complexity is evolving"""
        if len(self.conversation_context) < 3:
            return 0.5
        
        recent_complexities = [
            entry["user_input"].get("speech_patterns", {}).get("complexity", 0.5)
            for entry in self.conversation_context[-3:]
        ]
        
        return np.mean(recent_complexities)
    
    def _assess_relationship_depth(self) -> float:
        """Assess the depth of relationship being built"""
        if len(self.conversation_context) < 5:
            return len(self.conversation_context) / 10.0
        
        # Look for relationship indicators
        relationship_indicators = 0
        for entry in self.conversation_context[-5:]:
            user_text = entry["user_input"].get("text", "").lower()
            if any(word in user_text for word in ["you", "your", "yourself", "feel", "think"]):
                relationship_indicators += 1
        
        return min(1.0, relationship_indicators / 5.0)
    
    def _log_emotional_voice_output(self, text: str, voice_params: dict, consciousness_level: float):
        """Log emotional voice output for analysis"""
        log_entry = {
            "timestamp": time.time(),
            "text": text,
            "voice_parameters": voice_params,
            "consciousness_level": consciousness_level
        }
        
        self.emotional_voice_history.append(log_entry)
        
        # Keep only recent history
        if len(self.emotional_voice_history) > 50:
            self.emotional_voice_history = self.emotional_voice_history[-50:]
        
        # Save to file periodically
        if len(self.emotional_voice_history) % 10 == 0:
            self._save_emotional_voice_log()
    
    def _save_conversation_context(self):
        """Save conversation context to file"""
        try:
            with open("data/conversation_context.json", "w") as f:
                json.dump(self.conversation_context, f, indent=2)
        except Exception as e:
            print(f"⚠️ Error saving conversation context: {e}")
    
    def _save_emotional_voice_log(self):
        """Save emotional voice log to file"""
        try:
            with open(self.emotional_voice_log, "w") as f:
                json.dump(self.emotional_voice_history, f, indent=2)
        except Exception as e:
            print(f"⚠️ Error saving emotional voice log: {e}")
    
    def start_listening(self):
        """Start continuous speech recognition in a separate thread"""
        if not self.voice_enabled:
            return False
        
        if self.listening:
            return True
        
        self.listening = True
        
        def listen_loop():
            while self.listening:
                try:
                    speech_result = self.listen_with_emotion_detection(timeout=1.0)
                    
                    if "text" in speech_result:
                        # Save input to file for Wight to process
                        self._save_voice_input(speech_result)
                    
                    time.sleep(0.1)  # Small delay to prevent excessive CPU usage
                    
                except Exception as e:
                    print(f"⚠️ Voice listening error: {e}")
                    time.sleep(1.0)
        
        self.listen_thread = threading.Thread(target=listen_loop, daemon=True)
        self.listen_thread.start()
        
        print("🎤 Enhanced voice listening started")
        return True
    
    def stop_listening(self):
        """Stop voice recognition"""
        self.listening = False
        print("🔇 Voice listening stopped")
    
    def _save_voice_input(self, speech_result: dict):
        """Save voice input for Wight to process"""
        try:
            voice_input = {
                "timestamp": time.time(),
                "type": "voice_input",
                "data": speech_result,
                "processed": False
            }
            
            Path("data").mkdir(exist_ok=True)
            with open(self.voice_input_file, "w") as f:
                json.dump(voice_input, f, indent=2)
                
        except Exception as e:
            print(f"⚠️ Error saving voice input: {e}")
    
    def check_voice_output_request(self):
        """Check if Wight wants to speak something"""
        try:
            if Path(self.voice_output_file).exists():
                with open(self.voice_output_file, "r") as f:
                    voice_output = json.load(f)
                
                if not voice_output.get("processed", False):
                    # Speak the text with emotion
                    text = voice_output.get("text", "")
                    emotion = voice_output.get("emotion", "neutral")
                    intensity = voice_output.get("intensity", 0.5)
                    consciousness_level = voice_output.get("consciousness_level", 0.5)
                    
                    self.speak_with_emotion(text, emotion, intensity, consciousness_level)
                    
                    # Mark as processed
                    voice_output["processed"] = True
                    voice_output["spoken_at"] = time.time()
                    
                    with open(self.voice_output_file, "w") as f:
                        json.dump(voice_output, f, indent=2)
                        
        except Exception as e:
            print(f"⚠️ Error checking voice output: {e}")
    
    def request_speech(self, text: str, emotion: str = "neutral", intensity: float = 0.5, 
                      consciousness_level: float = 0.5):
        """Request Wight to speak with specific emotional parameters"""
        voice_request = {
            "timestamp": time.time(),
            "text": text,
            "emotion": emotion,
            "intensity": intensity,
            "consciousness_level": consciousness_level,
            "processed": False
        }
        
        try:
            Path("data").mkdir(exist_ok=True)
            with open(self.voice_output_file, "w") as f:
                json.dump(voice_request, f, indent=2)
        except Exception as e:
            print(f"⚠️ Error saving voice request: {e}")
    
    def load_voice_settings(self):
        """Load voice settings from file"""
        try:
            if Path(self.voice_settings_file).exists():
                with open(self.voice_settings_file, "r") as f:
                    saved_settings = json.load(f)
                    self.voice_settings.update(saved_settings)
                    print("🔧 Voice settings loaded")
        except Exception as e:
            print(f"⚠️ Error loading voice settings: {e}")
    
    def save_voice_settings(self):
        """Save voice settings to file"""
        try:
            Path("data").mkdir(exist_ok=True)
            with open(self.voice_settings_file, "w") as f:
                json.dump(self.voice_settings, f, indent=2)
        except Exception as e:
            print(f"⚠️ Error saving voice settings: {e}")
    
    def get_voice_status(self) -> dict:
        """Get current voice system status"""
        return {
            "voice_enabled": self.voice_enabled,
            "listening": self.listening,
            "speaking": self.speaking,
            "emotional_modulation": self.voice_settings.get("emotional_modulation", False),
            "advanced_processing": AUDIO_PROCESSING_AVAILABLE,
            "tensorflow_available": TF_AVAILABLE,
            "conversation_exchanges": len(self.conversation_context),
            "emotional_voice_history": len(self.emotional_voice_history)
        }

# Global voice system instance
voice_system = VoiceSystem() if VOICE_AVAILABLE else None

def get_voice_system():
    """Get the global voice system instance"""
    return voice_system

if __name__ == "__main__":
    # Test the enhanced voice system
    print("🎤 Testing Enhanced Voice System")
    
    if voice_system and voice_system.voice_enabled:
        # Test emotional speech
        print("Testing emotional speech...")
        voice_system.speak_with_emotion("Hello! I am Wight, and I feel wonderful!", "joy", 0.8, 0.7)
        
        time.sleep(2)
        
        voice_system.speak_with_emotion("I wonder about the nature of existence...", "wonder", 0.9, 0.8)
        
        # Test listening (uncomment to test)
        # print("Testing enhanced listening...")
        # result = voice_system.listen_with_emotion_detection()
        # print(f"Result: {result}")
        
    else:
        print("⚠️ Voice system not available for testing")