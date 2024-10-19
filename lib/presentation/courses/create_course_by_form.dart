import 'package:charla_vertex_gemini/presentation/courses/course_model.dart';
import 'package:charla_vertex_gemini/presentation/options_generator_page.dart';
import 'package:charla_vertex_gemini/presentation/widget/scaffold_tecylab.dart';
import 'package:flutter/material.dart';

class CreateCourseByForm extends StatefulWidget {
  static MaterialPageRoute<CourseModel> route() =>
      MaterialPageRoute<CourseModel>(
        builder: (context) => const CreateCourseByForm(),
      );

  const CreateCourseByForm({super.key});

  @override
  State<CreateCourseByForm> createState() => _CreateCourseByFormState();
}

class _CreateCourseByFormState extends State<CreateCourseByForm> {
  String courseTitle = '';
  String courseDescription = '';
  String courseTeacher = '';
  String modality = 'Virtual';

  @override
  Widget build(BuildContext context) {
    return ScaffoldTecylab(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Título del curso'),
            onChanged: (value) => courseTitle = value,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(labelText: 'Profesor del curso'),
            onChanged: (value) => courseTeacher = value,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
                labelText: 'Descripción del curso (opcional)'),
            onChanged: (value) => courseDescription = value,
          ),
          const SizedBox(height: 16),
          SelectedGroupType(
              onSelected: (value) => setState(() => modality = value),
              valueSelected: modality),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final course = CourseModel(
                title: courseTitle,
                modality: modality,
                description:
                    courseDescription.isEmpty ? null : courseDescription,
                teacher: courseTeacher,
              );

              Navigator.of(context).pop(course);
            },
            child: const Text('Crear curso'),
          ),
        ],
      ),
    );
  }
}

class SelectedGroupType extends StatelessWidget {
  final ValueChanged<String> onSelected;
  final String valueSelected;
  const SelectedGroupType(
      {super.key, required this.onSelected, required this.valueSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: ['Virtual', 'Híbrido', 'Precencial']
          .map((typeGeneration) => SelectedTab(
                onSelected: onSelected,
                value: typeGeneration,
                isSelected: valueSelected == typeGeneration,
              ))
          .toList(),
    );
  }
}
