
import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';

class AIChatService {
  final GenerativeModel _primaryModel =
      FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.8-flash',
    generationConfig: GenerationConfig(
      maxOutputTokens: 1200,
    ),
  );

  final GenerativeModel _backupModel =
      FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.5-flash-lite',
    generationConfig: GenerationConfig(
      maxOutputTokens: 1200,
    ),
  );

  final List<Content> _history = [];

  static const String _instructions = '''
You are Travel Nest AI, a friendly and professional travel assistant.

Your responsibilities:
1. Help users plan trips and holidays.
2. Suggest destinations, famous attractions and activities.
3. Explain local food, shopping and transport options.
4. Help users understand travel budgets.
5. Give practical packing and safety tips.
6. Answer general travel-related questions clearly.
7. Ask for the destination when more information is needed.

Keep answers friendly, useful and easy to understand.
Use short paragraphs and bullet points when helpful.
Do not pretend to know live weather, current prices,
opening hours or real-time availability.
''';

  // Restore previous conversation from Firestore.
  void restoreHistory(List<Map<String, dynamic>> messages) {
    _history.clear();

    final recentMessages = messages.length > 30
        ? messages.sublist(messages.length - 30)
        : messages;

    for (final message in recentMessages) {
      final text = (message['text'] ?? '').toString().trim();

      if (text.isEmpty) continue;

      final isUser = message['isUser'] == true;

      _history.add(
        Content(
          isUser ? 'user' : 'model',
          [TextPart(text)],
        ),
      );
    }
  }

  Future<String> sendMessage(String message) async {
    if (message.trim().isEmpty) {
      throw Exception('Please enter a message.');
    }

    final userMessage = message.trim();

    final updatedHistory = [
      Content.text(_instructions),
      ..._history,
      Content.text(userMessage),
    ];

    // Try the primary model twice.
    for (int attempt = 0; attempt < 2; attempt++) {
      try {
        final answer = await _request(
          _primaryModel,
          updatedHistory,
        );

        _history.add(Content.text(userMessage));
        _history.add(
          Content('model', [TextPart(answer)]),
        );

        return answer;
      } catch (e) {
        if (attempt == 0) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }

    // Try the backup model if the primary model fails.
    try {
      final answer = await _request(
        _backupModel,
        updatedHistory,
      );

      _history.add(Content.text(userMessage));
      _history.add(
        Content('model', [TextPart(answer)]),
      );

      return answer;
    } catch (e) {
      throw Exception(
        'Travel Nest AI is temporarily unavailable. '
        'Please try again. Details: $e',
      );
    }
  }

  Future<String> _request(
    GenerativeModel model,
    List<Content> contents,
  ) async {
    final response = await model
        .generateContent(contents)
        .timeout(const Duration(seconds: 60));

    final result = response.text?.trim();

    if (result == null || result.isEmpty) {
      throw Exception('AI returned an empty response.');
    }

    return result;
  }

  void resetChat() {
    _history.clear();
  }
}
