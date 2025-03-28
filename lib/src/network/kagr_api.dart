import 'package:dio/dio.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_model.dart';
import 'package:tradeable_flutter_sdk/src/utils/constants.dart';

class KagrApi {
  Future<List<Topic>> fetchTopicByTagId(int tagId) async {
    Response response = await Dio().get(
      "$baseUrl/v0/sdk/topics",
      queryParameters: {"topic_tag_id": tagId},
      options: Options(headers: kagrtoken),
    );

    return (response.data["data"] as List)
        .map((e) => Topic.fromJson(e))
        .toList();
  }

  Future<Topic> fetchTopicById(
    int topicId,
    int topicTagId,
  ) async {
    Response response = await Dio().get(
      "$baseUrl/v0/sdk/topics/$topicId",
      queryParameters: {
        "topic_tag_id": topicTagId,
      },
      options: Options(headers: kagrtoken),
    );

    return Topic.fromJson(response.data["data"]);
  }

  Future<FlowModel> fetchFlowById(
    int topicId,
    int flowId,
    int topicTagId,
  ) async {
    print("$topicId, $flowId, $topicTagId");
    Response response = await Dio().get(
      "$baseUrl/v0/sdk/topics/$topicId/flows/$flowId",
      queryParameters: {
        "topic_tag_id": topicTagId,
      },
      options: Options(headers: kagrtoken),
    );


    return FlowModel.fromJson(response.data["data"]);
  }
}
