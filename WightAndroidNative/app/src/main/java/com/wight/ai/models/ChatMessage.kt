package com.wight.ai.models

data class ChatMessage(
    val content: String,
    val isUser: Boolean,
    val timestamp: Long
)