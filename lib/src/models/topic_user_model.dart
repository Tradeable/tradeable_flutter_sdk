import 'dart:ui';

import 'package:tradeable_flutter_sdk/src/models/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_model.dart';

class TopicUserModel {
  final int topicId;
  final String name;
  final String description;
  final Logo logo;
  Progress progress;
  int? startFlow;
  final int topicTagId;
  Color? cardColor;

  TopicUserModel(
      {required this.topicId,
      required this.name,
      required this.description,
      required this.logo,
      required this.progress,
      this.startFlow,
      required this.topicTagId,
      this.cardColor});

  factory TopicUserModel.fromTopic(Topic topic) {
    return TopicUserModel(
      topicId: topic.id,
      name: topic.name,
      description: topic.description,
      logo: topic.logo,
      progress: topic.progress,
      startFlow: topic.startFlow,
      topicTagId: 33,
    );
  }

  TopicUserModel copyWith({
    int? topicId,
    String? name,
    String? description,
    Logo? logo,
    Progress? progress,
    int? startFlow,
    int? topicTagId,
    Color? cardColor,
  }) {
    return TopicUserModel(
      topicId: topicId ?? this.topicId,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      progress: progress ?? this.progress,
      startFlow: startFlow ?? this.startFlow,
      topicTagId: topicTagId ?? this.topicTagId,
      cardColor: cardColor
    );
}
