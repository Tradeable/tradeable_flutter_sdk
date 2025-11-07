import 'package:tradeable_flutter_sdk/src/models/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_model.dart';

class ProgressModel {
  final Summary summary;
  final List<OverallProgressModel> overall;

  ProgressModel({required this.summary, required this.overall});

  factory ProgressModel.fromJson(Map<String, dynamic> json) => ProgressModel(
        summary: Summary.fromJson(json['summary']),
        overall: (json['overall'] as List)
            .map((e) => OverallProgressModel.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'summary': summary.toJson(),
        'overall': overall.map((e) => e.toJson()).toList(),
      };
}

class Summary {
  final int total;
  final int completed;
  final int inProgress;

  Summary(
      {required this.total, required this.completed, required this.inProgress});

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        total: json['total'] ?? 0,
        completed: json['completed'] ?? 0,
        inProgress: json['inProgress'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'completed': completed,
        'inProgress': inProgress,
      };
}

class OverallProgressModel {
  final int id;
  final String name;
  final String description;
  final Logo logo;
  final DateTime lastActivityAt;
  final Progress progress;

  OverallProgressModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.lastActivityAt,
    required this.progress,
  });

  factory OverallProgressModel.fromJson(Map<String, dynamic> json) =>
      OverallProgressModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        logo: Logo.fromJson(json['logo'] ?? {}),
        lastActivityAt: DateTime.parse(json['lastActivityAt']),
        progress: Progress.fromJson(json['progress']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'logo': logo.toJson(),
        'lastActivityAt': lastActivityAt.toIso8601String(),
        'progress': progress.toJson(),
      };
}
