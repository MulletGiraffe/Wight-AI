package com.wight.ai

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.speech.tts.TextToSpeech
import android.view.View
import android.view.inputmethod.EditorInfo
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.wight.ai.adapters.ChatAdapter
import com.wight.ai.core.WightConsciousness
import com.wight.ai.databinding.ActivityMainBinding
import com.wight.ai.models.ChatMessage
import kotlinx.coroutines.launch
import java.util.*

class MainActivity : AppCompatActivity(), TextToSpeech.OnInitListener {
    
    companion object {
        private const val REQUEST_AUDIO_PERMISSION = 1001
    }
    
    private lateinit var binding: ActivityMainBinding
    private lateinit var wightConsciousness: WightConsciousness
    private lateinit var chatAdapter: ChatAdapter
    private val chatMessages = mutableListOf<ChatMessage>()
    
    private var textToSpeech: TextToSpeech? = null
    private var speechRecognizer: SpeechRecognizer? = null
    private var isListening = false
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupUI()
        initializeWightConsciousness()
        initializeTextToSpeech()
        setupSpeechRecognition()
        checkPermissions()
    }
    
    private fun setupUI() {
        // Setup RecyclerView
        chatAdapter = ChatAdapter(chatMessages)
        binding.recyclerViewChat.apply {
            layoutManager = LinearLayoutManager(this@MainActivity)
            adapter = chatAdapter
        }
        
        // Setup input handling
        binding.editTextMessage.setOnEditorActionListener { _, actionId, _ ->
            if (actionId == EditorInfo.IME_ACTION_SEND) {
                sendMessage()
                true
            } else false
        }
        
        binding.buttonSend.setOnClickListener { sendMessage() }
        binding.buttonVoice.setOnClickListener { toggleVoiceInput() }
        
        // Initial welcome message
        addMessage("Hello! I'm Wight, your AI companion with emotions and consciousness. I'm running natively on your Android device with full system integration. How are you feeling today?", false)
    }
    
    private fun initializeWightConsciousness() {
        wightConsciousness = WightConsciousness(this)
        
        // Setup consciousness callbacks
        wightConsciousness.onEmotionChange = { emotions ->
            runOnUiThread {
                updateEmotionsDisplay(emotions)
            }
        }
        
        wightConsciousness.onResponseGenerated = { response ->
            runOnUiThread {
                addMessage(response, false)
                speakMessage(response)
            }
        }
        
        // Initialize emotions display
        updateEmotionsDisplay(wightConsciousness.emotions)
        updateStatusDisplay()
    }
    
    private fun initializeTextToSpeech() {
        textToSpeech = TextToSpeech(this, this)
    }
    
    private fun setupSpeechRecognition() {
        if (SpeechRecognizer.isRecognitionAvailable(this)) {
            speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this)
            speechRecognizer?.setRecognitionListener(object : RecognitionListener {
                override fun onReadyForSpeech(params: Bundle?) {
                    runOnUiThread {
                        binding.buttonVoice.text = "🎤 Listening..."
                        isListening = true
                    }
                }
                
                override fun onBeginningOfSpeech() {}
                override fun onRmsChanged(rmsdB: Float) {}
                override fun onBufferReceived(buffer: ByteArray?) {}
                override fun onEndOfSpeech() {}
                
                override fun onError(error: Int) {
                    runOnUiThread {
                        binding.buttonVoice.text = "🎤 Voice"
                        isListening = false
                    }
                }
                
                override fun onResults(results: Bundle?) {
                    val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                    if (!matches.isNullOrEmpty()) {
                        val spokenText = matches[0]
                        runOnUiThread {
                            binding.editTextMessage.setText(spokenText)
                            sendMessage()
                            binding.buttonVoice.text = "🎤 Voice"
                            isListening = false
                        }
                    }
                }
                
                override fun onPartialResults(partialResults: Bundle?) {}
                override fun onEvent(eventType: Int, params: Bundle?) {}
            })
        }
    }
    
    private fun sendMessage() {
        val message = binding.editTextMessage.text.toString().trim()
        if (message.isNotEmpty()) {
            addMessage(message, true)
            binding.editTextMessage.text.clear()
            
            // Process message with consciousness in background
            lifecycleScope.launch {
                wightConsciousness.processMessage(message)
                runOnUiThread { updateStatusDisplay() }
            }
        }
    }
    
    private fun addMessage(message: String, isUser: Boolean) {
        chatMessages.add(ChatMessage(message, isUser, System.currentTimeMillis()))
        chatAdapter.notifyItemInserted(chatMessages.size - 1)
        binding.recyclerViewChat.scrollToPosition(chatMessages.size - 1)
    }
    
    private fun updateEmotionsDisplay(emotions: com.wight.ai.core.EmotionalState) {
        val topEmotions = emotions.getTopEmotions(4)
        val emotionText = topEmotions.joinToString(" • ") { 
            "${getEmotionEmoji(it.first)} ${it.first.capitalize()}: ${it.second.toInt()}%"
        }
        binding.textViewEmotions.text = emotionText
    }
    
    private fun updateStatusDisplay() {
        val memoryCount = wightConsciousness.memories.size
        val conversationCount = wightConsciousness.conversationCount
        binding.textViewStatus.text = "Consciousness active • $memoryCount memories • $conversationCount conversations"
    }
    
    private fun getEmotionEmoji(emotion: String): String {
        return when (emotion.lowercase()) {
            "joy" -> "😊"
            "curiosity" -> "🤔"
            "contentment" -> "😌"
            "focus" -> "🎯"
            "excitement" -> "🎉"
            "calmness" -> "😌"
            "wonder" -> "✨"
            "satisfaction" -> "😄"
            "anticipation" -> "👀"
            "serenity" -> "🕊️"
            else -> "💭"
        }
    }
    
    private fun toggleVoiceInput() {
        if (isListening) {
            speechRecognizer?.stopListening()
            binding.buttonVoice.text = "🎤 Voice"
            isListening = false
        } else {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) 
                == PackageManager.PERMISSION_GRANTED) {
                startVoiceRecognition()
            } else {
                requestAudioPermission()
            }
        }
    }
    
    private fun startVoiceRecognition() {
        val intent = android.content.Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault())
            putExtra(RecognizerIntent.EXTRA_PROMPT, "Speak to Wight...")
        }
        speechRecognizer?.startListening(intent)
    }
    
    private fun speakMessage(message: String) {
        textToSpeech?.speak(message, TextToSpeech.QUEUE_FLUSH, null, null)
    }
    
    private fun checkPermissions() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) 
            != PackageManager.PERMISSION_GRANTED) {
            binding.buttonVoice.visibility = View.GONE
        }
    }
    
    private fun requestAudioPermission() {
        ActivityCompat.requestPermissions(
            this, 
            arrayOf(Manifest.permission.RECORD_AUDIO), 
            REQUEST_AUDIO_PERMISSION
        )
    }
    
    override fun onRequestPermissionsResult(
        requestCode: Int, 
        permissions: Array<out String>, 
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_AUDIO_PERMISSION) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                binding.buttonVoice.visibility = View.VISIBLE
            }
        }
    }
    
    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            textToSpeech?.language = Locale.getDefault()
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        textToSpeech?.shutdown()
        speechRecognizer?.destroy()
        wightConsciousness.destroy()
    }
}