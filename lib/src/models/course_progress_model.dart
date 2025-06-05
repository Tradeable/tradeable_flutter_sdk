import 'package:tradeable_flutter_sdk/src/models/topic_model.dart';

class CourseProgressModel {
  final int moduleId;
  final int topicId;
  final String topicName;
  final Progress progress;

  CourseProgressModel({
    required this.moduleId,
    required this.topicId,
    required this.topicName,
    required this.progress,
  });

  factory CourseProgressModel.fromJson(Map<String, dynamic> json) {
    return CourseProgressModel(
      moduleId: json['module_id'],
      topicId: json['topic_id'],
      topicName: json['topic_name'],
      progress: Progress.fromJson(json['progress']),
    );
  }
}
