import 'package:tradeable_flutter_sdk/src/models/kagr/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_model.dart';

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
  int startFlow;
  final int topicTagId;

  TopicUserModel(
      {required this.topicId,
      required this.name,
      required this.description,
      required this.logo,
      required this.progress,
      required this.startFlow,
      required this.topicTagId});
}
