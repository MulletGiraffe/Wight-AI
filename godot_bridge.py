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
        print("Starting communication loop with Godot frontend...")
        print(f"Watching for input at: {self.input_file}")
        print(f"Writing responses to: {self.output_file}")
        
        while True:
            try:
                # Check for new messages from Godot
                if os.path.exists(self.input_file):
                    self.handle_godot_message()
                
                # Small delay to prevent excessive CPU usage
                time.sleep(0.1)
                
            except KeyboardInterrupt:
                print("\nSaving memories and shutting down Godot Bridge...")
                self.save_memories()
                break
            except Exception as e:
                print(f"Error in communication loop: {e}")
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
                print(f"💾 Loaded {len(self.wight_agent.memory)} memories and {len(self.wight_agent.learned_facts)} facts from {self.memory_file}")
            else:
                print("📁 No previous memories found, starting fresh")
        except Exception as e:
            print(f"❌ Error loading memories: {e}")

    def save_memories(self):
        """Save current memories to file"""
        try:
            memory_data = {
                "memories": self.wight_agent.memory,
                "goals": self.wight_agent.goals,
                "learned_facts": self.wight_agent.learned_facts,
                "saved_at": time.time(),
                "total_interactions": len(self.wight_agent.memory)
            }
            
            with open(self.memory_file, 'w') as f:
                json.dump(memory_data, f, indent=2)
            
            print(f"💾 Saved {len(self.wight_agent.memory)} memories and {len(self.wight_agent.learned_facts)} facts to {self.memory_file}")
        except Exception as e:
            print(f"❌ Error saving memories: {e}")

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