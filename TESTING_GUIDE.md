# Wight AI Agent Testing Guide

This guide provides step-by-step instructions for testing the complete Wight AI + Godot integration.

## Prerequisites

1. **Python 3.7+** with required packages:
   ```bash
   pip install -r requirements.txt
   ```

2. **Godot 4.4.1** installed and available

## Testing Procedure

### Step 1: Start the Python Backend

1. Open a terminal in the project root directory
2. Run the startup script:
   ```bash
   python start_wight.py
   ```

**Expected Output:**
```
==================================================
🤖 WIGHT AI AGENT STARTUP
==================================================
✓ Python dependencies found
✓ Godot project found
✓ Data directory ready

📋 STARTUP INSTRUCTIONS:
1. Keep this terminal open (AI backend)
2. Open Godot 4.4.1
3. Import project from: godot_frontend/project.godot
4. Press F5 to run the frontend
5. Start chatting with Wight!

🚀 Starting AI backend...
Press Ctrl+C to stop
--------------------------------------------------
Godot Bridge initialized - ready to serve Wight AI agent
📁 No previous memories found, starting fresh
Starting communication loop with Godot frontend...
Watching for input at: data/input.json
Writing responses to: data/output.json
```

### Step 2: Launch Godot Frontend

1. Open Godot 4.4.1
2. Click "Import"
3. Navigate to `godot_frontend/project.godot`
4. Click "Import & Edit"
5. Press **F5** to run the project

**Expected Behavior:**
- Window opens with dark blue background
- Title shows "Wight AI Agent Interface"
- Status shows "🔄 Initializing..." then "🟢 Connected"
- Chat area shows a welcome message
- Input box at the bottom is ready for typing

### Step 3: Test Basic Communication

#### Test 3.1: Simple Greeting
1. Type "Hello" in the input box
2. Press Enter or click Send

**Expected Result:**
- Your message appears on the right in a blue bubble
- Status briefly shows "🤔 Wight is thinking..."
- AI response appears on the left in a gray bubble
- AI should respond with a greeting and ask for your name

**Python Terminal Output:**
```
📥 Received message msg_1: Hello
📤 Sent response msg_1: Hello! I'm Wight, your AI companion...
💾 Saved 1 memories and 0 facts to data/memories.json
```

#### Test 3.2: Introduce Yourself
1. Type "My name is [YourName]"
2. Send the message

**Expected Result:**
- AI learns your name and mentions it in future conversations
- Memory count in bubble metadata increases

#### Test 3.3: Test Memory
1. Type "What do you know about me?"
2. Send the message

**Expected Result:**
- AI recalls your name and any other facts shared

### Step 4: Test Advanced Features

#### Test 4.1: Memory Persistence
1. Send a few messages to the AI
2. Close the Godot frontend
3. Stop the Python backend (Ctrl+C)
4. Restart both components
5. Ask "What do you remember about me?"

**Expected Result:**
- AI remembers previous conversations and facts
- Memory count continues from where it left off

#### Test 4.2: File Communication
1. While chatting, check the `data/` directory
2. You should see:
   - `memories.json` - Persistent AI memories
   - Temporary files `input.json` and `output.json` during communication

#### Test 4.3: Connection Status
1. Stop the Python backend while Godot is running
2. Try sending a message

**Expected Result:**
- Status changes to "🔴 Disconnected"
- Message times out after 10 seconds
- Error message appears in chat

## File Structure Verification

After testing, verify these files exist:

```
├── data/
│   └── memories.json          # AI persistent memory
├── godot_frontend/
│   ├── .godot/               # Godot cache (auto-generated)
│   ├── project.godot
│   ├── scenes/
│   │   ├── Main.tscn
│   │   └── MessageBubble.tscn
│   └── scripts/
│       ├── Main.gd
│       ├── AIBridge.gd
│       └── MessageBubble.gd
└── [Python files...]
```

## Troubleshooting

### Common Issues

#### 1. "AI Agent not responding"
- **Cause:** Python backend not running
- **Solution:** Start `python start_wight.py` first

#### 2. Import errors in Python
- **Cause:** Missing dependencies
- **Solution:** Run `pip install -r requirements.txt`

#### 3. Godot project won't import
- **Cause:** Wrong Godot version
- **Solution:** Use Godot 4.4.1 specifically

#### 4. Messages not appearing
- **Cause:** Scene tree structure mismatch
- **Solution:** Check that node paths in Main.gd match Main.tscn

#### 5. Memory not persisting
- **Cause:** File permissions or path issues
- **Solution:** Check that `data/` directory is writable

### Debug Logging

**Python Side:**
- All communication is logged with 📥/📤 emojis
- Memory operations logged with 💾 emoji
- Errors logged with ❌ emoji

**Godot Side:**
- Open "Remote" debugger tab in Godot editor
- Check console output for bridge messages
- Use `print()` statements for additional debugging

## Expected Test Results

### Successful Test Completion
- ✅ Python backend starts without errors
- ✅ Godot frontend connects and shows green status
- ✅ Messages send and receive correctly
- ✅ AI remembers information across sessions
- ✅ Chat bubbles display properly with timestamps
- ✅ Memory count increases with interactions
- ✅ Facts are learned and recalled correctly

### Performance Metrics
- **Message latency:** < 1 second for simple responses
- **Memory size:** Grows appropriately with interactions
- **File I/O:** No file conflicts or corruption
- **UI responsiveness:** Smooth scrolling and message display

## Next Steps After Testing

Once basic testing passes:
1. Test with longer conversations
2. Try different types of information sharing
3. Test edge cases (very long messages, special characters)
4. Experiment with multiple rapid messages
5. Test system recovery after crashes