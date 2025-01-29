import 'package:dio/dio.dart';
import 'package:tradeable_flutter_sdk/src/models/enums/page_types.dart';
import 'package:tradeable_flutter_sdk/src/models/level/level.model.dart';
import 'package:tradeable_flutter_sdk/src/models/module.model.dart';
import 'package:tradeable_flutter_sdk/src/utils/constants.dart';

class Api {
  Future<List<ModuleModel>> getPages(PageId pageId) async {
    Response response = await Dio().get(
      "$baseUrl/v4/learn/pages",
      queryParameters: {"id": pageId.value},
      options: Options(headers: token),
    );
    return (response.data["page_level_link"] as List)
        .map((e) => ModuleModel.fromJson(e))
        .toList();
  }

  Future<Level> fetchLevelById(int levelId) async {
    Response response = await Dio().get(
      "$baseUrl/v4/learn/level/$levelId",
      options: Options(headers: token),
    );
    return Level.fromJson(response.data);
  }
}
