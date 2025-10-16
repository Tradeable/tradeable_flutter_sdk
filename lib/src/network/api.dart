import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tradeable_flutter_sdk/src/models/course_progress_model.dart';
import 'package:tradeable_flutter_sdk/src/models/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_model.dart';
import 'package:tradeable_flutter_sdk/src/network/auth_interceptor.dart';
import 'package:tradeable_flutter_sdk/src/utils/security.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class API {
  Dio dio = Dio(BaseOptions(baseUrl: TFS().baseUrl))
    ..interceptors.add(AuthInterceptor());

  Future<List<Topic>> fetchTopicByTagId(int tagId) async {
    Response response = await dio.get(
      "/v0/sdk/topics",
      queryParameters: {"topic_tag_id": tagId},
    );

    String data =
        await decryptData(TFS().secretKey!, response.data['data']['payload']);
    var dataJson = jsonDecode(data);

    return (dataJson["data"] as List).map((e) => Topic.fromJson(e)).toList();
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
    String data =
        await decryptData(TFS().secretKey!, response.data['data']['payload']);
    var dataJson = jsonDecode(data);
    return Topic.fromJson(dataJson["data"]);
  }

  Future<List<Topic>> fetchRelatedTopics(int tagId, int topicId) async {
    Response response = await dio.get(
      "/v0/sdk/topics/$topicId/related",
      queryParameters: {"topicTagId": tagId},
    );

    String data =
        await decryptData(TFS().secretKey!, response.data['data']['payload']);
    var dataJson = jsonDecode(data);
    return (dataJson["data"] as List).map((e) => Topic.fromJson(e)).toList();
  }

  Future<List<CoursesModel>> getModules() async {
    Response response = await dio.get(
      "/v0/sdk/modules",
    );
    String data =
        await decryptData(TFS().secretKey!, response.data['data']['payload']);
    var dataJson = jsonDecode(data);
    return (dataJson['data'] as List)
        .map((e) => CoursesModel.fromJson(e))
        .toList();
  }

  Future<List<CourseProgressModel>> getCourseProgress() async {
    Response response = await dio.get(
      "/v0/sdk/modules/recent_progress",
    );
    String data =
        await decryptData(TFS().secretKey!, response.data['data']['payload']);
    var dataJson = jsonDecode(data);
    return (dataJson["data"] as List)
        .map((e) => CourseProgressModel.fromJson(e))
        .toList();
  }

  Future<CoursesModel> getTopicsInCourse(int moduleId) async {
    Response response = await dio.get(
      "/v0/sdk/modules/$moduleId",
    );

    String data =
        await decryptData(TFS().secretKey!, response.data['data']['payload']);
    var dataJson = jsonDecode(data);
    return CoursesModel.fromJson(dataJson["data"]);
  }

  Future<FlowModel> fetchFlowById(int flowId,
      {int? moduleId, int? topicId, int? topicTagId}) async {
    Response response =
        await dio.get("/v0/sdk/flows/$flowId", queryParameters: {
      "module_id": moduleId,
      "topic_id": topicId,
      "topic_tag_id": topicTagId,
    });

    String data =
        await decryptData(TFS().secretKey!, response.data['data']['payload']);
    var dataJson = jsonDecode(data);
    return FlowModel.fromJson(dataJson["data"]);
  }

  Future<Map<String, String>> markFlowAsCompleted(
      int flowId, int? topicId, int? topicTagId) async {
    final response = await dio.post(
      "/v0/sdk/flows/$flowId/completed",
      data: {"topicId": topicId, "topicTagId": topicTagId},
    );

    String data =
        await decryptData(TFS().secretKey!, response.data['data']['payload']);
    var dataJson = jsonDecode(data);
    log(dataJson.toString());
    return Map<String, String>.from(dataJson);
  }
}
