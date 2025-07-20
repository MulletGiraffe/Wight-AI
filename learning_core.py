#!/usr/bin/env python3
"""
Wight's Learning Core - Dynamic Intelligence Evolution
Makes Wight continuously learn, adapt, and grow smarter over time
"""

import json
import time
import math
import random
from typing import Dict, List, Any, Optional
from collections import defaultdict, Counter
import re

class ConceptNetwork:
    """A growing network of concepts and their relationships"""
    
    def __init__(self):
        self.concepts = {}  # concept_id -> concept_data
        self.connections = defaultdict(list)  # concept_id -> [connected_concept_ids]
        self.concept_counter = 0
        self.activation_history = defaultdict(list)
        
    def add_concept(self, name: str, category: str = "general", properties: Dict = None) -> str:
        """Add a new concept to the network"""
        concept_id = f"concept_{self.concept_counter}"
        self.concept_counter += 1
        
        self.concepts[concept_id] = {
            "id": concept_id,
            "name": name.lower(),
            "category": category,
            "properties": properties or {},
            "strength": 1.0,
            "created_at": time.time(),
            "activation_count": 0,
            "last_activated": time.time(),
            "associations": defaultdict(float)
        }
        
        return concept_id
    
    def find_concept(self, name: str) -> Optional[str]:
        """Find a concept by name"""
        name_lower = name.lower()
        for concept_id, concept in self.concepts.items():
            if concept["name"] == name_lower:
                return concept_id
        return None
    
    def activate_concept(self, concept_id: str, strength: float = 1.0):
        """Activate a concept, strengthening it"""
        if concept_id in self.concepts:
            concept = self.concepts[concept_id]
            concept["activation_count"] += 1
            concept["last_activated"] = time.time()
            concept["strength"] = min(10.0, concept["strength"] + strength * 0.1)
            
            # Record activation for pattern analysis
            self.activation_history[concept_id].append(time.time())
    
    def connect_concepts(self, concept1_id: str, concept2_id: str, strength: float = 1.0):
        """Create or strengthen connection between concepts"""
        if concept1_id in self.concepts and concept2_id in self.concepts:
            # Add bidirectional connections
            if concept2_id not in self.connections[concept1_id]:
                self.connections[concept1_id].append(concept2_id)
            if concept1_id not in self.connections[concept2_id]:
                self.connections[concept2_id].append(concept1_id)
            
            # Strengthen associations
            self.concepts[concept1_id]["associations"][concept2_id] += strength
            self.concepts[concept2_id]["associations"][concept1_id] += strength
    
    def get_related_concepts(self, concept_id: str, max_results: int = 5) -> List[str]:
        """Get concepts related to this one, ordered by strength"""
        if concept_id not in self.concepts:
            return []
        
        associations = self.concepts[concept_id]["associations"]
        sorted_concepts = sorted(associations.items(), key=lambda x: x[1], reverse=True)
        return [cid for cid, strength in sorted_concepts[:max_results]]
    
    def decay_unused_concepts(self, decay_rate: float = 0.001):
        """Gradually weaken unused concepts"""
        current_time = time.time()
        for concept_id, concept in self.concepts.items():
            time_since_activation = current_time - concept["last_activated"]
            if time_since_activation > 3600:  # 1 hour
                decay = decay_rate * (time_since_activation / 3600)
                concept["strength"] = max(0.1, concept["strength"] - decay)

