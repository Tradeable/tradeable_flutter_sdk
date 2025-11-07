import 'package:tradeable_flutter_sdk/src/models/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_user_model.dart';

class TopicFlowModel {
  final int topicId;
  final int? topicTagId;
  TopicContextType? topicContextType;
  int? topicContextId;
  List<TopicFlowsListModel> userFlowsList;

  TopicFlowModel(
      {required this.topicId, this.topicTagId,
      this.topicContextType,
      this.topicContextId,
      required this.userFlowsList});
}

class TopicFlowsListModel {
  final String? name;
  final int flowId;
  final bool isCompleted;
  final Logo logo;
  final String category;

  TopicFlowsListModel(
      {required this.name,
      required this.flowId,
      required this.isCompleted,
      required this.logo,
      required this.category});
}

class CategorisedFlow {
  final String category;
  final List<TopicFlowsListModel> flowsList;

  CategorisedFlow({required this.category, required this.flowsList});
}
