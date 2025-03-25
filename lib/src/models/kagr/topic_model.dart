class Topic {
  final int id;
  final String name;
  final String description;
  final Logo logo;
  final Progress progress;
  final int? startFlow;
  final List<String> tags;
  List<Flow>? flows;

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
      tags: List<String>.from(json["tags"]),
      flows: json["flows"] != null
          ? (json["flows"] as List).map((e) => Flow.fromJson(e)).toList()
          : [],
    );
  }
}

class Logo {
  final String url;
  final String type;

  Logo({required this.url, required this.type});

  factory Logo.fromJson(Map<String, dynamic> json) {
    return Logo(
      url: json["url"],
      type: json["type"],
    );
  }
}

class Progress {
  final int total;
  final int completed;

  Progress({required this.total, required this.completed});

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      total: json["total"],
      completed: json["completed"],
    );
  }
}

class Flow {
  final int id;
  final bool isCompleted;
  final Logo logo;
  final String? category;

  Flow({
    required this.id,
    required this.isCompleted,
    required this.logo,
    required this.category,
  });

  factory Flow.fromJson(Map<String, dynamic> json) {
    return Flow(
      id: json["id"],
      isCompleted: json["is_completed"],
      logo: Logo.fromJson(json["logo"]),
      category: json["category"],
    );
  }
}
