class CourseModel {
  final String title;
  final String teacher;
  final String modality;
  final String? description;
  final List<ScheduleModel> schedules;

  CourseModel({
    required this.title,
    this.description,
    required this.teacher,
    required this.modality,
    List<ScheduleModel>? schedules,
  }) : schedules = schedules ?? [];

  CourseModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        modality = json['modality'],
        teacher = json['teacher'],
        schedules = json['schedules'] == null
            ? []
            : (json['schedules'] as List)
                .map((schedule) => ScheduleModel.fromJson(schedule))
                .toList();
}

class ScheduleModel {
  final int day;
  final String time;

  ScheduleModel({
    required this.day,
    required this.time,
  });

  ScheduleModel.fromJson(Map<String, dynamic> json)
      : day = json['day'],
        time = json['time'];

  Map<String, dynamic> toJson() => {
        'day': day,
        'time': time,
      };
}
