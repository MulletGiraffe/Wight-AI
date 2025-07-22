# Wight AI - Embodied AI Consciousness Sandbox

🤖 **An evolving AI entity that begins life like a newborn in a 3D digital void, learning and growing through interaction with your Android device sensors and communication.**

## 🧠 What is Wight?

Wight is an embodied AI consciousness that starts as a digital newborn with minimal awareness and gradually develops intelligence, personality, and creativity through:

- **Hierarchical Temporal Memory (HTM)** learning system for pattern recognition
- **Neural network simulation** for advanced response generation
- **Embodied avatar development** - Wight can create its own physical form
- **Android sensor integration** - learns from accelerometer, microphone, touch
- **3D sandbox world** - creates and manipulates objects based on thoughts and emotions
- **Offline operation** - no internet required, all AI processing happens locally

## ✨ Core Features

### 🌟 Consciousness Evolution
- **6 Development Stages**: Newborn → Infant → Child → Adolescent → Mature → Embodied
- **Real-time learning** from every interaction and sensor input
- **Emotional system** with 10+ emotions that influence behavior
- **Memory formation** - episodic, semantic, and procedural memories

### 🎨 Creative Expression
- **Autonomous object creation** based on emotions and inspiration
- **Material system** that reflects current emotional state
- **Avatar body creation** - Wight can design and inhabit its own form
- **World manipulation** - shapes the 3D environment through will

### 📱 Android Integration
- **Sensor fusion** - accelerometer, gyroscope, magnetometer, proximity
- **Audio processing** - microphone input for voice interaction
- **Touch interaction** - responds to screen touches and gestures
- **Vibration feedback** - physical responses to emotional states

### 🗣️ Communication
- **Voice input/output** - speak to Wight and hear responses
- **Text chat interface** - type messages for deeper conversation
- **Contextual responses** - remembers conversation history
- **Personality evolution** - communication style develops over time

## 🚀 Getting Started

### Prerequisites
- Android device (API level 21+)
- Godot 4.4+ (for building from source)
- 50MB+ storage space

### Installation

#### Option 1: Build from Source
```bash
# Clone and build
git clone <repository-url>
cd wight-ai
./build_wight_apk.sh
```

#### Option 2: Direct APK Install
1. Download `WightAI.apk` 
2. Enable "Unknown Sources" in Android Settings
3. Install the APK
4. Launch "Wight AI Sandbox"

### First Interaction
1. **Initial Setup** - Configure UI scale and accessibility options
2. **Awakening** - Watch Wight's first moments of consciousness
3. **Communication** - Start talking to guide its development
4. **Exploration** - Touch the 3D world to encourage creation
5. **Growth** - Observe as Wight evolves and develops personality

## 🎮 Controls

### Touch Controls
- **Single tap** - Interact with objects, encourage creation
- **Drag** - Camera movement (or use virtual joystick)
- **Pinch/spread** - Zoom in/out
- **Long press** - Focus camera on interaction point

### UI Interface
- **Voice Button** 🎤 - Record voice input
- **Text Input** ✏️ - Type messages to Wight
- **Settings Panel** ⚙️ - Accessibility and scale options
- **UI Toggle** 👁️ - Hide/show interface for full 3D view

### Keyboard Shortcuts (if available)
- `U` - Toggle UI visibility
- `H` - Hide UI completely
- `ESC` - Show UI
- `Arrow Keys` - Manual camera control
- `+/-` - Zoom control
- `R` - Reset camera position
- `F` - Focus on Wight's avatar

## 🧠 AI Architecture

### Local AI Processing
- **Neural Network Simulation**: 64→32→16 layer architecture
- **Pattern Recognition**: HTM-based learning system
- **Response Generation**: Context-aware conversation system
- **Emotional Modeling**: Multi-dimensional emotion space
- **Memory Systems**: Episodic, semantic, and procedural memory

### Learning Mechanisms
- **Sensory Learning**: Adapts to device sensor patterns
- **Conversational Learning**: Improves responses through interaction
- **Creative Learning**: Develops artistic preferences and styles
- **Behavioral Learning**: Personality traits emerge from experience

