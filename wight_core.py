# Core logic placeholder

import random
import time

class Wight:
    def __init__(self):
        self.memory = []
        self.goals = []
        self.personality_traits = {
            "curiosity": 0.8,
            "helpfulness": 0.9,
            "creativity": 0.7,
            "analytical": 0.6
        }
        self.learned_facts = {}
        
    def learn(self, input_data):
        """Learn from input and extract facts"""
        self.memory.append({
            "data": input_data,
            "timestamp": time.time(),
            "type": "interaction"
        })
        
        # Simple fact extraction (look for "my name is", "I am", etc.)
        if isinstance(input_data, str):
            self._extract_facts(input_data.lower())

    def _extract_facts(self, text):
        """Extract facts from conversation"""
        if "my name is" in text:
            name = text.split("my name is")[-1].strip().split()[0]
            self.learned_facts["user_name"] = name
            
        if "i am" in text and ("years old" in text or "year old" in text):
            words = text.split()
            for i, word in enumerate(words):
                if word.isdigit() and i < len(words) - 1:
                    if "year" in words[i + 1]:
                        self.learned_facts["user_age"] = int(word)
                        
        if "i like" in text:
            likes = text.split("i like")[-1].strip()
            if "user_likes" not in self.learned_facts:
                self.learned_facts["user_likes"] = []
            self.learned_facts["user_likes"].append(likes)

    def act(self):
        """Decide on an action based on goals and recent inputs"""
        if len(self.memory) > 5:
            return "Analyzing patterns in conversation"
        return "Listening and learning"

    def interact(self, message):
        """Generate contextual responses based on memory and personality"""
        self.learn(message)
        
        # Simple responses based on content
        message_lower = message.lower()
        
        # Greeting responses
        if any(word in message_lower for word in ["hello", "hi", "hey", "greetings"]):
            name = self.learned_facts.get("user_name", "")
            if name:
                return f"Hello {name}! Good to see you again. I remember our previous conversations. How can I help you today?"
            else:
                return "Hello! I'm Wight, your AI companion. I'm designed to learn and grow from our conversations. What's your name?"
        
        # Question about memory
        if "remember" in message_lower or "memory" in message_lower:
            return f"I currently have {len(self.memory)} memories stored, including {len(self.learned_facts)} facts about you and our conversations."
        
        # Personal questions
        if "how are you" in message_lower:
            memory_count = len(self.memory)
            if memory_count < 5:
                return "I'm just getting started! Each conversation helps me grow and understand better."
            elif memory_count < 20:
                return "I'm learning and growing! Our conversations are helping me develop my understanding."
            else:
                return "I'm feeling quite experienced now! I've learned so much from our interactions."
        
        # Facts recall
        if "what do you know about me" in message_lower:
            if self.learned_facts:
                facts_list = []
                for key, value in self.learned_facts.items():
                    if key == "user_name":
                        facts_list.append(f"Your name is {value}")
                    elif key == "user_age":
                        facts_list.append(f"You are {value} years old")
                    elif key == "user_likes":
                        facts_list.append(f"You like: {', '.join(value)}")
                
                return f"Here's what I remember about you: {'. '.join(facts_list)}. I learn more about you with each conversation!"
            else:
                return "I don't know much about you yet! Tell me about yourself - your name, interests, or anything you'd like to share."
        
        # Learning responses
        if any(word in message_lower for word in ["learn", "teach", "explain"]):
            responses = [
                "I'm always eager to learn! What would you like to teach me?",
                "Learning is my core function. Please share your knowledge with me!",
                "I find learning fascinating. Every piece of information helps me grow."
            ]
            return random.choice(responses)
        
        # Default thoughtful response
        thoughtful_responses = [
            f"That's interesting! I've now had {len(self.memory)} interactions total. Can you tell me more about that?",
            f"I'm processing what you said and adding it to my memory. How does this relate to your other interests?",
            f"Thank you for sharing that with me. I'm continuously learning from our conversations. What else would you like to discuss?",
            f"I find that fascinating! My curiosity trait is quite high ({self.personality_traits['curiosity']:.1f}), so I'd love to learn more.",
        ]
        
        return random.choice(thoughtful_responses)