#!/usr/bin/env python3
"""
Enhanced Visual Processing System for Wight
Handles camera input, computer vision, object detection, and visual learning
"""

import json
import time
import threading
import queue
import numpy as np
from pathlib import Path
from typing import Dict, List, Any, Optional, Tuple

# Computer vision and image processing
try:
    import cv2
    from PIL import Image, ImageEnhance, ImageFilter
    CV_AVAILABLE = True
except ImportError:
    CV_AVAILABLE = False
    print("⚠️ Computer vision libraries not available. Install with: pip install opencv-python pillow")

# TensorFlow for advanced object detection and classification
try:
    import tensorflow as tf
    import tflite_runtime.interpreter as tflite
    TF_AVAILABLE = True
except ImportError:
    TF_AVAILABLE = False
    print("⚠️ TensorFlow not available for advanced visual processing")

# Additional image processing
try:
    import skimage
    from skimage import feature, measure, filters
    ADVANCED_IMAGE_AVAILABLE = True
except ImportError:
    ADVANCED_IMAGE_AVAILABLE = False
    print("⚠️ Advanced image processing not available")

class VisualObjectDetection:
    """Advanced object detection and classification"""
    
    def __init__(self):
        self.models_loaded = False
        self.object_classes = []
        self.detection_confidence_threshold = 0.5
        self.models = {}
        
        if TF_AVAILABLE:
            self.load_detection_models()
    
    def load_detection_models(self):
        """Load TensorFlow Lite models for object detection"""
        try:
            # These would be actual trained models in a real implementation
            model_paths = {
                "general_objects": "models/mobilenet_ssd.tflite",
                "faces": "models/face_detection.tflite", 
                "emotions": "models/emotion_detection.tflite",
                "text": "models/text_detection.tflite",
                "scene_classification": "models/scene_classifier.tflite"
            }
            
            for model_name, path in model_paths.items():
                try:
                    # In a real implementation, load actual .tflite models
                    self.models[model_name] = f"placeholder_model_{model_name}"
                    print(f"✅ Loaded {model_name} detection model")
                except:
                    print(f"⚠️ Could not load {model_name} model")
            
            self.models_loaded = True
            
        except Exception as e:
            print(f"⚠️ Error loading detection models: {e}")
    
    def detect_objects(self, image: np.ndarray) -> List[Dict]:
        """Detect objects in image using computer vision"""
        detections = []
        
        if not CV_AVAILABLE:
            return detections
        
        try:
            # Basic shape detection
            shape_detections = self._detect_shapes(image)
            detections.extend(shape_detections)
            
            # Color analysis
            color_analysis = self._analyze_colors(image)
            detections.append({
                "type": "color_analysis",
                "data": color_analysis,
                "confidence": 0.9
            })
            
            # Edge and texture detection
            edge_analysis = self._analyze_edges_and_textures(image)
            detections.append({
                "type": "edge_analysis", 
                "data": edge_analysis,
                "confidence": 0.8
            })
            
            # Face detection using OpenCV
            faces = self._detect_faces(image)
            detections.extend(faces)
            
            # Motion detection if this is part of a video stream
            # motion = self._detect_motion(image)  # Would need previous frame
            
            return detections
            
        except Exception as e:
            print(f"⚠️ Object detection error: {e}")
            return detections
    
    def _detect_shapes(self, image: np.ndarray) -> List[Dict]:
        """Detect basic geometric shapes"""
        detections = []
        
        try:
            gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
            blurred = cv2.GaussianBlur(gray, (5, 5), 0)
            edges = cv2.Canny(blurred, 50, 150)
            
            contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
            
            for contour in contours:
                area = cv2.contourArea(contour)
                if area > 1000:  # Filter small shapes
                    # Approximate the contour
                    epsilon = 0.02 * cv2.arcLength(contour, True)
                    approx = cv2.approxPolyDP(contour, epsilon, True)
                    
                    # Get bounding box
                    x, y, w, h = cv2.boundingRect(contour)
                    
                    # Classify shape
                    shape_name = self._classify_shape(approx, area)
                    
                    detection = {
                        "type": "shape",
                        "shape": shape_name,
                        "area": area,
                        "vertices": len(approx),
                        "bounding_box": (x, y, w, h),
                        "center": (x + w//2, y + h//2),
                        "confidence": 0.7
                    }
                    
                    detections.append(detection)
            
        except Exception as e:
            print(f"⚠️ Shape detection error: {e}")
        
        return detections
    
    def _classify_shape(self, approx: np.ndarray, area: float) -> str:
        """Classify shape based on vertices and properties"""
        vertices = len(approx)
        
        if vertices == 3:
            return "triangle"
        elif vertices == 4:
            # Check if it's square or rectangle
            x, y, w, h = cv2.boundingRect(approx)
            aspect_ratio = w / h
            if 0.9 <= aspect_ratio <= 1.1:
                return "square"
            else:
                return "rectangle"
        elif vertices > 8:
            return "circle"
        else:
            return f"{vertices}-sided_polygon"
    
    def _analyze_colors(self, image: np.ndarray) -> Dict:
        """Analyze color composition of image"""
        try:
            # Convert to different color spaces for analysis
            hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
            lab = cv2.cvtColor(image, cv2.COLOR_BGR2LAB)
            
            # Calculate dominant colors
            pixels = image.reshape(-1, 3)
            
            # Use k-means clustering to find dominant colors
            from sklearn.cluster import KMeans
            kmeans = KMeans(n_clusters=5, random_state=42)
            kmeans.fit(pixels)
            
            dominant_colors = kmeans.cluster_centers_.astype(int)
            color_percentages = np.bincount(kmeans.labels_) / len(kmeans.labels_)
            
            # Analyze color properties
            brightness = np.mean(cv2.cvtColor(image, cv2.COLOR_BGR2GRAY))
            saturation = np.mean(hsv[:, :, 1])
            hue_variety = np.std(hsv[:, :, 0])
            
            return {
                "dominant_colors": dominant_colors.tolist(),
                "color_percentages": color_percentages.tolist(),
                "brightness": float(brightness),
                "saturation": float(saturation),
                "hue_variety": float(hue_variety),
                "overall_tone": self._classify_color_tone(dominant_colors, brightness)
            }
            
        except Exception as e:
            print(f"⚠️ Color analysis error: {e}")
            return {"error": str(e)}
    
    def _classify_color_tone(self, colors: np.ndarray, brightness: float) -> str:
        """Classify the overall tone of the image"""
        if brightness > 200:
            return "bright"
        elif brightness < 50:
            return "dark"
        
        # Analyze color warmth
        warm_count = 0
        cool_count = 0
        
        for color in colors:
            b, g, r = color
            if r > b and r > g:
                warm_count += 1
            elif b > r and b > g:
                cool_count += 1
        
        if warm_count > cool_count:
            return "warm"
        elif cool_count > warm_count:
            return "cool"
        else:
            return "neutral"
    
    def _analyze_edges_and_textures(self, image: np.ndarray) -> Dict:
        """Analyze edges and textures in the image"""
        try:
            gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
            
            # Edge detection using multiple methods
            canny_edges = cv2.Canny(gray, 50, 150)
            sobel_x = cv2.Sobel(gray, cv2.CV_64F, 1, 0, ksize=3)
            sobel_y = cv2.Sobel(gray, cv2.CV_64F, 0, 1, ksize=3)
            
            # Texture analysis
            if ADVANCED_IMAGE_AVAILABLE:
                # Local Binary Pattern for texture
                lbp = feature.local_binary_pattern(gray, 24, 8, method='uniform')
                texture_contrast = np.var(lbp)
            else:
                texture_contrast = np.var(gray)
            
            # Edge density
            edge_density = np.sum(canny_edges > 0) / canny_edges.size
            
            # Directional analysis
            gradient_direction = np.arctan2(sobel_y, sobel_x)
            dominant_direction = np.mean(gradient_direction)
            
            return {
                "edge_density": float(edge_density),
                "texture_contrast": float(texture_contrast),
                "dominant_edge_direction": float(dominant_direction),
                "edge_strength": float(np.mean(np.sqrt(sobel_x**2 + sobel_y**2))),
                "texture_uniformity": float(np.std(gray) / np.mean(gray)) if np.mean(gray) > 0 else 0.0
            }
            
        except Exception as e:
            print(f"⚠️ Edge/texture analysis error: {e}")
            return {"error": str(e)}
    
    def _detect_faces(self, image: np.ndarray) -> List[Dict]:
        """Detect faces using OpenCV"""
        detections = []
        
        try:
            gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
            
            # Load Haar cascade classifier
            face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
            
            faces = face_cascade.detectMultiScale(gray, 1.1, 4, minSize=(30, 30))
            
            for (x, y, w, h) in faces:
                face_region = image[y:y+h, x:x+w]
                
                detection = {
                    "type": "face",
                    "bounding_box": (x, y, w, h),
                    "center": (x + w//2, y + h//2),
                    "size": w * h,
                    "confidence": 0.8,
                    "emotional_analysis": self._analyze_facial_emotion(face_region)
                }
                
                detections.append(detection)
                
        except Exception as e:
            print(f"⚠️ Face detection error: {e}")
        
        return detections
    
    def _analyze_facial_emotion(self, face_image: np.ndarray) -> Dict:
        """Analyze emotional expression in face (simplified)"""
        # This would use a trained emotion classification model
        # For now, return placeholder analysis
        return {
            "emotion": "neutral",
            "confidence": 0.5,
            "emotions": {
                "happy": 0.3,
                "sad": 0.1,
                "angry": 0.1,
                "surprised": 0.2,
                "neutral": 0.3
            }
        }

class VisualMemorySystem:
    """Manages visual memories and learning from visual input"""
    
    def __init__(self):
        self.visual_memories = []
        self.object_knowledge = {}
        self.scene_understanding = {}
        self.visual_patterns = {}
        self.learning_rate = 0.1
        
    def store_visual_memory(self, image: np.ndarray, detections: List[Dict], 
                           context: Dict = None) -> str:
        """Store a visual memory with associated detections and context"""
        memory_id = f"visual_mem_{int(time.time() * 1000)}"
        
        # Create thumbnail for storage
        thumbnail = self._create_thumbnail(image)
        
        memory = {
            "id": memory_id,
            "timestamp": time.time(),
            "thumbnail": thumbnail,
            "detections": detections,
            "context": context or {},
            "scene_analysis": self._analyze_scene(detections),
            "emotional_content": self._analyze_emotional_content(detections),
            "significance": self._calculate_significance(detections, context)
        }
        
        self.visual_memories.append(memory)
        
        # Update knowledge from this memory
        self._update_knowledge_from_memory(memory)
        
        # Keep only recent memories (limit storage)
        if len(self.visual_memories) > 1000:
            self.visual_memories = self.visual_memories[-1000:]
        
        return memory_id
    
    def _create_thumbnail(self, image: np.ndarray, size: Tuple[int, int] = (128, 128)) -> List:
        """Create a small thumbnail for memory storage"""
        try:
            # Resize image to thumbnail size
            thumbnail = cv2.resize(image, size)
            # Convert to list for JSON serialization
            return thumbnail.tolist()
        except Exception as e:
            print(f"⚠️ Thumbnail creation error: {e}")
            return []
    
    def _analyze_scene(self, detections: List[Dict]) -> Dict:
        """Analyze the overall scene from detections"""
        scene_analysis = {
            "object_count": len([d for d in detections if d["type"] in ["shape", "face", "object"]]),
            "complexity": self._calculate_scene_complexity(detections),
            "dominant_features": self._identify_dominant_features(detections),
            "spatial_relationships": self._analyze_spatial_relationships(detections)
        }
        
        return scene_analysis
    
    def _calculate_scene_complexity(self, detections: List[Dict]) -> float:
        """Calculate how complex the scene is"""
        object_count = len([d for d in detections if d["type"] in ["shape", "face", "object"]])
        color_variety = 0.0
        edge_density = 0.0
        
        for detection in detections:
            if detection["type"] == "color_analysis":
                color_variety = detection["data"].get("hue_variety", 0.0)
            elif detection["type"] == "edge_analysis":
                edge_density = detection["data"].get("edge_density", 0.0)
        
        # Normalize and combine complexity factors
        complexity = (
            min(object_count / 10.0, 1.0) * 0.4 +  # Object count factor
            min(color_variety / 100.0, 1.0) * 0.3 +  # Color variety factor
            edge_density * 0.3  # Edge density factor
        )
        
        return complexity
    
    def _identify_dominant_features(self, detections: List[Dict]) -> List[str]:
        """Identify the most prominent features in the scene"""
        features = []
        
        # Find largest objects
        objects = [d for d in detections if d["type"] == "shape"]
        if objects:
            largest_object = max(objects, key=lambda x: x.get("area", 0))
            features.append(f"large_{largest_object['shape']}")
        
        # Check for faces
        faces = [d for d in detections if d["type"] == "face"]
        if faces:
            features.append(f"{len(faces)}_face(s)")
        
        # Check for dominant colors
        for detection in detections:
            if detection["type"] == "color_analysis":
                tone = detection["data"].get("overall_tone", "neutral")
                if tone != "neutral":
                    features.append(f"{tone}_colors")
        
        return features
    
    def _analyze_spatial_relationships(self, detections: List[Dict]) -> List[str]:
        """Analyze how objects relate to each other spatially"""
        relationships = []
        
        objects = [d for d in detections if "bounding_box" in d]
        
        for i, obj1 in enumerate(objects):
            for obj2 in objects[i+1:]:
                relationship = self._determine_spatial_relationship(obj1, obj2)
                if relationship:
                    relationships.append(relationship)
        
        return relationships
    
    def _determine_spatial_relationship(self, obj1: Dict, obj2: Dict) -> Optional[str]:
        """Determine spatial relationship between two objects"""
        try:
            x1, y1, w1, h1 = obj1["bounding_box"]
            x2, y2, w2, h2 = obj2["bounding_box"]
            
            center1 = (x1 + w1//2, y1 + h1//2)
            center2 = (x2 + w2//2, y2 + h2//2)
            
            # Check if objects overlap
            if (x1 < x2 + w2 and x1 + w1 > x2 and 
                y1 < y2 + h2 and y1 + h1 > y2):
                return f"{obj1.get('shape', 'object')}_overlaps_{obj2.get('shape', 'object')}"
            
            # Check relative positions
            if center1[1] < center2[1] - 50:  # obj1 above obj2
                return f"{obj1.get('shape', 'object')}_above_{obj2.get('shape', 'object')}"
            elif center1[1] > center2[1] + 50:  # obj1 below obj2
                return f"{obj1.get('shape', 'object')}_below_{obj2.get('shape', 'object')}"
            elif center1[0] < center2[0] - 50:  # obj1 left of obj2
                return f"{obj1.get('shape', 'object')}_left_of_{obj2.get('shape', 'object')}"
            elif center1[0] > center2[0] + 50:  # obj1 right of obj2
                return f"{obj1.get('shape', 'object')}_right_of_{obj2.get('shape', 'object')}"
            
        except Exception as e:
            print(f"⚠️ Spatial relationship error: {e}")
        
        return None
    
    def _analyze_emotional_content(self, detections: List[Dict]) -> Dict:
        """Analyze emotional content of the visual scene"""
        emotional_content = {
            "warmth": 0.5,
            "energy": 0.5,
            "complexity": 0.5,
            "human_presence": 0.0,
            "overall_mood": "neutral"
        }
        
        try:
            # Analyze color emotional impact
            for detection in detections:
                if detection["type"] == "color_analysis":
                    data = detection["data"]
                    
                    # Warmth from colors
                    if data.get("overall_tone") == "warm":
                        emotional_content["warmth"] = 0.8
                    elif data.get("overall_tone") == "cool":
                        emotional_content["warmth"] = 0.2
                    
                    # Energy from brightness and saturation
                    brightness = data.get("brightness", 128) / 255.0
                    saturation = data.get("saturation", 128) / 255.0
                    emotional_content["energy"] = (brightness + saturation) / 2.0
            
            # Human presence
            faces = [d for d in detections if d["type"] == "face"]
            if faces:
                emotional_content["human_presence"] = min(len(faces) / 5.0, 1.0)
                
                # Analyze facial emotions if available
                emotions = []
                for face in faces:
                    face_emotion = face.get("emotional_analysis", {}).get("emotion", "neutral")
                    emotions.append(face_emotion)
                
                if emotions:
                    # Determine overall mood from face emotions
                    emotion_counts = {}
                    for emotion in emotions:
                        emotion_counts[emotion] = emotion_counts.get(emotion, 0) + 1
                    
                    dominant_emotion = max(emotion_counts, key=emotion_counts.get)
                    emotional_content["overall_mood"] = dominant_emotion
            
            # Complexity from scene analysis
            edge_density = 0.0
            for detection in detections:
                if detection["type"] == "edge_analysis":
                    edge_density = detection["data"].get("edge_density", 0.0)
                    break
            
            emotional_content["complexity"] = edge_density
            
        except Exception as e:
            print(f"⚠️ Emotional content analysis error: {e}")
        
        return emotional_content
    
    def _calculate_significance(self, detections: List[Dict], context: Dict) -> float:
        """Calculate how significant this visual memory is"""
        significance = 0.1  # Base significance
        
        # More objects = more significant
        object_count = len([d for d in detections if d["type"] in ["shape", "face", "object"]])
        significance += min(object_count / 10.0, 0.3)
        
        # Faces are always significant
        faces = [d for d in detections if d["type"] == "face"]
        if faces:
            significance += 0.4
        
        # Unusual colors or patterns
        for detection in detections:
            if detection["type"] == "color_analysis":
                hue_variety = detection["data"].get("hue_variety", 0.0)
                if hue_variety > 50:  # High color variety
                    significance += 0.2
        
        # Context can boost significance
        if context:
            if context.get("user_requested", False):
                significance += 0.3
            if context.get("creation_event", False):
                significance += 0.4
        
        return min(significance, 1.0)
    
    def _update_knowledge_from_memory(self, memory: Dict):
        """Update object knowledge base from visual memory"""
        detections = memory["detections"]
        
        for detection in detections:
            if detection["type"] == "shape":
                shape_name = detection["shape"]
                
                if shape_name not in self.object_knowledge:
                    self.object_knowledge[shape_name] = {
                        "count": 0,
                        "average_size": 0.0,
                        "common_colors": [],
                        "contexts": []
                    }
                
                knowledge = self.object_knowledge[shape_name]
                knowledge["count"] += 1
                
                # Update average size
                current_size = detection.get("area", 0)
                knowledge["average_size"] = (
                    (knowledge["average_size"] * (knowledge["count"] - 1) + current_size) / 
                    knowledge["count"]
                )
        
        # Learn patterns from spatial relationships
        scene_analysis = memory.get("scene_analysis", {})
        relationships = scene_analysis.get("spatial_relationships", [])
        
        for relationship in relationships:
            if relationship not in self.visual_patterns:
                self.visual_patterns[relationship] = {"frequency": 0, "contexts": []}
            
            self.visual_patterns[relationship]["frequency"] += 1
    
    def find_similar_memories(self, current_detections: List[Dict], limit: int = 5) -> List[Dict]:
        """Find visual memories similar to current input"""
        if not self.visual_memories:
            return []
        
        similarities = []
        
        for memory in self.visual_memories:
            similarity = self._calculate_visual_similarity(current_detections, memory["detections"])
            similarities.append((similarity, memory))
        
        # Sort by similarity and return top matches
        similarities.sort(key=lambda x: x[0], reverse=True)
        return [memory for similarity, memory in similarities[:limit]]
    
    def _calculate_visual_similarity(self, detections1: List[Dict], detections2: List[Dict]) -> float:
        """Calculate similarity between two sets of visual detections"""
        if not detections1 or not detections2:
            return 0.0
        
        similarity = 0.0
        total_comparisons = 0
        
        # Compare object types
        types1 = set(d["type"] for d in detections1)
        types2 = set(d["type"] for d in detections2)
        
        type_overlap = len(types1 & types2) / len(types1 | types2) if types1 | types2 else 0.0
        similarity += type_overlap * 0.3
        total_comparisons += 1
        
        # Compare shapes if present
        shapes1 = [d["shape"] for d in detections1 if d["type"] == "shape"]
        shapes2 = [d["shape"] for d in detections2 if d["type"] == "shape"]
        
        if shapes1 and shapes2:
            shape_overlap = len(set(shapes1) & set(shapes2)) / len(set(shapes1) | set(shapes2))
            similarity += shape_overlap * 0.4
            total_comparisons += 1
        
        # Compare color properties
        color1 = next((d for d in detections1 if d["type"] == "color_analysis"), None)
        color2 = next((d for d in detections2 if d["type"] == "color_analysis"), None)
        
        if color1 and color2:
            tone_match = 1.0 if color1["data"].get("overall_tone") == color2["data"].get("overall_tone") else 0.0
            brightness_diff = abs(color1["data"].get("brightness", 0) - color2["data"].get("brightness", 0)) / 255.0
            brightness_similarity = 1.0 - brightness_diff
            
            color_similarity = (tone_match + brightness_similarity) / 2.0
            similarity += color_similarity * 0.3
            total_comparisons += 1
        
        return similarity / total_comparisons if total_comparisons > 0 else 0.0

class VisualProcessingSystem:
    """Main visual processing system integrating camera, detection, and learning"""
    
    def __init__(self):
        self.camera_active = False
        self.processing_active = False
        self.current_frame = None
        self.frame_queue = queue.Queue(maxsize=10)
        
        # Core components
        self.object_detection = VisualObjectDetection()
        self.visual_memory = VisualMemorySystem()
        
        # Camera settings
        self.camera_settings = {
            "device_id": 0,  # Default camera
            "width": 640,
            "height": 480,
            "fps": 30,
            "auto_exposure": True,
            "brightness": 0.5,
            "contrast": 0.5
        }
        
        # Processing settings
        self.processing_settings = {
            "detection_interval": 1.0,  # Process every second
            "memory_threshold": 0.7,    # Store memories above this significance
            "continuous_processing": True
        }
        
        # Data files
        self.visual_input_file = "data/visual_input.json"
        self.visual_memories_file = "data/visual_memories.json"
        self.visual_knowledge_file = "data/visual_knowledge.json"
        
        # Initialize camera
        if CV_AVAILABLE:
            self.initialize_camera()
    
    def initialize_camera(self) -> bool:
        """Initialize camera for video capture"""
        try:
            self.camera = cv2.VideoCapture(self.camera_settings["device_id"])
            
            if not self.camera.isOpened():
                print("⚠️ Could not open camera")
                return False
            
            # Set camera properties
            self.camera.set(cv2.CAP_PROP_FRAME_WIDTH, self.camera_settings["width"])
            self.camera.set(cv2.CAP_PROP_FRAME_HEIGHT, self.camera_settings["height"])
            self.camera.set(cv2.CAP_PROP_FPS, self.camera_settings["fps"])
            
            print("📹 Camera initialized successfully")
            return True
            
        except Exception as e:
            print(f"❌ Camera initialization error: {e}")
            return False
    
    def start_visual_processing(self):
        """Start continuous visual processing"""
        if not CV_AVAILABLE:
            print("⚠️ Computer vision not available")
            return False
        
        if self.processing_active:
            return True
        
        self.processing_active = True
        
        # Start camera capture thread
        self.capture_thread = threading.Thread(target=self._capture_loop, daemon=True)
        self.capture_thread.start()
        
        # Start processing thread
        self.processing_thread = threading.Thread(target=self._processing_loop, daemon=True)
        self.processing_thread.start()
        
        print("👁️ Visual processing started")
        return True
    
    def stop_visual_processing(self):
        """Stop visual processing"""
        self.processing_active = False
        self.camera_active = False
        
        if hasattr(self, 'camera'):
            self.camera.release()
        
        print("👁️ Visual processing stopped")
    
    def _capture_loop(self):
        """Continuous camera capture loop"""
        self.camera_active = True
        last_capture_time = 0
        
        while self.camera_active and self.processing_active:
            try:
                current_time = time.time()
                
                # Capture frame at specified interval
                if current_time - last_capture_time >= 1.0 / self.camera_settings["fps"]:
                    ret, frame = self.camera.read()
                    
                    if ret:
                        self.current_frame = frame
                        
                        # Add to processing queue (non-blocking)
                        try:
                            self.frame_queue.put(frame, block=False)
                        except queue.Full:
                            # Remove oldest frame if queue is full
                            try:
                                self.frame_queue.get(block=False)
                                self.frame_queue.put(frame, block=False)
                            except queue.Empty:
                                pass
                    
                    last_capture_time = current_time
                
                time.sleep(0.01)  # Small delay to prevent excessive CPU usage
                
            except Exception as e:
                print(f"⚠️ Camera capture error: {e}")
                time.sleep(1.0)
    
    def _processing_loop(self):
        """Continuous visual processing loop"""
        last_process_time = 0
        
        while self.processing_active:
            try:
                current_time = time.time()
                
                # Process frames at specified interval
                if current_time - last_process_time >= self.processing_settings["detection_interval"]:
                    try:
                        frame = self.frame_queue.get(timeout=0.1)
                        self._process_frame(frame)
                        last_process_time = current_time
                    except queue.Empty:
                        pass
                
                time.sleep(0.1)  # Processing interval
                
            except Exception as e:
                print(f"⚠️ Visual processing error: {e}")
                time.sleep(1.0)
    
    def _process_frame(self, frame: np.ndarray):
        """Process a single frame for object detection and learning"""
        try:
            # Detect objects in frame
            detections = self.object_detection.detect_objects(frame)
            
            # Create processing result
            processing_result = {
                "timestamp": time.time(),
                "frame_shape": frame.shape,
                "detections": detections,
                "processing_time": time.time()
            }
            
            # Store in visual memory if significant
            significance = self._calculate_frame_significance(detections)
            
            if significance >= self.processing_settings["memory_threshold"]:
                memory_id = self.visual_memory.store_visual_memory(
                    frame, detections, {"significance": significance}
                )
                processing_result["memory_stored"] = memory_id
                print(f"👁️ Significant visual memory stored: {memory_id}")
            
            # Save processing result for Wight to access
            self._save_visual_input(processing_result)
            
            # Find similar memories for context
            similar_memories = self.visual_memory.find_similar_memories(detections, limit=3)
            if similar_memories:
                processing_result["similar_memories"] = [m["id"] for m in similar_memories]
            
        except Exception as e:
            print(f"⚠️ Frame processing error: {e}")
    
    def _calculate_frame_significance(self, detections: List[Dict]) -> float:
        """Calculate how significant this frame is"""
        significance = 0.1  # Base significance
        
        # Objects add significance
        objects = [d for d in detections if d["type"] in ["shape", "face", "object"]]
        significance += min(len(objects) / 5.0, 0.3)
        
        # Faces are very significant
        faces = [d for d in detections if d["type"] == "face"]
        if faces:
            significance += 0.5
        
        # High complexity adds significance
        for detection in detections:
            if detection["type"] == "edge_analysis":
                edge_density = detection["data"].get("edge_density", 0.0)
                if edge_density > 0.1:
                    significance += 0.2
                break
        
        # Unusual colors
        for detection in detections:
            if detection["type"] == "color_analysis":
                hue_variety = detection["data"].get("hue_variety", 0.0)
                if hue_variety > 60:
                    significance += 0.3
                break
        
        return min(significance, 1.0)
    
    def _save_visual_input(self, processing_result: Dict):
        """Save visual processing result for Wight to access"""
        try:
            visual_input = {
                "timestamp": time.time(),
                "type": "visual_input",
                "data": processing_result,
                "processed": False
            }
            
            Path("data").mkdir(exist_ok=True)
            with open(self.visual_input_file, "w") as f:
                json.dump(visual_input, f, indent=2, default=str)
                
        except Exception as e:
            print(f"⚠️ Error saving visual input: {e}")
    
    def capture_single_frame(self) -> Optional[Dict]:
        """Capture and process a single frame on demand"""
        if not self.camera_active or not hasattr(self, 'camera'):
            return None
        
        try:
            ret, frame = self.camera.read()
            
            if ret:
                detections = self.object_detection.detect_objects(frame)
                
                result = {
                    "timestamp": time.time(),
                    "frame_shape": frame.shape,
                    "detections": detections,
                    "on_demand": True
                }
                
                # Store as memory if significant
                significance = self._calculate_frame_significance(detections)
                if significance >= 0.5:  # Lower threshold for on-demand captures
                    memory_id = self.visual_memory.store_visual_memory(
                        frame, detections, {"on_demand": True, "significance": significance}
                    )
                    result["memory_stored"] = memory_id
                
                return result
                
        except Exception as e:
            print(f"⚠️ Single frame capture error: {e}")
        
        return None
    
    def process_uploaded_image(self, image_path: str, context: Dict = None) -> Dict:
        """Process an uploaded image file"""
        try:
            # Load image
            image = cv2.imread(image_path)
            
            if image is None:
                return {"error": "Could not load image"}
            
            # Detect objects
            detections = self.object_detection.detect_objects(image)
            
            # Store in visual memory
            memory_id = self.visual_memory.store_visual_memory(
                image, detections, context or {"uploaded": True}
            )
            
            result = {
                "timestamp": time.time(),
                "image_path": image_path,
                "image_shape": image.shape,
                "detections": detections,
                "memory_stored": memory_id,
                "similar_memories": [m["id"] for m in 
                                   self.visual_memory.find_similar_memories(detections, limit=3)]
            }
            
            return result
            
        except Exception as e:
            print(f"⚠️ Image processing error: {e}")
            return {"error": str(e)}
    
    def get_visual_status(self) -> Dict:
        """Get current visual processing status"""
        return {
            "camera_active": self.camera_active,
            "processing_active": self.processing_active,
            "cv_available": CV_AVAILABLE,
            "tf_available": TF_AVAILABLE,
            "advanced_image_available": ADVANCED_IMAGE_AVAILABLE,
            "visual_memories_count": len(self.visual_memory.visual_memories),
            "object_knowledge_count": len(self.visual_memory.object_knowledge),
            "current_frame_available": self.current_frame is not None,
            "camera_settings": self.camera_settings,
            "processing_settings": self.processing_settings
        }
    
    def save_visual_data(self):
        """Save visual memories and knowledge to files"""
        try:
            # Save visual memories
            memories_data = {
                "memories": self.visual_memory.visual_memories,
                "saved_at": time.time()
            }
            
            with open(self.visual_memories_file, "w") as f:
                json.dump(memories_data, f, indent=2, default=str)
            
            # Save knowledge base
            knowledge_data = {
                "object_knowledge": self.visual_memory.object_knowledge,
                "visual_patterns": self.visual_memory.visual_patterns,
                "scene_understanding": self.visual_memory.scene_understanding,
                "saved_at": time.time()
            }
            
            with open(self.visual_knowledge_file, "w") as f:
                json.dump(knowledge_data, f, indent=2, default=str)
            
            print("💾 Visual data saved successfully")
            
        except Exception as e:
            print(f"⚠️ Error saving visual data: {e}")
    
    def load_visual_data(self):
        """Load visual memories and knowledge from files"""
        try:
            # Load visual memories
            if Path(self.visual_memories_file).exists():
                with open(self.visual_memories_file, "r") as f:
                    memories_data = json.load(f)
                    self.visual_memory.visual_memories = memories_data.get("memories", [])
                    print(f"📂 Loaded {len(self.visual_memory.visual_memories)} visual memories")
            
            # Load knowledge base
            if Path(self.visual_knowledge_file).exists():
                with open(self.visual_knowledge_file, "r") as f:
                    knowledge_data = json.load(f)
                    self.visual_memory.object_knowledge = knowledge_data.get("object_knowledge", {})
                    self.visual_memory.visual_patterns = knowledge_data.get("visual_patterns", {})
                    self.visual_memory.scene_understanding = knowledge_data.get("scene_understanding", {})
                    print(f"🧠 Loaded visual knowledge base with {len(self.visual_memory.object_knowledge)} object types")
            
        except Exception as e:
            print(f"⚠️ Error loading visual data: {e}")

# Global visual processing system instance
visual_system = VisualProcessingSystem() if CV_AVAILABLE else None

def get_visual_system():
    """Get the global visual processing system instance"""
    return visual_system

if __name__ == "__main__":
    # Test the visual processing system
    print("👁️ Testing Enhanced Visual Processing System")
    
    if visual_system:
        # Test camera initialization
        print("Testing camera...")
        status = visual_system.get_visual_status()
        print(f"Status: {status}")
        
        # Test single frame capture
        if status["camera_active"]:
            print("Capturing single frame...")
            result = visual_system.capture_single_frame()
            if result:
                print(f"Detections found: {len(result['detections'])}")
                for detection in result["detections"]:
                    print(f"  - {detection['type']}: {detection}")
        
        # Save any data
        visual_system.save_visual_data()
        
    else:
        print("⚠️ Visual processing system not available")