import 'dart:ui';

import 'package:tradeable_flutter_sdk/src/models/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_model.dart';

enum TopicContextType { tag, course }

class TopicUserModel {
  final int topicId;
  final String name;
  final String description;
  final Logo logo;
  Progress progress;
  int? startFlow;
  TopicContextType? topicContextType;
  int? topicContextId;
  Color? cardColor;

  TopicUserModel(
      {required this.topicId,
      required this.name,
      required this.description,
      required this.logo,
      required this.progress,
      this.startFlow,
      this.topicContextType,
      this.topicContextId,
      this.cardColor});

  factory TopicUserModel.fromTopic(Topic topic) {
    return TopicUserModel(
      topicId: topic.id,
      name: topic.name,
      description: topic.description,
      logo: topic.logo,
      progress: topic.progress,
      startFlow: topic.startFlow,
    );
  }

  TopicUserModel copyWith({
    int? topicId,
    String? name,
    String? description,
    Logo? logo,
    Progress? progress,
    int? startFlow,
    TopicContextType? topicContextType,
    int? topicContextId,
    Color? cardColor,
  }) {
    return TopicUserModel(
        topicId: topicId ?? this.topicId,
        name: name ?? this.name,
        description: description ?? this.description,
        logo: logo ?? this.logo,
        progress: progress ?? this.progress,
        startFlow: startFlow ?? this.startFlow,
        topicContextType: topicContextType ?? this.topicContextType,
        topicContextId: topicContextId ?? this.topicContextId,
        cardColor: cardColor);
  }
}
