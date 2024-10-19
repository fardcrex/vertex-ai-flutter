import 'package:firebase_vertexai/firebase_vertexai.dart';

class CreateCommitUseCase {
  final model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-1.5-flash',
    systemInstruction: Content.system(''),
  );

  Future<String> execute(String promptText) async {
    final response = await model.generateContent([Content.text(promptText)]);

    return response.text.toString();
  }
}
