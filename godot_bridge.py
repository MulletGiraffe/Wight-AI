#!/usr/bin/env python3
"""
Godot Bridge for Wight AI Agent
Handles communication between Python AI backend and Godot frontend
"""

import json
import time
import os
from pathlib import Path
from wight_core import Wight

class GodotBridge:
    def __init__(self):
        self.wight_agent = Wight()
        self.input_file = "data/input.json"
        self.output_file = "data/output.json"
        self.memory_file = "data/memories.json"
        
        # Ensure data directory exists
        Path("data").mkdir(exist_ok=True)
        
        # Load memories on startup
        self.load_memories()
        
        print("Godot Bridge initialized - ready to serve Wight AI agent")
        print(f"Loaded {len(self.wight_agent.memory)} memories from previous sessions")

    def start_listening(self):
        """Main loop to listen for messages from Godot frontend"""
        print("Starting Wight's consciousness and communication loop...")
        print(f"Watching for input at: {self.input_file}")
        print(f"Writing responses to: {self.output_file}")
        print("🧠 Wight's mind is now active and autonomous...")
        
        last_mind_loop = time.time()
        last_autonomous_message = time.time()
        
        while True:
            try:
                current_time = time.time()
                
                # Check for new messages from Godot
                if os.path.exists(self.input_file):
                    self.handle_godot_message()
                
                # Run Wight's mind loop periodically
                if current_time - last_mind_loop > 2.0:  # Every 2 seconds
                    mind_result = self.wight_agent.mind_loop()
                    last_mind_loop = current_time
                    
                    # Send autonomous thoughts to Godot if any
                    if mind_result["thoughts"] and current_time - last_autonomous_message > 30.0:
                        autonomous_thought = mind_result["thoughts"][0]
                        self.send_autonomous_message(autonomous_thought)
                        last_autonomous_message = current_time
                    
                    # Send sandbox actions to Godot
                    if mind_result["sandbox_actions"]:
                        self.send_sandbox_updates(mind_result["sandbox_actions"])
                    
                    # Log significant mental activity
                    if mind_result["thoughts"] or mind_result["sandbox_actions"]:
                        self.log_mental_activity(mind_result)
                
                # Small delay to prevent excessive CPU usage
                time.sleep(0.1)
                
            except KeyboardInterrupt:
                print("\n🧠 Wight is going to sleep...")
                print("Saving memories and shutting down Godot Bridge...")
                self.save_memories()
                break
            except Exception as e:
                print(f"❌ Error in consciousness loop: {e}")
                time.sleep(1)

    def handle_godot_message(self):
        """Process message from Godot frontend"""
        try:
            # Read message from input file
            with open(self.input_file, 'r') as f:
                data = json.load(f)
            
            message = data.get('message', '')
            timestamp = data.get('timestamp', time.time())
            message_id = data.get('id', 'unknown')
            
            print(f"📥 Received message {message_id}: {message}")
            
            # Remove input file
            os.remove(self.input_file)
            
            # Process message with Wight AI
            if message.lower() == 'ping':
                response = "pong - Wight AI agent is responsive! 🤖"
            else:
                response = self.wight_agent.interact(message)
                # Save memories after each interaction
                self.save_memories()
            
            # Send response back to Godot
            self.send_response_to_godot(response, timestamp, message_id)
            
        except Exception as e:
            error_msg = f"Error processing message: {e}"
            print(f"❌ {error_msg}")
            self.send_response_to_godot(error_msg)



    def send_response_to_godot(self, response, original_timestamp=None, message_id=None):
        """Send response back to Godot frontend"""
        try:
            response_data = {
                "response": response,
                "timestamp": time.time(),
                "original_timestamp": original_timestamp,
                "message_id": message_id,
                "agent_memory_count": len(self.wight_agent.memory),
                "agent_goals_count": len(self.wight_agent.goals),
                "status": "success"
            }
            
            with open(self.output_file, 'w') as f:
                json.dump(response_data, f, indent=2)
            
            print(f"📤 Sent response {message_id}: {response}")
            
        except Exception as e:
            print(f"❌ Error sending response to Godot: {e}")

    def load_memories(self):
        """Load persistent memories from file"""
        try:
            if os.path.exists(self.memory_file):
                with open(self.memory_file, 'r') as f:
                    memories = json.load(f)
                    self.wight_agent.memory = memories.get('memories', [])
                    self.wight_agent.goals = memories.get('goals', [])
                    self.wight_agent.learned_facts = memories.get('learned_facts', {})
                    
                    # Restore emotional state
                    saved_emotions = memories.get('emotions', {})
                    for emotion, value in saved_emotions.items():
                        if emotion in self.wight_agent.emotions.emotions:
                            self.wight_agent.emotions.emotions[emotion] = value
                    
                    # Restore emotional history
                    self.wight_agent.emotions.emotional_history = memories.get('emotional_history', [])
                    
                    # Restore sandbox objects
                    saved_objects = memories.get('sandbox_objects', {})
                    self.wight_agent.sandbox.objects = saved_objects
                    if saved_objects:
                        # Update counter to avoid ID conflicts
                        max_id = max(int(obj_id) for obj_id in saved_objects.keys())
                        self.wight_agent.sandbox.object_id_counter = max_id
                    
                    # Update consciousness time
                    consciousness_time = memories.get('consciousness_time', 0)
                    if consciousness_time > 0:
                        self.wight_agent.identity["birth_time"] = time.time() - consciousness_time
                
                print(f"💾 Loaded {len(self.wight_agent.memory)} memories, {len(self.wight_agent.learned_facts)} facts, {len(saved_emotions)} emotions, and {len(saved_objects)} sandbox objects")
                
                if consciousness_time > 0:
                    print(f"🧠 Wight's consciousness has been active for {consciousness_time/3600:.1f} hours")
                    
            else:
                print("📁 No previous memories found - Wight is being born fresh!")
        except Exception as e:
            print(f"❌ Error loading memories: {e}")

    def save_memories(self):
        """Save current memories to file"""
        try:
            memory_data = {
                "memories": self.wight_agent.memory,
                "goals": self.wight_agent.goals,
                "learned_facts": self.wight_agent.learned_facts,
                "emotions": self.wight_agent.emotions.emotions,
                "emotional_history": self.wight_agent.emotions.emotional_history[-50:],  # Keep last 50
                "sandbox_objects": self.wight_agent.sandbox.objects,
                "saved_at": time.time(),
                "total_interactions": len(self.wight_agent.memory),
                "consciousness_time": time.time() - self.wight_agent.identity["birth_time"]
            }
            
            with open(self.memory_file, 'w') as f:
                json.dump(memory_data, f, indent=2)
            
            print(f"💾 Saved {len(self.wight_agent.memory)} memories, {len(self.wight_agent.learned_facts)} facts, and {len(self.wight_agent.sandbox.objects)} sandbox objects")
        except Exception as e:
            print(f"❌ Error saving memories: {e}")
    
    def send_autonomous_message(self, thought_data: dict):
        """Send autonomous thoughts from Wight to Godot"""
        try:
            autonomous_data = {
                "type": "autonomous_thought",
                "content": thought_data["content"],
                "thought_type": thought_data["type"],
                "timestamp": time.time(),
                "emotional_state": self.wight_agent.emotions.get_dominant_emotion(),
                "memory_count": len(self.wight_agent.memory),
                "sandbox_object_count": len(self.wight_agent.sandbox.objects)
            }
            
            # Write to a special autonomous file
            autonomous_file = "data/autonomous.json"
            with open(autonomous_file, 'w') as f:
                json.dump(autonomous_data, f, indent=2)
            
            print(f"💭 Wight's autonomous thought: {thought_data['content'][:50]}...")
            
        except Exception as e:
            print(f"❌ Error sending autonomous message: {e}")
    
    def send_sandbox_updates(self, sandbox_actions: list):
        """Send sandbox actions to Godot"""
        try:
            # Get all pending actions from sandbox
            pending_actions = self.wight_agent.sandbox.get_pending_actions()
            all_actions = sandbox_actions + pending_actions
            
            if all_actions:
                sandbox_data = {
                    "type": "sandbox_update",
                    "actions": all_actions,
                    "current_objects": self.wight_agent.sandbox.objects,
                    "timestamp": time.time()
                }
                
                sandbox_file = "data/sandbox.json"
                with open(sandbox_file, 'w') as f:
                    json.dump(sandbox_data, f, indent=2)
                
                print(f"🎨 Sandbox update: {len(all_actions)} action(s)")
                
        except Exception as e:
            print(f"❌ Error sending sandbox updates: {e}")
    
    def log_mental_activity(self, mind_result: dict):
        """Log Wight's mental activity for debugging"""
        if mind_result["thoughts"]:
            for thought in mind_result["thoughts"]:
                print(f"🧠 [{thought['type']}] {thought['content'][:80]}...")
        
        if mind_result["emotional_changes"]:
            print(f"💗 Emotional changes: {mind_result['emotional_changes']}")
        
        if mind_result["sandbox_actions"]:
            print(f"🎨 Sandbox activity: {len(mind_result['sandbox_actions'])} action(s)")

    def get_agent_status(self):
        """Get current status of Wight AI agent"""
        return {
            "memory_items": len(self.wight_agent.memory),
            "goals": len(self.wight_agent.goals),
            "last_action": self.wight_agent.act()
        }

if __name__ == "__main__":
    print("Starting Wight AI Agent with Godot Bridge...")
    bridge = GodotBridge()
    
    # Print initial status
    status = bridge.get_agent_status()
    print(f"Agent Status: {status}")
    
    # Start listening for Godot messages
    bridge.start_listening()