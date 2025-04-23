import 'package:dio/dio.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/course_progress_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/courses_model.dart';
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
    Response response = await Dio().get(
      "$baseUrl/v0/sdk/topics/$topicId/flows/$flowId",
      queryParameters: {
        "topic_tag_id": topicTagId,
      },
      options: Options(headers: kagrtoken),
    );

    return FlowModel.fromJson(response.data["data"]);
  }

  Future<List<CoursesModel>> getModules() async {
    Response response = await Dio().get(
      "$baseUrl/v0/sdk/modules",
      options: Options(headers: kagrtoken),
    );
    return (response.data["data"] as List)
        .map((e) => CoursesModel.fromJson(e))
        .toList();
  }

  Future<List<CourseProgressModel>> getCourseProgress() async {
    Response response = await Dio().get(
      "$baseUrl/v0/sdk/modules/recent_progress",
      options: Options(headers: kagrtoken),
    );
    return (response.data["data"] as List)
        .map((e) => CourseProgressModel.fromJson(e))
        .toList();
  }

  Future<CoursesModel> getTopicsInCourse(int moduleId) async {
    Response response = await Dio().get(
      "$baseUrl/v0/sdk/modules/$moduleId",
      options: Options(headers: kagrtoken),
    );

    return CoursesModel.fromJson(response.data["data"]);
  }
}
