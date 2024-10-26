import 'package:charla_vertex_gemini/features/create_commit_use_case.dart';
import 'package:charla_vertex_gemini/presentation/widget/form_alert.dart';
import 'package:flutter/material.dart';

class CommitCreaterPage extends StatefulWidget {
  final CreateCommitUseCase createCommitUseCase;
  const CommitCreaterPage({super.key, required this.createCommitUseCase});

  @override
  State<CommitCreaterPage> createState() => _CommitCreaterPageState();
}

class _CommitCreaterPageState extends State<CommitCreaterPage> {
  String promptCodeChanges = '';
  String promptDescription =
      'La aplicación trata de generar mensajes de commits utilizando inteligencia artificial, siguiendo un formato estándar de la industria. ';

  String textIAResponse = '';

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF312E81),
        title: const Text('Generador de commits',
            style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const Text(
            'Descripciòn del Proyecto',
            style: TextStyle(
                color: Color(0xFF312E81), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(promptDescription),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  side: const BorderSide(color: Color(0xFF312E81)),
                ),
                onPressed: () async {
                  final description = await FormAlert.show(context);

                  if (description == null) return;

                  promptDescription = description;
                  setState(() {});
                },
                child: const Text(
                  'Editar',
                  style: TextStyle(
                      color: Color(0xFF312E81), fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : DataView(
                  onChangeInput: (value) => promptCodeChanges = value,
                  textIAResponse: textIAResponse,
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isLoading) return;

          setState(() {
            isLoading = true;
          });

          final response = await widget.createCommitUseCase.execute(
              promptCodeChanges: promptCodeChanges,
              promptDescription: promptDescription);

          setState(() {
            textIAResponse = response.toString();
            isLoading = false;
          });
        },
        child: const Icon(Icons.add),
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
      child: Column(
        children: [
          TextField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            decoration: const InputDecoration(
              hintText: 'Agrega los cambios del git diff...',
              border: OutlineInputBorder(),
            ),
            maxLines: 15,
            onChanged: onChangeInput,
          ),
          const SizedBox(height: 16),
          SelectableText(textIAResponse),
        ],
      ),
    );
  }
}
