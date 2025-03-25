import 'package:tradeable_flutter_sdk/src/models/kagr/topic_model.dart';

class ModuleData {
  final int id;
  final String name;
  final String description;
  final Progress progress;
  final List<Topic> topics;

  ModuleData({
    required this.id,
    required this.name,
    required this.description,
    required this.progress,
    required this.topics,
  });

  factory ModuleData.fromJson(Map<String, dynamic> json) {
    return ModuleData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      progress: Progress.fromJson(json['progress']),
      topics: (json['topics'] as List).map((e) => Topic.fromJson(e)).toList(),
    );
  }
}
