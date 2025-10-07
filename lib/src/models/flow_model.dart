class FlowModel {
  final int id;
  final bool isCompleted;
  List<FlowWidget>? widgets;
  final Logo logo;
  final String? category;
  final String? name;

  FlowModel({
    required this.id,
    required this.isCompleted,
    this.widgets,
    required this.logo,
    required this.category,
    this.name,
  });

  factory FlowModel.fromJson(Map<String, dynamic> json) {
    return FlowModel(
      id: json["id"],
      isCompleted: json["is_completed"],
      widgets: (json['widgets'] as List?)
          ?.map((e) => FlowWidget.fromJson(e))
          .toList(),
      logo: Logo.fromJson(json["logo"]),
      category: json["category"],
      name: json["name"],
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

class FlowWidget {
  dynamic data;
  String modelType;

  FlowWidget({this.data, required this.modelType});

  factory FlowWidget.fromJson(Map<String, dynamic> json) {
    return FlowWidget(data: json["data"], modelType: json["model_type"]);
  }
}
