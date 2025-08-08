import 'package:tradeable_flutter_sdk/src/models/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_model.dart';

class ModuleUserModel {
  final int moduleId;
  final List<TopicUserModel> topics;

  ModuleUserModel({required this.moduleId, required this.topics});
}

class TopicUserModel {
  final int topicId;
  final String name;
  final String description;
  final Logo logo;
  final Progress progress;
  int? startFlow;
  final int topicTagId;

  TopicUserModel(
      {required this.topicId,
      required this.name,
      required this.description,
      required this.logo,
      required this.progress,
      this.startFlow,
      required this.topicTagId});

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
}
