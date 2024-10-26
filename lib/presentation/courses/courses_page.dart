import 'package:charla_vertex_gemini/presentation/courses/course_model.dart';
import 'package:charla_vertex_gemini/presentation/courses/create_course_by_ai.dart';
import 'package:charla_vertex_gemini/presentation/courses/widgets/course_card.dart';
import 'package:charla_vertex_gemini/presentation/widget/scaffold_tecylab.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final List<CourseModel> courses = [
    CourseModel(
      title: 'Curso de Flutter',
      description: 'Aprende a programar con Flutter',
      teacher: 'Juan Perez',
      modality: 'Presencial',
    ),
    CourseModel(
      title: 'Curso de Firebase',
      teacher: 'Carlos Ramirez',
      modality: 'Híbrido',
    ),
    CourseModel(
      title: 'Curso de Machine Learning',
      description: 'Aprende a programar con Machine Learning',
      teacher: 'Luisa Fernandez',
      modality: 'Virtual',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldTecylab(
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: courses.map((course) => CourseCard(course: course)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //_createCourse(CreateCourseByForm.route());
          _createCourse(CreateCourseByAi.route());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _createCourse(Route<List<CourseModel>> routePage) async {
    final listCourse = await Navigator.of(context).push(routePage);

    if (listCourse == null) return;

    for (var course in listCourse) {
      courses.add(course);
    }

    setState(() {});
  }
}