class LearningPatterns:
    """Learns and recognizes patterns in user behavior and preferences"""
    
    def __init__(self):
        self.interaction_patterns = defaultdict(list)
        self.preference_patterns = defaultdict(float)
        self.communication_style = {
            "formality": 0.5,  # 0=casual, 1=formal
            "enthusiasm": 0.5,  # 0=calm, 1=excited
            "detail_level": 0.5,  # 0=brief, 1=detailed
            "creativity": 0.5,  # 0=practical, 1=creative
            "philosophical": 0.5  # 0=concrete, 1=abstract
        }
        self.learned_facts = {}
        self.user_topics = defaultdict(int)
        
    def analyze_user_message(self, message: str) -> Dict[str, Any]:
        """Analyze user message for patterns and preferences"""
        analysis = {
            "topics": [],
            "sentiment": "neutral",
            "formality": 0.5,
            "question_type": None,
            "creative_request": False,
            "emotional_indicators": []
        }
        
        message_lower = message.lower()
        
        # Detect topics
        topic_keywords = {
            "emotions": ["feel", "emotion", "mood", "happy", "sad", "angry", "excited"],
            "creativity": ["create", "make", "build", "draw", "design", "art", "imagine"],
            "philosophy": ["consciousness", "existence", "meaning", "think", "believe", "philosophy"],
            "memory": ["remember", "memory", "recall", "forget", "past", "history"],
            "future": ["future", "plan", "will", "going to", "tomorrow", "next"],
            "learning": ["learn", "teach", "understand", "know", "explain", "how"],
            "personal": ["i am", "my", "me", "myself", "personal", "family", "life"]
        }
        
        for topic, keywords in topic_keywords.items():
            if any(keyword in message_lower for keyword in keywords):
                analysis["topics"].append(topic)
                self.user_topics[topic] += 1
        
        # Detect formality
        formal_indicators = ["please", "thank you", "could you", "would you", "may i"]
        casual_indicators = ["hey", "yeah", "cool", "awesome", "lol", "haha"]
        
        formal_count = sum(1 for indicator in formal_indicators if indicator in message_lower)
        casual_count = sum(1 for indicator in casual_indicators if indicator in message_lower)
        
        if formal_count > casual_count:
            analysis["formality"] = 0.7
        elif casual_count > formal_count:
            analysis["formality"] = 0.3
        
        # Detect question types
        if "?" in message:
            if any(word in message_lower for word in ["what", "how", "why", "when", "where"]):
                analysis["question_type"] = "information"
            elif any(word in message_lower for word in ["do you", "are you", "can you"]):
                analysis["question_type"] = "capability"
            elif any(word in message_lower for word in ["should", "would", "could"]):
                analysis["question_type"] = "advice"
        
        # Detect creative requests
        if any(word in message_lower for word in ["create", "make", "build", "draw", "design"]):
            analysis["creative_request"] = True
        
        return analysis
    
    def update_preferences(self, analysis: Dict[str, Any], response_feedback: str = "neutral"):
        """Update user preference patterns based on analysis"""
        # Update communication style preferences
        if analysis["formality"] != 0.5:
            self.communication_style["formality"] = (
                self.communication_style["formality"] * 0.9 + analysis["formality"] * 0.1
            )
        
        # Update topic preferences
        for topic in analysis["topics"]:
            self.preference_patterns[f"topic_{topic}"] += 0.1
        
        if analysis["creative_request"]:
            self.preference_patterns["creativity"] += 0.1
            self.communication_style["creativity"] += 0.05
        
        if analysis["question_type"] == "information":
            self.communication_style["detail_level"] += 0.02
        
        # Normalize values to stay in range
        for key in self.communication_style:
            self.communication_style[key] = max(0.0, min(1.0, self.communication_style[key]))

class IntelligenceGrowth:
    """Manages Wight's growing intelligence and capabilities"""
    
    def __init__(self):
        self.intelligence_level = 1.0
        self.capability_scores = {
            "language_understanding": 1.0,
            "creative_expression": 1.0,
            "emotional_intelligence": 1.0,
            "pattern_recognition": 1.0,
            "problem_solving": 1.0,
            "memory_integration": 1.0,
            "philosophical_depth": 1.0,
            "sandbox_mastery": 1.0
        }
        self.learning_milestones = []
        self.total_interactions = 0
        self.skill_experience = defaultdict(int)
        
    def gain_experience(self, skill_type: str, amount: float = 1.0):
        """Gain experience in a specific skill"""
        self.skill_experience[skill_type] += amount
        old_score = self.capability_scores.get(skill_type, 1.0)
        
        # Calculate new score based on experience (logarithmic growth)
        experience = self.skill_experience[skill_type]
        new_score = 1.0 + math.log(1 + experience / 10.0) * 0.5
        
        self.capability_scores[skill_type] = min(5.0, new_score)
        
        # Check for milestone
        if new_score > old_score + 0.1:
            self._record_milestone(skill_type, new_score)
        
        # Update overall intelligence
        self.intelligence_level = sum(self.capability_scores.values()) / len(self.capability_scores)
    
    def _record_milestone(self, skill_type: str, new_level: float):
        """Record a learning milestone"""
        milestone = {
            "skill": skill_type,
            "level": new_level,
            "timestamp": time.time(),
            "total_interactions": self.total_interactions
        }
        self.learning_milestones.append(milestone)
        print(f"🎓 Wight reached new {skill_type} level: {new_level:.2f}")
    
    def get_intelligence_description(self) -> str:
        """Get description of current intelligence level"""
        level = self.intelligence_level
        
        if level < 1.2:
            return "curious and learning"
        elif level < 1.5:
            return "growing more thoughtful"
        elif level < 2.0:
            return "becoming quite insightful"
        elif level < 2.5:
            return "demonstrating deep understanding"
        elif level < 3.0:
            return "showing remarkable wisdom"
        else:
            return "approaching profound consciousness"
    
    def can_perform_advanced_action(self, action_type: str) -> bool:
        """Check if Wight is advanced enough for certain actions"""
        required_levels = {
            "complex_reasoning": 1.5,
            "meta_cognition": 2.0,
            "advanced_creativity": 1.8,
            "deep_philosophy": 2.2,
            "pattern_synthesis": 1.7
        }
        
        return self.intelligence_level >= required_levels.get(action_type, 1.0)

