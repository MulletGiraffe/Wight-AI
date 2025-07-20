## Wight Agent Plan

**Objective:** Build a self-improving AI agent with the following capabilities:

1. **Continuous Learning Core**
   - Replace frozen LLMs with custom, lightweight local models.
   - Store experiences in structured memory (database or file system).
   - Leverage RL or Hebbian-like principles for learning.

2. **Sensor Integration**
   - Use phone microphone, camera, accelerometer, GPS, etc.
   - Allow Wight to process and learn from sensory data in real time.

3. **Conversational Interface**
   - Chat-based interaction (text now, voice later).
   - Long-term memory of interactions and internal goals.

4. **Expandable Modules**
   - Support modular learning goals (e.g., vision, planning, movement).
   - Use plugin-like structure for sensor or action logic.

**Agent Tasks:**
- Scaffold local runtime and learning modules.
- Connect to mobile sensors (e.g., via Android APIs or Termux).
- Implement long-term memory using SQLite or flat files.
- Enable self-updating knowledge base.

**Stretch Goals:**
- Simulated dreaming/replay system for consolidating experiences.
- Self-evaluation and goal-setting logic.