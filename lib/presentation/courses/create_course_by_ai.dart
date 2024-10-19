import 'dart:convert';

import 'package:charla_vertex_gemini/const/vertex_system_instructions.dart';
import 'package:charla_vertex_gemini/presentation/courses/course_model.dart';
import 'package:charla_vertex_gemini/presentation/courses/widgets/course_card.dart';
import 'package:charla_vertex_gemini/presentation/widget/scaffold_tecylab.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

class CreateCourseByAi extends StatefulWidget {
  static MaterialPageRoute<List<CourseModel>> route() =>
      MaterialPageRoute<List<CourseModel>>(
        builder: (context) => const CreateCourseByAi(),
      );
  const CreateCourseByAi({super.key});

  @override
  State<CreateCourseByAi> createState() => _CreateCourseByAiState();
}

class _CreateCourseByAiState extends State<CreateCourseByAi> {
  final model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-1.5-flash',
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    systemInstruction: Content.system(createCourseInstruction),
  );

  String promptText = '';

  MessageAI messageAI = MessageAI(isSuccess: false, message: '');

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldTecylab(
      body: DataView(
        isLoading: isLoading,
        onChangeInput: (value) => promptText = value,
        messageAI: messageAI,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isLoading) return;

          setState(() => isLoading = true);

          try {
            final response =
                await model.generateContent([Content.text(promptText)]);

            messageAI = MessageAI.fromString(response.text.toString());
          } catch (e) {
            messageAI = MessageAI(isSuccess: false, message: e.toString());
          }

          setState(() => isLoading = false);
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}

class DataView extends StatelessWidget {
  final MessageAI messageAI;
  final ValueChanged<String> onChangeInput;
  final bool isLoading;
  const DataView(
      {super.key,
      required this.messageAI,
      required this.onChangeInput,
      this.isLoading = false});

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
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              Text(messageAI.message),
              if (messageAI.isSuccess) ...[
                ...messageAI.coursesModel!.map(
                  (course) => CourseCard(course: course),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(messageAI.coursesModel!);
                  },
                  child: const Text('Crear curso'),
                )
              ]
            ],
          ],
        ),
      ),
    );
  }
}

class MessageAI {
  final bool isSuccess;
  final String message;
  final List<CourseModel>? coursesModel;

  MessageAI(
      {required this.isSuccess, required this.message, this.coursesModel});

  MessageAI.fromJson(Map<String, dynamic> json)
      : isSuccess = json['isSuccess'] ?? false,
        message = json['message'] ?? '',
        coursesModel =
            json['coursesModel'] == null || json['isSuccess'] == false
                ? []
                : (json['coursesModel'] as List)
                    .map((schedule) => CourseModel.fromJson(schedule))
                    .toList();

  factory MessageAI.fromString(String data) {
    try {
      final json = jsonDecode(data);

      return MessageAI.fromJson(json);
    } catch (e, st) {
      return MessageAI(isSuccess: false, message: e.toString() + st.toString());
    }
  }
}
