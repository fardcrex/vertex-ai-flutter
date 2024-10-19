import 'package:charla_vertex_gemini/presentation/courses/course_model.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 165, 29),
                  shape: BoxShape.circle,
                ),
                child: Text(course.modality[0],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold))),
            title: Text(course.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle:
                course.description == null ? null : Text(course.description!),
            trailing: Text(course.teacher),
          ),
        ),
        const SizedBox(height: 2),
        Wrap(
          runAlignment: WrapAlignment.start,
          spacing: 8,
          children: course.schedules
              .map((schedule) => CardSchedule(schedule: schedule))
              .toList(),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class CardSchedule extends StatelessWidget {
  final ScheduleModel schedule;
  const CardSchedule({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final dayText = switch (schedule.day) {
      1 => 'Lunes',
      2 => 'Martes',
      3 => 'Miércoles',
      4 => 'Jueves',
      5 => 'Viernes',
      6 => 'Sábado',
      7 => 'Domingo',
      _ => 'Día no válido',
    };

    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 243, 243),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(dayText, style: const TextStyle(fontSize: 16)),
            Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 118, 223, 255),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  schedule.time,
                )),
          ],
        ),
      ),
    );
  }
}
