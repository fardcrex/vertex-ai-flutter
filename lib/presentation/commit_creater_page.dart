import 'package:charla_vertex_gemini/features/create_commit_use_case.dart';
import 'package:flutter/material.dart';

class CommitCreaterPage extends StatefulWidget {
  final CreateCommitUseCase createCommitUseCase;
  const CommitCreaterPage({super.key, required this.createCommitUseCase});

  @override
  State<CommitCreaterPage> createState() => _CommitCreaterPageState();
}

class _CommitCreaterPageState extends State<CommitCreaterPage> {
  String promptText = '';

  String textIAResponse = '';

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF312E81),
        title: const Text('Generador de texto',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
