import 'package:dio/dio.dart';
import 'package:tradeable_flutter_sdk/src/models/course_progress_model.dart';
import 'package:tradeable_flutter_sdk/src/models/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_model.dart';
import 'package:tradeable_flutter_sdk/src/network/auth_interceptor.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class API {
  Dio dio = Dio(BaseOptions(baseUrl: TFS().baseUrl))
    ..interceptors.add(AuthInterceptor());

  Future<List<Topic>> fetchTopicByTagId(int tagId) async {
    Response response = await dio.get(
      "/v0/sdk/topics",
      queryParameters: {"topic_tag_id": tagId},
    );

    return (response.data["data"] as List)
        .map((e) => Topic.fromJson(e))
        .toList();
  }

  Future<Topic> fetchTopicById(
    int topicId,
    int topicTagId,
  ) async {
    Response response = await dio.get(
      "/v0/sdk/topics/$topicId",
      queryParameters: {
        "topic_tag_id": topicTagId,
      },
    );

    return Topic.fromJson(response.data["data"]);
  }

  Future<FlowModel> fetchFlowById(
    int? topicId,
    int flowId,
    int topicTagId,
  ) async {
    Response response = await dio.get(
      "/v0/sdk/flows/$flowId",
    );

    return FlowModel.fromJson(response.data["data"]);
  }

  Future<List<CoursesModel>> getModules() async {
    Response response = await dio.get(
      "/v0/sdk/modules",
    );
    return (response.data["data"] as List)
        .map((e) => CoursesModel.fromJson(e))
        .toList();
  }

  Future<List<CourseProgressModel>> getCourseProgress() async {
    Response response = await dio.get(
      "/v0/sdk/modules/recent_progress",
    );
    return (response.data["data"] as List)
        .map((e) => CourseProgressModel.fromJson(e))
        .toList();
  }

  Future<CoursesModel> getTopicsInCourse(int moduleId) async {
    Response response = await dio.get(
      "/v0/sdk/modules/$moduleId",
    );

    return CoursesModel.fromJson(response.data["data"]);
  }

  Future<List<Topic>> fetchRelatedTopics(int tagId, int topicId) async {
    Response response = await dio.get(
      "https://dev.api.tradeable.app/v0/sdk/topics/$topicId/related",
      queryParameters: {"topicTagId": tagId},
    );

    return (response.data["data"] as List)
        .map((e) => Topic.fromJson(e))
        .toList();
  }
}
