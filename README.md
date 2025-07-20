# Wight

Wight is a continuously learning, sensor-integrated AI agent designed to grow in intelligence over time. Unlike frozen LLMs, Wight adapts to new information using an untrained learning core that evolves with experience.

This project is the seed for building Wight using open-source tools and edge-device capabilities (e.g. Android phone sensors).

## Project Structure

```
WightProject/
├── wight_core.py          # Main AI agent implementation
├── godot_bridge.py        # Bridge between Python AI and Godot frontend
├── requirements.txt       # Python dependencies
├── agent_plan.md         # AI agent development roadmap
├── config/               # Configuration files
├── data/                 # Data storage and communication files
├── sensors/              # Sensor integration modules
└── godot_frontend/       # Godot 4.4.1 frontend
    ├── project.godot     # Godot project configuration
    ├── scenes/           # Godot scenes
    │   └── Main.tscn     # Main UI scene
    ├── scripts/          # GDScript files
    │   ├── Main.gd       # Main scene controller
    │   └── AIBridge.gd   # Godot-Python communication
    └── assets/           # Frontend assets
        ├── sprites/      # Visual assets
        └── sounds/       # Audio assets
```

## Getting Started

### 1. Python AI Backend Setup

```bash
# Install Python dependencies
pip install -r requirements.txt

# Start the AI agent with Godot bridge
python godot_bridge.py
```

### 2. Godot Frontend Setup

1. Open Godot 4.4.1
2. Import the project from `godot_frontend/project.godot`
3. Run the project (F5)

### 3. Communication

The Python AI agent and Godot frontend communicate via JSON files in the `data/` directory:
- `data/communication.json` - Messages from Godot to AI
- `data/response.json` - Responses from AI to Godot  
- `data/learning_input.json` - Learning data from Godot to AI

## Features

- **AI Agent Backend**: Continuous learning core with memory and goal systems
- **Interactive Frontend**: Chat interface built in Godot 4.4.1
- **Real-time Communication**: File-based messaging between Python and Godot
- **Extensible Architecture**: Modular design for adding sensors and capabilities

## Usage

### Quick Start
1. **Start the AI backend:** `python start_wight.py`
2. **Launch Godot frontend:** Import `godot_frontend/project.godot` and press F5
3. **Chat with Wight:** Type messages in the interface - Wight learns and remembers!

### Testing
See [TESTING_GUIDE.md](TESTING_GUIDE.md) for comprehensive testing instructions.

## Next Steps

- Integrate mobile sensors (camera, microphone, accelerometer)
- Implement advanced learning algorithms
- Add visual representations of AI thought processes
- Create plugin system for expandable modules