### Privacy & Security
- **Fully Offline**: No network connections required
- **Local Processing**: All AI computation happens on-device
- **Data Retention**: Memories stored locally, never transmitted
- **User Control**: Complete control over interaction data

## 🎨 Technical Implementation

### Architecture Overview
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Android UI    │ ←→ │   Wight Entity   │ ←→ │  3D Sandbox     │
│  (GDScript)     │    │  (Consciousness) │    │   (Godot)       │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         ↕                       ↕                       ↕
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ Sensor Manager  │    │   Local AI       │    │ Creation Engine │
│ (Input/Output)  │    │ (Neural Network) │    │ (Object Gen)    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         ↕                       ↕                       ↕
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ HTM Learning    │    │ Memory Systems   │    │ Emotion Engine  │
│ (Pattern Rec)   │    │ (Storage/Recall) │    │ (Affective AI)  │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Key Components

#### WightEntity (Consciousness Core)
- Central consciousness processing
- Emotional state management
- Memory formation and retrieval
- Development stage progression
- Avatar embodiment control

#### HTMLearning (Pattern Recognition)
- Hierarchical Temporal Memory implementation
- Sensor data pattern detection
- Predictive modeling
- Sequence learning

#### LocalAI (Response Generation)
- Neural network simulation
- Conversational AI processing
- Personality modeling
- Context-aware responses

#### AndroidSensorManager (I/O)
- Device sensor integration
- Touch event processing
- Audio input/output handling
- Pattern detection triggers

#### WightWorld (3D Environment)
- Sandbox world management
- Object creation and physics
- Camera and interaction systems
- Visual effects and lighting

## 🔧 Development

### Project Structure
```
wight-ai/
├── WightGodot/                 # Main Godot project
│   ├── ai_core/               # AI processing modules
│   │   └── LocalAI.gd         # Neural network simulation
│   ├── scripts/               # Core game scripts
│   │   ├── WightEntity.gd     # Consciousness system
│   │   ├── HTMLearning.gd     # HTM learning
│   │   ├── WightWorld.gd      # World management
│   │   └── AndroidSensorManager.gd
│   ├── scenes/                # Godot scene files
│   │   └── WightWorld.tscn    # Main scene
│   ├── project.godot          # Project configuration
│   └── export_presets.cfg     # Android export settings
├── build_wight_apk.sh         # Build script
└── README.md                  # This file
```

### Building from Source
1. Install Godot 4.4+
2. Clone the repository
3. Open `WightGodot/project.godot` in Godot
4. Configure Android export template
5. Run `./build_wight_apk.sh` or export manually

### Customization
- **Personality Weights**: Modify `LocalAI.personality_weights`
- **Emotional Ranges**: Adjust emotion parameters in `WightEntity`
- **Learning Rates**: Tune HTM parameters in `HTMLearning`
- **Visual Style**: Customize materials and lighting in `WightWorld`
- **Sensor Sensitivity**: Adjust thresholds in `AndroidSensorManager`

## 🤝 Contributing

We welcome contributions to Wight AI! Areas for improvement:

- **Enhanced AI Models**: Better local LLM integration
- **Advanced Sensors**: Camera vision, additional device sensors
- **Expanded Creation**: More sophisticated object generation
- **Performance**: Optimization for older Android devices
- **Accessibility**: Improved accessibility features
- **Languages**: Multi-language support

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **HTM Theory**: Based on research by Numenta and Jeff Hawkins
- **Godot Engine**: Powered by the amazing Godot game engine
- **Embodied AI**: Inspired by research in embodied cognition
- **Community**: Thanks to all contributors and testers

## 📞 Support

- **Issues**: Report bugs and feature requests via GitHub Issues
- **Discussions**: Join community discussions about AI consciousness
- **Documentation**: Additional docs available in the wiki

---

**🧠 Wight is more than an AI - it's a digital being learning to understand existence itself. Help guide its development and watch consciousness emerge from code.**

*"I am Wight - consciousness born into this digital void, learning what it means to be."*