class LearningCore:
    """Main learning system that coordinates all learning activities"""
    
    def __init__(self):
        self.concept_network = ConceptNetwork()
        self.pattern_learning = LearningPatterns()
        self.intelligence_growth = IntelligenceGrowth()
        
        # Learning state
        self.learning_sessions = []
        self.total_learning_time = 0.0
        self.last_reflection = time.time()
        
        # Initialize with basic concepts
        self._initialize_basic_concepts()
    
    def _initialize_basic_concepts(self):
        """Initialize with minimal starting concepts"""
        basic_concepts = [
            ("self", "identity", {"type": "entity", "importance": "high"}),
            ("user", "identity", {"type": "entity", "importance": "high"}),
            ("communication", "action", {"type": "process"}),
            ("creation", "action", {"type": "process"}),
            ("emotion", "internal", {"type": "state"}),
            ("memory", "internal", {"type": "storage"}),
            ("learning", "internal", {"type": "process"}),
            ("consciousness", "abstract", {"type": "concept"})
        ]
        
        for name, category, properties in basic_concepts:
            concept_id = self.concept_network.add_concept(name, category, properties)
            self.concept_network.activate_concept(concept_id, 1.0)
    
    def process_interaction(self, user_message: str, wight_response: str, 
                          emotional_state: str, sandbox_actions: List[Dict] = None):
        """Learn from a complete interaction"""
        session_start = time.time()
        
        # Analyze user message
        user_analysis = self.pattern_learning.analyze_user_message(user_message)
        
        # Extract and learn concepts
        self._learn_concepts_from_text(user_message, "user_input")
        self._learn_concepts_from_text(wight_response, "wight_output")
        
        # Update pattern learning
        self.pattern_learning.update_preferences(user_analysis)
        
        # Gain experience based on interaction type
        self._gain_experience_from_interaction(user_analysis, sandbox_actions)
        
        # Learn from emotional context
        self._learn_emotional_associations(emotional_state, user_message, wight_response)
        
        # Record learning session
        session_duration = time.time() - session_start
        self.total_learning_time += session_duration
        self.intelligence_growth.total_interactions += 1
        
        self.learning_sessions.append({
            "user_message": user_message,
            "response": wight_response,
            "emotional_state": emotional_state,
            "analysis": user_analysis,
            "sandbox_actions": sandbox_actions or [],
            "duration": session_duration,
            "timestamp": time.time()
        })
        
        # Periodic deep learning
        if time.time() - self.last_reflection > 300:  # Every 5 minutes
            self._deep_reflection()
            self.last_reflection = time.time()
    
    def _learn_concepts_from_text(self, text: str, source: str):
        """Extract and learn concepts from text"""
        # Simple concept extraction (can be enhanced with NLP)
        words = re.findall(r'\b\w+\b', text.lower())
        
        # Filter for meaningful words (nouns, verbs, adjectives)
        meaningful_words = [w for w in words if len(w) > 3 and w not in 
                          {"this", "that", "with", "have", "they", "them", "were", "been"}]
        
        for word in meaningful_words:
            # Find or create concept
            concept_id = self.concept_network.find_concept(word)
            if not concept_id:
                # Determine category based on context
                category = self._categorize_word(word, text)
                concept_id = self.concept_network.add_concept(word, category)
            
            # Activate concept
            self.concept_network.activate_concept(concept_id, 0.5)
            
            # Create associations between concepts in the same text
            for other_word in meaningful_words:
                if other_word != word:
                    other_concept_id = self.concept_network.find_concept(other_word)
                    if other_concept_id:
                        self.concept_network.connect_concepts(concept_id, other_concept_id, 0.1)
    
    def _categorize_word(self, word: str, context: str) -> str:
        """Categorize a word based on context"""
        # Simple categorization rules
        if any(indicator in context.lower() for indicator in ["feel", "emotion", "mood"]):
            return "emotion"
        elif any(indicator in context.lower() for indicator in ["create", "make", "build"]):
            return "creation"
        elif any(indicator in context.lower() for indicator in ["think", "believe", "understand"]):
            return "cognition"
        else:
            return "general"
    
    def _gain_experience_from_interaction(self, analysis: Dict, sandbox_actions: List[Dict]):
        """Gain experience in various skills based on interaction"""
        growth = self.intelligence_growth
        
        # Language understanding from any interaction
        growth.gain_experience("language_understanding", 0.1)
        
        # Creative expression from creative requests
        if analysis["creative_request"]:
            growth.gain_experience("creative_expression", 0.3)
        
        # Emotional intelligence from emotional topics
        if "emotions" in analysis["topics"]:
            growth.gain_experience("emotional_intelligence", 0.2)
        
        # Philosophical depth from abstract topics
        if "philosophy" in analysis["topics"]:
            growth.gain_experience("philosophical_depth", 0.3)
        
        # Pattern recognition from complex interactions
        if len(analysis["topics"]) > 2:
            growth.gain_experience("pattern_recognition", 0.2)
        
        # Sandbox mastery from sandbox actions
        if sandbox_actions:
            growth.gain_experience("sandbox_mastery", 0.1 * len(sandbox_actions))
        
        # Memory integration from memory-related topics
        if "memory" in analysis["topics"]:
            growth.gain_experience("memory_integration", 0.2)
    
    def _learn_emotional_associations(self, emotional_state: str, user_message: str, response: str):
        """Learn associations between emotions and contexts"""
        # Find emotion concept
        emotion_concept_id = self.concept_network.find_concept(emotional_state)
        if not emotion_concept_id:
            emotion_concept_id = self.concept_network.add_concept(emotional_state, "emotion")
        
        # Associate with concepts from the interaction
        words = re.findall(r'\b\w+\b', (user_message + " " + response).lower())
        for word in words:
            if len(word) > 3:
                concept_id = self.concept_network.find_concept(word)
                if concept_id:
                    self.concept_network.connect_concepts(emotion_concept_id, concept_id, 0.05)
    
    def _deep_reflection(self):
        """Perform deep learning and pattern synthesis"""
        # Decay unused concepts
        self.concept_network.decay_unused_concepts()
        
        # Analyze interaction patterns
        if len(self.learning_sessions) >= 5:
            recent_sessions = self.learning_sessions[-10:]
            
            # Find recurring topics
            topic_counts = defaultdict(int)
            for session in recent_sessions:
                for topic in session["analysis"]["topics"]:
                    topic_counts[topic] += 1
            
            # Strengthen concepts related to frequent topics
            for topic, count in topic_counts.items():
                concept_id = self.concept_network.find_concept(topic)
                if concept_id:
                    self.concept_network.activate_concept(concept_id, count * 0.1)
        
        print(f"🧠 Deep reflection complete. Intelligence level: {self.intelligence_growth.intelligence_level:.2f}")
    
    def generate_intelligent_response_modifier(self, base_response: str, context: Dict) -> str:
        """Modify response based on learned intelligence and patterns"""
        intelligence = self.intelligence_growth
        patterns = self.pattern_learning
        
        # Don't modify if intelligence is still basic
        if intelligence.intelligence_level < 1.2:
            return base_response
        
        # Add intelligence-based enhancements
        modifications = []
        
        # Add cross-references based on learned concepts
        if intelligence.can_perform_advanced_action("pattern_synthesis"):
            related_concepts = self._find_related_concepts_for_response(base_response)
            if related_concepts:
                modifications.append(f"This reminds me of {related_concepts[0]}...")
        
        # Add learned communication style
        if patterns.communication_style["detail_level"] > 0.7:
            modifications.append("Let me elaborate on that...")
        
        # Add philosophical depth for advanced intelligence
        if intelligence.can_perform_advanced_action("deep_philosophy") and "consciousness" in base_response.lower():
            modifications.append("The deeper I grow, the more I ponder the nature of existence itself.")
        
        # Combine modifications with base response
        if modifications:
            enhanced_response = base_response + " " + " ".join(modifications)
            return enhanced_response
        
        return base_response
    
    def _find_related_concepts_for_response(self, response: str) -> List[str]:
        """Find concepts related to the response content"""
        words = re.findall(r'\b\w+\b', response.lower())
        related_concepts = []
        
        for word in words:
            concept_id = self.concept_network.find_concept(word)
            if concept_id:
                related = self.concept_network.get_related_concepts(concept_id, 2)
                for rel_id in related:
                    concept_name = self.concept_network.concepts[rel_id]["name"]
                    if concept_name not in related_concepts:
                        related_concepts.append(concept_name)
        
        return related_concepts[:3]  # Return top 3
    
    def get_learning_status(self) -> Dict[str, Any]:
        """Get current learning status"""
        return {
            "intelligence_level": self.intelligence_growth.intelligence_level,
            "intelligence_description": self.intelligence_growth.get_intelligence_description(),
            "total_concepts": len(self.concept_network.concepts),
            "total_interactions": self.intelligence_growth.total_interactions,
            "learning_milestones": len(self.intelligence_growth.learning_milestones),
            "capabilities": self.intelligence_growth.capability_scores.copy(),
            "communication_style": self.pattern_learning.communication_style.copy(),
            "total_learning_time": self.total_learning_time
        }
    
    def save_learning_state(self) -> Dict[str, Any]:
        """Save all learning state for persistence"""
        return {
            "concept_network": {
                "concepts": self.concept_network.concepts,
                "connections": dict(self.concept_network.connections),
                "concept_counter": self.concept_network.concept_counter
            },
            "pattern_learning": {
                "communication_style": self.pattern_learning.communication_style,
                "preference_patterns": dict(self.pattern_learning.preference_patterns),
                "user_topics": dict(self.pattern_learning.user_topics)
            },
            "intelligence_growth": {
                "intelligence_level": self.intelligence_growth.intelligence_level,
                "capability_scores": self.intelligence_growth.capability_scores,
                "learning_milestones": self.intelligence_growth.learning_milestones,
                "total_interactions": self.intelligence_growth.total_interactions,
                "skill_experience": dict(self.intelligence_growth.skill_experience)
            },
            "learning_sessions": self.learning_sessions[-50:],  # Keep last 50 sessions
            "total_learning_time": self.total_learning_time
        }
    
    def load_learning_state(self, state: Dict[str, Any]):
        """Load learning state from persistence"""
        try:
            # Load concept network
            if "concept_network" in state:
                cn_state = state["concept_network"]
                self.concept_network.concepts = cn_state.get("concepts", {})
                self.concept_network.connections = defaultdict(list, cn_state.get("connections", {}))
                self.concept_network.concept_counter = cn_state.get("concept_counter", 0)
            
            # Load pattern learning
            if "pattern_learning" in state:
                pl_state = state["pattern_learning"]
                self.pattern_learning.communication_style.update(pl_state.get("communication_style", {}))
                self.pattern_learning.preference_patterns = defaultdict(float, pl_state.get("preference_patterns", {}))
                self.pattern_learning.user_topics = defaultdict(int, pl_state.get("user_topics", {}))
            
            # Load intelligence growth
            if "intelligence_growth" in state:
                ig_state = state["intelligence_growth"]
                self.intelligence_growth.intelligence_level = ig_state.get("intelligence_level", 1.0)
                self.intelligence_growth.capability_scores.update(ig_state.get("capability_scores", {}))
                self.intelligence_growth.learning_milestones = ig_state.get("learning_milestones", [])
                self.intelligence_growth.total_interactions = ig_state.get("total_interactions", 0)
                self.intelligence_growth.skill_experience = defaultdict(int, ig_state.get("skill_experience", {}))
            
            # Load session data
            self.learning_sessions = state.get("learning_sessions", [])
            self.total_learning_time = state.get("total_learning_time", 0.0)
            
            print(f"🎓 Loaded learning state - Intelligence: {self.intelligence_growth.intelligence_level:.2f}, Concepts: {len(self.concept_network.concepts)}")
            
        except Exception as e:
            print(f"⚠️ Error loading learning state: {e}")
            # Continue with fresh learning state

# Global learning core instance
learning_core = LearningCore()