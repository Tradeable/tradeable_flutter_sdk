import 'package:dio/dio.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/module_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_model.dart';
import 'package:tradeable_flutter_sdk/src/utils/constants.dart';

class KagrApi {
  Future<ModuleData> fetchModuleById(int moduleId) async {
    Response response = await Dio().get(
      "$baseUrl/v0/sdk/modules/$moduleId",
      options: Options(headers: kagrtoken),
    );
    return ModuleData.fromJson(response.data["data"]);
  }

  Future<Topic> fetchTopicById(
    int topicId,
    int moduleId,
    int topicTagId,
  ) async {
    Response response = await Dio().get(
      "$baseUrl/v0/sdk/topics/$topicId",
      queryParameters: {
        "module_id": moduleId,
        "topic_tag_id": topicTagId,
      },
      options: Options(headers: kagrtoken),
    );

    return Topic.fromJson(response.data["data"]);
  }
}
