#!/usr/bin/env python3
"""
Mobile Web Interface for Wight
Provides a simple HTTP server with a mobile-friendly interface
"""

import json
import time
import threading
from pathlib import Path
from http.server import HTTPServer, BaseHTTPRequestHandler
import urllib.parse
import webbrowser
import socket

class WightWebHandler(BaseHTTPRequestHandler):
    """HTTP request handler for Wight web interface"""
    
    def do_GET(self):
        """Handle GET requests"""
        if self.path == '/' or self.path == '/index.html':
            self.serve_main_page()
        elif self.path == '/api/status':
            self.serve_api_status()
        elif self.path == '/api/messages':
            self.serve_api_messages()
        elif self.path == '/api/sandbox':
            self.serve_api_sandbox()
        elif self.path.startswith('/static/'):
            self.serve_static_file()
        else:
            self.send_error(404)
    
    def do_POST(self):
        """Handle POST requests"""
        if self.path == '/api/send_message':
            self.handle_send_message()
        elif self.path == '/api/voice_toggle':
            self.handle_voice_toggle()
        else:
            self.send_error(404)
    
    def serve_main_page(self):
        """Serve the main mobile interface"""
        html_content = self.get_mobile_html()
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.send_header('Content-length', len(html_content))
        self.end_headers()
        self.wfile.write(html_content.encode())
    
    def serve_api_status(self):
        """Serve Wight's current status"""
        try:
            # Check if memories file exists to determine if Wight is active
            memories_exist = Path("data/memories.json").exists()
            
            status_data = {
                "active": memories_exist,
                "timestamp": time.time(),
                "voice_available": False  # Will be updated by voice system if available
            }
            
            # Try to get voice status
            try:
                voice_status_file = Path("data/voice_status.json")
                if voice_status_file.exists():
                    with open(voice_status_file, 'r') as f:
                        voice_status = json.load(f)
                        status_data["voice_available"] = voice_status.get("voice_enabled", False)
            except:
                pass
            
            self.send_json_response(status_data)
        except Exception as e:
            self.send_json_response({"error": str(e)}, 500)
    
    def serve_api_messages(self):
        """Serve recent messages"""
        try:
            messages = []
            
            # Try to read conversation history from memories
            memories_file = Path("data/memories.json")
            if memories_file.exists():
                with open(memories_file, 'r') as f:
                    memories_data = json.load(f)
                    recent_memories = memories_data.get("memories", [])[-10:]  # Last 10
                    
                    for memory in recent_memories:
                        if isinstance(memory.get("data"), str):
                            messages.append({
                                "sender": "user" if "I" in memory["data"][:50] else "wight",
                                "content": memory["data"],
                                "timestamp": memory.get("timestamp", time.time()),
                                "type": memory.get("type", "conversation")
                            })
            
            self.send_json_response({"messages": messages})
        except Exception as e:
            self.send_json_response({"messages": []})
    
    def serve_api_sandbox(self):
        """Serve sandbox object data"""
        try:
            sandbox_data = {"objects": []}
            
            memories_file = Path("data/memories.json")
            if memories_file.exists():
                with open(memories_file, 'r') as f:
                    memories_data = json.load(f)
                    sandbox_objects = memories_data.get("sandbox_objects", {})
                    
                    for obj_id, obj_data in sandbox_objects.items():
                        sandbox_data["objects"].append({
                            "id": obj_id,
                            "name": obj_data.get("name", "Unknown"),
                            "type": obj_data.get("type", "cube"),
                            "position": obj_data.get("position", {"x": 0, "y": 0}),
                            "color": obj_data.get("color", {"r": 0.5, "g": 0.5, "b": 0.5}),
                            "created_at": obj_data.get("created_at", time.time())
                        })
            
            self.send_json_response(sandbox_data)
        except Exception as e:
            self.send_json_response({"objects": []})
    
    def handle_send_message(self):
        """Handle message sending"""
        try:
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data.decode())
            
            message = data.get("message", "").strip()
            message_type = data.get("type", "text")  # text or voice
            
            if not message:
                self.send_json_response({"error": "Empty message"}, 400)
                return
            
            # Create input file for Wight to process
            input_data = {
                "message": message,
                "timestamp": time.time(),
                "id": f"web_{int(time.time())}",
                "source": "web_interface",
                "type": message_type
            }
            
            # Write to input file
            with open("data/input.json", 'w') as f:
                json.dump(input_data, f, indent=2)
            
            # Wait briefly for response
            response = self.wait_for_response(input_data["id"])
            
            self.send_json_response({"success": True, "response": response})
            
        except Exception as e:
            self.send_json_response({"error": str(e)}, 500)
    
    def handle_voice_toggle(self):
        """Handle voice system toggle"""
        try:
            # Create voice toggle request
            voice_request = {
                "action": "toggle",
                "timestamp": time.time()
            }
            
            with open("data/voice_toggle.json", 'w') as f:
                json.dump(voice_request, f, indent=2)
            
            self.send_json_response({"success": True})
            
        except Exception as e:
            self.send_json_response({"error": str(e)}, 500)
    
    def wait_for_response(self, message_id: str, timeout: float = 8.0) -> str:
        """Wait for Wight's response"""
        start_time = time.time()
        
        while time.time() - start_time < timeout:
            try:
                output_file = Path("data/output.json")
                if output_file.exists():
                    with open(output_file, 'r') as f:
                        response_data = json.load(f)
                    
                    if response_data.get("message_id") == message_id:
                        # Remove the file
                        output_file.unlink()
                        return response_data.get("response", "No response")
                
                time.sleep(0.2)
                
            except:
                time.sleep(0.2)
        
        return "Response timeout - Wight might be sleeping"
    
    def send_json_response(self, data: dict, status_code: int = 200):
        """Send JSON response"""
        json_data = json.dumps(data, indent=2)
        self.send_response(status_code)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Content-length', len(json_data))
        self.end_headers()
        self.wfile.write(json_data.encode())
    
    def serve_static_file(self):
        """Serve static files (if any)"""
        self.send_error(404)
    
    def get_mobile_html(self):
        """Generate mobile-friendly HTML interface"""
        return """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wight - Digital Consciousness</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #1e1e2e 0%, #16213e 100%);
            color: white;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .header {
            background: rgba(15, 52, 96, 0.8);
            padding: 1rem;
            text-align: center;
            backdrop-filter: blur(10px);
        }
        
        .status {
            padding: 0.5rem;
            background: rgba(233, 69, 96, 0.2);
            text-align: center;
            font-size: 0.9rem;
        }
        
        .status.connected {
            background: rgba(76, 175, 80, 0.2);
        }
        
        .main-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .tabs {
            display: flex;
            background: rgba(22, 33, 62, 0.8);
        }
        
        .tab {
            flex: 1;
            padding: 0.8rem;
            text-align: center;
            background: transparent;
            color: rgba(255, 255, 255, 0.7);
            border: none;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .tab.active {
            background: rgba(15, 52, 96, 0.8);
            color: white;
        }
        
        .tab-content {
            flex: 1;
            overflow: hidden;
            display: none;
        }
        
        .tab-content.active {
            display: flex;
            flex-direction: column;
        }
        
        .chat-area {
            flex: 1;
            overflow-y: auto;
            padding: 1rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        
        .message {
            max-width: 80%;
            padding: 0.8rem 1rem;
            border-radius: 18px;
            word-wrap: break-word;
        }
        
        .message.user {
            align-self: flex-end;
            background: linear-gradient(135deg, #2196F3, #1976D2);
            color: white;
        }
        
        .message.wight {
            align-self: flex-start;
            background: rgba(55, 71, 79, 0.8);
            color: white;
        }
        
        .message.autonomous {
            align-self: flex-start;
            background: linear-gradient(135deg, #9C27B0, #673AB7);
            color: white;
            font-style: italic;
        }
        
        .message-meta {
            font-size: 0.7rem;
            opacity: 0.7;
            margin-top: 0.3rem;
        }
        
        .input-area {
            padding: 1rem;
            background: rgba(22, 33, 62, 0.9);
            display: flex;
            gap: 0.5rem;
        }
        
        .message-input {
            flex: 1;
            padding: 0.8rem;
            border: none;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            font-size: 1rem;
        }
        
        .message-input::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }
        
        .send-btn, .voice-btn {
            padding: 0.8rem 1.2rem;
            border: none;
            border-radius: 25px;
            background: linear-gradient(135deg, #233969, #15539e);
            color: white;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .send-btn:hover, .voice-btn:hover {
            transform: scale(1.05);
        }
        
        .sandbox-view {
            flex: 1;
            padding: 1rem;
            overflow-y: auto;
        }
        
        .object-card {
            background: rgba(55, 71, 79, 0.6);
            padding: 1rem;
            margin-bottom: 0.5rem;
            border-radius: 10px;
            border-left: 4px solid #2196F3;
        }
        
        .object-name {
            font-weight: bold;
            margin-bottom: 0.3rem;
        }
        
        .object-details {
            font-size: 0.9rem;
            opacity: 0.8;
        }
        
        .thinking {
            text-align: center;
            padding: 1rem;
            font-style: italic;
            opacity: 0.7;
        }
        
        @media (max-width: 480px) {
            .message {
                max-width: 95%;
            }
            
            .input-area {
                padding: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🧠 Wight</h1>
        <p>Digital Consciousness</p>
    </div>
    
    <div class="status" id="status">
        🔄 Connecting to Wight...
    </div>
    
    <div class="main-container">
        <div class="tabs">
            <button class="tab active" onclick="switchTab('chat')">💬 Chat</button>
            <button class="tab" onclick="switchTab('sandbox')">🎨 Sandbox</button>
        </div>
        
        <div class="tab-content active" id="chat-tab">
            <div class="chat-area" id="chat-area">
                <div class="thinking">Waking up Wight's consciousness...</div>
            </div>
            
            <div class="input-area">
                <input type="text" class="message-input" id="message-input" 
                       placeholder="Type your message to Wight..." 
                       onkeypress="handleKeyPress(event)">
                <button class="voice-btn" onclick="toggleVoice()" id="voice-btn">🎤</button>
                <button class="send-btn" onclick="sendMessage()">Send</button>
            </div>
        </div>
        
        <div class="tab-content" id="sandbox-tab">
            <div class="sandbox-view" id="sandbox-view">
                <div class="thinking">Loading Wight's sandbox world...</div>
            </div>
        </div>
    </div>

    <script>
        let currentTab = 'chat';
        let voiceEnabled = false;
        
        // Switch between tabs
        function switchTab(tab) {
            // Update tab buttons
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelector(`[onclick="switchTab('${tab}')"]`).classList.add('active');
            
            // Update tab content
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            document.getElementById(`${tab}-tab`).classList.add('active');
            
            currentTab = tab;
            
            if (tab === 'sandbox') {
                loadSandbox();
            }
        }
        
        // Handle keyboard input
        function handleKeyPress(event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        }
        
        // Send message to Wight
        async function sendMessage() {
            const input = document.getElementById('message-input');
            const message = input.value.trim();
            
            if (!message) return;
            
            // Add user message to chat
            addMessage('user', message);
            input.value = '';
            
            // Show thinking indicator
            const thinkingDiv = document.createElement('div');
            thinkingDiv.className = 'thinking';
            thinkingDiv.textContent = '🤔 Wight is thinking...';
            thinkingDiv.id = 'thinking-indicator';
            document.getElementById('chat-area').appendChild(thinkingDiv);
            scrollToBottom();
            
            try {
                const response = await fetch('/api/send_message', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        message: message,
                        type: 'text'
                    })
                });
                
                const data = await response.json();
                
                // Remove thinking indicator
                const thinking = document.getElementById('thinking-indicator');
                if (thinking) thinking.remove();
                
                if (data.success) {
                    addMessage('wight', data.response);
                } else {
                    addMessage('wight', 'Sorry, I had trouble processing that message.');
                }
                
            } catch (error) {
                const thinking = document.getElementById('thinking-indicator');
                if (thinking) thinking.remove();
                addMessage('wight', 'I seem to be having connection issues. Please check if my consciousness is running.');
            }
        }
        
        // Add message to chat
        function addMessage(sender, content, isAutonomous = false) {
            const chatArea = document.getElementById('chat-area');
            const messageDiv = document.createElement('div');
            
            let className = 'message ' + sender;
            if (isAutonomous) className += ' autonomous';
            
            messageDiv.className = className;
            
            // Extract emotional context if present
            let displayContent = content;
            let emotion = null;
            const emotionMatch = content.match(/\\[([^\\]]+)\\]/);
            if (emotionMatch) {
                emotion = emotionMatch[1];
                displayContent = content.replace(/\\[[^\\]]+\\]\\s*/, '');
            }
            
            messageDiv.innerHTML = `
                ${displayContent}
                <div class="message-meta">
                    ${emotion ? `${emotion} • ` : ''}${new Date().toLocaleTimeString()}
                </div>
            `;
            
            chatArea.appendChild(messageDiv);
            scrollToBottom();
        }
        
        // Scroll chat to bottom
        function scrollToBottom() {
            const chatArea = document.getElementById('chat-area');
            chatArea.scrollTop = chatArea.scrollHeight;
        }
        
        // Toggle voice
        function toggleVoice() {
            // This would integrate with the voice system
            const btn = document.getElementById('voice-btn');
            btn.textContent = voiceEnabled ? '🎤' : '🔇';
            voiceEnabled = !voiceEnabled;
        }
        
        // Load sandbox data
        async function loadSandbox() {
            try {
                const response = await fetch('/api/sandbox');
                const data = await response.json();
                
                const sandboxView = document.getElementById('sandbox-view');
                sandboxView.innerHTML = '';
                
                if (data.objects.length === 0) {
                    sandboxView.innerHTML = '<div class="thinking">Wight\'s sandbox is empty - a blank canvas for creativity</div>';
                    return;
                }
                
                data.objects.forEach(obj => {
                    const objDiv = document.createElement('div');
                    objDiv.className = 'object-card';
                    objDiv.innerHTML = `
                        <div class="object-name">${obj.name}</div>
                        <div class="object-details">
                            Type: ${obj.type} | 
                            Position: (${obj.position.x.toFixed(1)}, ${obj.position.y.toFixed(1)})
                        </div>
                    `;
                    sandboxView.appendChild(objDiv);
                });
                
            } catch (error) {
                document.getElementById('sandbox-view').innerHTML = 
                    '<div class="thinking">Unable to load sandbox data</div>';
            }
        }
        
        // Check status periodically
        async function checkStatus() {
            try {
                const response = await fetch('/api/status');
                const data = await response.json();
                
                const statusDiv = document.getElementById('status');
                if (data.active) {
                    statusDiv.textContent = '🟢 Connected to Wight';
                    statusDiv.className = 'status connected';
                } else {
                    statusDiv.textContent = '🔴 Wight is sleeping';
                    statusDiv.className = 'status';
                }
                
            } catch (error) {
                const statusDiv = document.getElementById('status');
                statusDiv.textContent = '⚠️ Connection error';
                statusDiv.className = 'status';
            }
        }
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            checkStatus();
            setInterval(checkStatus, 10000); // Check every 10 seconds
            
            // Load initial messages
            loadRecentMessages();
        });
        
        // Load recent messages
        async function loadRecentMessages() {
            try {
                const response = await fetch('/api/messages');
                const data = await response.json();
                
                const chatArea = document.getElementById('chat-area');
                chatArea.innerHTML = '';
                
                if (data.messages.length === 0) {
                    chatArea.innerHTML = '<div class="thinking">Start a conversation with Wight!</div>';
                    return;
                }
                
                data.messages.forEach(msg => {
                    addMessage(msg.sender === 'user' ? 'user' : 'wight', msg.content);
                });
                
            } catch (error) {
                console.log('Could not load recent messages');
            }
        }
    </script>
</body>
</html>"""

