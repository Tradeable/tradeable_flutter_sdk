import 'package:tradeable_flutter_sdk/src/models/kagr/flow_model.dart';

class Topic {
  final int id;
  final String name;
  final String description;
  final Logo logo;
  final Progress progress;
  final int? startFlow;
  final List<TagModel> tags;
  List<FlowModel>? flows;

  Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.progress,
    required this.startFlow,
    required this.tags,
    this.flows,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      logo: Logo.fromJson(json["logo"]),
      progress: Progress.fromJson(json["progress"]),
      startFlow: json["start_flow"],
      tags: json["tags"] != null
          ? (json["tags"] as List).map((e) => TagModel.fromJson(e)).toList()
          : [],
      flows: json["flows"] != null
          ? (json["flows"] as List).map((e) => FlowModel.fromJson(e)).toList()
          : [],
    );
  }
}

class TagModel {
  final int id;
  final String name;

  TagModel({required this.id, required this.name});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json["id"],
      name: json["name"],
    );
  }
}

class Progress {
  int? total;
  int? completed;

  Progress({this.total, this.completed});

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      total: json["total"] ?? 0,
      completed: json["completed"] ?? 0,
    );
  }
}
