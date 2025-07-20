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
        self.communication_file = "data/communication.json"
        self.response_file = "data/response.json"
        self.learning_file = "data/learning_input.json"
        
        # Ensure data directory exists
        Path("data").mkdir(exist_ok=True)
        
        print("Godot Bridge initialized - ready to serve Wight AI agent")

    def start_listening(self):
        """Main loop to listen for messages from Godot frontend"""
        print("Starting communication loop with Godot frontend...")
        
        while True:
            try:
                # Check for new messages from Godot
                if os.path.exists(self.communication_file):
                    self.handle_godot_message()
                
                # Check for learning data
                if os.path.exists(self.learning_file):
                    self.handle_learning_data()
                
                # Small delay to prevent excessive CPU usage
                time.sleep(0.1)
                
            except KeyboardInterrupt:
                print("\nShutting down Godot Bridge...")
                break
            except Exception as e:
                print(f"Error in communication loop: {e}")
                time.sleep(1)

    def handle_godot_message(self):
        """Process message from Godot frontend"""
        try:
            # Read message from communication file
            with open(self.communication_file, 'r') as f:
                data = json.load(f)
            
            message = data.get('message', '')
            timestamp = data.get('timestamp', time.time())
            source = data.get('source', 'unknown')
            
            print(f"Received from {source}: {message}")
            
            # Remove communication file
            os.remove(self.communication_file)
            
            # Process message with Wight AI
            if message.lower() == 'ping':
                response = "pong - Wight AI agent is responsive"
            else:
                response = self.wight_agent.interact(message)
            
            # Send response back to Godot
            self.send_response_to_godot(response, timestamp)
            
        except Exception as e:
            print(f"Error handling Godot message: {e}")
            self.send_response_to_godot(f"Error processing message: {e}")

    def handle_learning_data(self):
        """Process learning data from Godot"""
        try:
            with open(self.learning_file, 'r') as f:
                data = json.load(f)
            
            learning_data = data.get('data', {})
            print(f"Received learning data: {learning_data}")
            
            # Send to Wight agent for learning
            self.wight_agent.learn(learning_data)
            
            # Remove learning file
            os.remove(self.learning_file)
            
        except Exception as e:
            print(f"Error handling learning data: {e}")

    def send_response_to_godot(self, response, original_timestamp=None):
        """Send response back to Godot frontend"""
        try:
            response_data = {
                "response": response,
                "timestamp": time.time(),
                "original_timestamp": original_timestamp,
                "agent_memory_count": len(self.wight_agent.memory),
                "agent_goals_count": len(self.wight_agent.goals)
            }
            
            with open(self.response_file, 'w') as f:
                json.dump(response_data, f, indent=2)
            
            print(f"Sent response to Godot: {response}")
            
        except Exception as e:
            print(f"Error sending response to Godot: {e}")

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