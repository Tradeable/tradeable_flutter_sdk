import 'package:tradeable_flutter_sdk/src/models/kagr/flow_model.dart';

class TopicFlowModel {
  final int topicId;
  List<TopicFlowsListModel> userFlowsList;

  TopicFlowModel({required this.topicId, required this.userFlowsList});
}

class TopicFlowsListModel {
  final int flowId;
  final bool isCompleted;
  final Logo logo;
  final String category;

  TopicFlowsListModel(
      {required this.flowId,
      required this.isCompleted,
      required this.logo,
      required this.category});
}

class CategorisedFlow {
  final String category;
  final List<TopicFlowsListModel> flowsList;

  CategorisedFlow({required this.category, required this.flowsList});
}
