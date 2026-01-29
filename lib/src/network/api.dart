import 'package:dio/dio.dart';
import 'package:tradeable_flutter_sdk/src/models/course_progress_model.dart';
import 'package:tradeable_flutter_sdk/src/models/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_model.dart';
import 'package:tradeable_flutter_sdk/src/network/auth_interceptor.dart';
import 'package:tradeable_flutter_sdk/src/network/tradeable_interceptor.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class API {
  Dio dio = Dio(BaseOptions(baseUrl: TFS().baseUrl))
    ..interceptors.add(TFS().client == Client.axis
        ? AuthInterceptor()
        : TradeableAuthInterceptor());

  Future<List<Topic>> fetchTopicByTagId(int tagId) async {
    Response response = await dio.get(
      "/v0/sdk/topics",
      queryParameters: {"topic_tag_id": tagId},
    );
    return (response.data['data'] as List)
        .map((e) => Topic.fromJson(e))
        .toList();
  }

  Future<Topic> fetchTopicById(int topicId,
      {int? topicTagId, int? moduleId}) async {
    Map<String, int> queryParma = {};
    if (topicTagId != null) queryParma['topic_tag_id'] = topicTagId;
    if (moduleId != null) queryParma['module_id'] = moduleId;
    Response response = await dio.get(
      "/v0/sdk/topics/$topicId",
      queryParameters: queryParma,
    );

    return Topic.fromJson(response.data['data']);
  }

  Future<List<Topic>> fetchRelatedTopics(int tagId, int topicId) async {
    Response response = await dio.get(
      "/v0/sdk/topics/$topicId/related",
      queryParameters: {"topicTagId": tagId},
    );

    return (response.data["data"] as List)
        .map((e) => Topic.fromJson(e))
        .toList();
  }

  Future<List<CoursesModel>> getModules() async {
    Response response = await dio.get(
      "/v0/sdk/modules",
    );
    return (response.data['data'] as List)
        .map((e) => CoursesModel.fromJson(e))
        .toList();
  }

  Future<List<CourseProgressModel>> getCourseProgress() async {
    Response response = await dio.get(
      "/v0/sdk/modules/recent_progress",
    );
    return (response.data['data'] as List)
        .map((e) => CourseProgressModel.fromJson(e))
        .toList();
  }

  Future<CoursesModel> getTopicsInCourse(int moduleId) async {
    Response response = await dio.get(
      "/v0/sdk/modules/$moduleId",
    );

    return CoursesModel.fromJson(response.data['data']);
  }

  Future<FlowModel> fetchFlowById(int flowId,
      {int? moduleId, int? topicId, int? topicTagId}) async {
    Map<String, int> queryParam = {};
    if (topicId != null) queryParam['topic_id'] = topicId;
    if (topicTagId != null) queryParam['topic_tag_id'] = topicTagId;
    if (moduleId != null) queryParam['module_id'] = moduleId;
    Response response =
        await dio.get("/v0/sdk/flows/$flowId", queryParameters: queryParam);
    return FlowModel.fromJson(response.data['data']);
  }

  Future<Map<String, String>> markFlowAsCompleted(
      int flowId, int? topicId, int? topicTagId, int? moduleId) async {
    // Map<String, int> queryParam = {};
    // if (topicId != null) queryParam['topicId'] = topicId;
    // if (topicTagId != null) queryParam['topicTagId'] = topicTagId;
    // if (moduleId != null) queryParam['moduleId'] = moduleId;
    final response = await dio.post(
      "/v0/sdk/flows/$flowId/complete-all",
      // data: queryParam,
    );
    return Map<String, String>.from(response.data);
  }

  Future<ProgressModel> getUserProgress() async {
    final response = await dio.get("/v0/sdk/modules/progress");
    return ProgressModel.fromJson(response.data['data']);
  }

  Future<List<Map<String, dynamic>>> getBanners() async {
    final response = await dio.get("/v0/sdk/ui/learn-dashboard/banner");
    final data = response.data['data'] as List;
    return data.map((e) => {'url': e}).toList();
  }
}
