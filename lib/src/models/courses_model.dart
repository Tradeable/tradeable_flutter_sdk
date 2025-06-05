import 'package:tradeable_flutter_sdk/src/models/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_model.dart';

class CoursesModel {
  final int id;
  final String name;
  final String description;
  final Logo logo;
  final Progress progress;
  final List<Topic>? topics;

  CoursesModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.progress,
    this.topics,
  });

  factory CoursesModel.fromJson(Map<String, dynamic> json) {
    return CoursesModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logo: Logo.fromJson(json['logo']),
      progress: Progress.fromJson(json['progress']),
      topics: json['topics'] != null
          ? (json['topics'] as List).map((e) => Topic.fromJson(e)).toList()
          : null,
    );
  }
}
