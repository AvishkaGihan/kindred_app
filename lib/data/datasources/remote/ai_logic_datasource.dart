import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class AILogicDatasource {
  final aiBackend = FirebaseAI.googleAI();
  late final GenerativeModel model;

  AILogicDatasource() {
    model = aiBackend.generativeModel(
      model: 'gemini-2.5-flash',
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
  }

  // Real-time streaming conversation with AI
  Stream<String> chatWithAI(String userMessage) async* {
    try {
      await FirebaseAppCheck.instance.activate();
      final stream = model.generateContentStream([Content.text(userMessage)]);
      await for (final chunk in stream) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (error) {
      yield "Sorry, I'm having trouble connecting right now. Please try again.";
    }
  }

  Future<String> getAIResponse(String prompt) async {
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? "I don't have a response right now.";
    } catch (error) {
      return "Sorry, I'm unavailable at the moment.";
    }
  }
}
