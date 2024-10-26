import 'dart:convert';

import 'package:charla_vertex_gemini/presentation/widget/scaffold_tecylab.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:json_view/json_view.dart';

enum TypeView { html, markdown, json, textPlain }

final typeGeneration = ['resumen', 'análisis', 'poesía'];

final dataHistory = [
  'Historia peruana',
  'Revolución francesa',
  'Historia de la computación',
  'Segunda guerra mundial'
];

class OptionsGeneratorPage extends StatefulWidget {
  const OptionsGeneratorPage({super.key});

  @override
  State<OptionsGeneratorPage> createState() => _OptionsGeneratorPageState();
}

class _OptionsGeneratorPageState extends State<OptionsGeneratorPage> {
  final model =
      FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');

  TypeView? tapViewSelected;
  String? tapGenerationSelected;
  String? tapHistorySelected;

  String textIAResponse = '';

  bool isLoading = false;

  bool get canGenerate =>
      tapViewSelected != null &&
      tapGenerationSelected != null &&
      tapHistorySelected != null;

  @override
  Widget build(BuildContext context) {
    return ScaffoldTecylab(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selecciona el tipo de generación'),
            const HeightSpacer(),
            SelectedGroupType(
              onSelected: (value) {
                setState(() => tapGenerationSelected = value);
              },
              valueSelected: tapGenerationSelected,
            ),
            const HeightSpacer(),
            const Text('Selecciona la historia'),
            const HeightSpacer(),
            SelectedGroupHistory(
              onSelected: (value) {
                setState(() => tapHistorySelected = value);
              },
              valueSelected: tapHistorySelected,
            ),
            const HeightSpacer(),
            const Text('Selecciona el tipo de vista'),
            const HeightSpacer(),
            SelectedGroupFormato(
              onSelected: (value) {
                textIAResponse = '';
                setState(() => tapViewSelected = value);
              },
              valueSelected: tapViewSelected,
            ),
            const HeightSpacer(),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: onGenerate,
                    child: const Text('Generar'),
                  ),
            const HeightSpacer(),
            if (textIAResponse.isNotEmpty)
              switch (tapViewSelected) {
                TypeView.html =>
                  Markdown(shrinkWrap: true, data: textIAResponse),
                TypeView.markdown =>
                  Markdown(shrinkWrap: true, data: textIAResponse),
                TypeView.json =>
                  JsonView(json: mapJsonFormat(), shrinkWrap: true),
                TypeView.textPlain => Text(textIAResponse),
                null => const SizedBox(),
              }
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> mapJsonFormat() {
    try {
      final data = jsonDecode(textIAResponse
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim());
      return data;
    } catch (_) {
      return {"error": "No se pudo parsear el JSON"};
    }
  }

  void onGenerate() async {
    if (!canGenerate) return _showSnackBarForm();

    if (isLoading) return;

    setState(() => isLoading = true);

    final promptText =
        'Genera un $tapGenerationSelected sobre $tapHistorySelected en formato $tapViewSelected, no agregues contenido extra fuera del formato';

    final response = await model.generateContent([Content.text(promptText)]);

    setState(() {
      textIAResponse = response.text.toString();
      isLoading = false;
    });
  }

  void _showSnackBarForm() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar todos los campos')));
  }
}

class SelectedGroupType extends StatelessWidget {
  final ValueChanged<String> onSelected;
  final String? valueSelected;
  const SelectedGroupType(
      {super.key, required this.onSelected, required this.valueSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: typeGeneration
          .map((typeGeneration) => SelectedTab(
                onSelected: onSelected,
                value: typeGeneration,
                isSelected: valueSelected == typeGeneration,
              ))
          .toList(),
    );
  }
}

class SelectedGroupHistory extends StatelessWidget {
  final ValueChanged<String> onSelected;
  final String? valueSelected;
  const SelectedGroupHistory(
      {super.key, required this.onSelected, required this.valueSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: dataHistory
          .map((typeGeneration) => SelectedTab(
                onSelected: onSelected,
                value: typeGeneration,
                isSelected: valueSelected == typeGeneration,
              ))
          .toList(),
    );
  }
}

class SelectedGroupFormato extends StatelessWidget {
  final ValueChanged<TypeView> onSelected;
  final TypeView? valueSelected;
  const SelectedGroupFormato(
      {super.key, required this.onSelected, required this.valueSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: TypeView.values
          .map((typeGeneration) => SelectedTab(
                onSelected: onSelected,
                value: typeGeneration,
                isSelected: valueSelected == typeGeneration,
              ))
          .toList(),
    );
  }
}

class SelectedTab<S> extends StatelessWidget {
  final ValueChanged<S> onSelected;
  final S value;
  final bool isSelected;
  const SelectedTab({
    super.key,
    required this.onSelected,
    required this.value,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(value),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          value is TypeView ? (value as TypeView).name : value.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class HeightSpacer extends StatelessWidget {
  const HeightSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 16);
  }
}
