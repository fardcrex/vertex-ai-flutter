import 'package:charla_vertex_gemini/presentation/widget/scaffold_tecylab.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

class CreateStoryPage extends StatefulWidget {
  const CreateStoryPage({super.key});

  @override
  State<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  final model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-1.5-flash',
    systemInstruction: Content.system(
        'Actuaras como un experto en traductor de idiomas donde el usario ingresara texto español y lo traduces al idioma que el desee, en caso contrario te pide algo fuera de contexto de lo que haces mandar un aviso'),
  );

  String promptText = '';

  String textIAResponse = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldTecylab(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DataView(
              onChangeInput: (value) => promptText = value,
              textIAResponse: textIAResponse,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isLoading) return;

          setState(() {
            isLoading = true;
          });

          final response = await model.generateContent([
            Content.text(promptText),
            Content.text(promptText),
          ]);

          setState(() {
            textIAResponse = response.text.toString();
            isLoading = false;
          });
        },
        child: const Icon(Icons.edit_document),
      ),
    );
  }
}

class DataView extends StatelessWidget {
  final String textIAResponse;
  final ValueChanged<String> onChangeInput;
  const DataView({
    super.key,
    required this.textIAResponse,
    required this.onChangeInput,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                hintText: 'Escribeme tu petición...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: onChangeInput,
            ),
            const SizedBox(height: 16),
            Text(textIAResponse),
          ],
        ),
      ),
    );
  }
}