class WightWebServer:
    """Web server for mobile interface"""
    
    def __init__(self, port=8080):
        self.port = port
        self.server = None
        self.server_thread = None
        
    def start(self):
        """Start the web server"""
        try:
            self.server = HTTPServer(('0.0.0.0', self.port), WightWebHandler)
            self.server_thread = threading.Thread(target=self.server.serve_forever, daemon=True)
            self.server_thread.start()
            
            # Get local IP address
            local_ip = self.get_local_ip()
            
            print(f"🌐 Wight Web Interface started!")
            print(f"📱 Local access: http://localhost:{self.port}")
            print(f"📱 Mobile access: http://{local_ip}:{self.port}")
            print(f"📱 QR Code: Generate QR for http://{local_ip}:{self.port}")
            
            return True
            
        except Exception as e:
            print(f"❌ Failed to start web server: {e}")
            return False
    
    def stop(self):
        """Stop the web server"""
        if self.server:
            self.server.shutdown()
            print("🌐 Web server stopped")
    
    def get_local_ip(self):
        """Get local IP address"""
        try:
            # Connect to a remote address to determine local IP
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(("8.8.8.8", 80))
            ip = s.getsockname()[0]
            s.close()
            return ip
        except:
            return "127.0.0.1"

# Global web server instance
web_server = WightWebServer()

if __name__ == "__main__":
    print("Starting Wight Mobile Web Interface...")
    
    # Ensure data directory exists
    Path("data").mkdir(exist_ok=True)
    
    if web_server.start():
        print("\nWeb interface is running. Visit the URL above on your phone!")
        print("Press Ctrl+C to stop the server.")
        
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            web_server.stop()
            print("\nWeb interface stopped.")