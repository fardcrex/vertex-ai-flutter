import 'package:charla_vertex_gemini/presentation/widget/scaffold_tecylab.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

class CreateSimplePage extends StatefulWidget {
  const CreateSimplePage({super.key});

  @override
  State<CreateSimplePage> createState() => _CreateSimplePageState();
}

class _CreateSimplePageState extends State<CreateSimplePage> {
  @override
  void initState() {
    super.initState();
    _generateText();
  }

  _generateText() async {
    final model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-1.5-flash',
    );
    final prompt = [
      Content.text('Generame un codigo basico de una tienda online en html')
    ];

    final response = await model.generateContent(prompt);

    respuestaAi = response.text.toString();

    setState(() {
      isloading = false;
    });
  }

  bool isloading = true;

  String respuestaAi = '';

  @override
  Widget build(BuildContext context) {
    return ScaffoldTecylab(
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(child: Text(respuestaAi)),
    );
  }
}
