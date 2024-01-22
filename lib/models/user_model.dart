import 'dart:convert';

import 'package:http/http.dart';
import 'package:wows_kokomi_app/common/app_http_tool.dart';
import 'package:wows_kokomi_app/common/user_global.dart';
import 'package:wows_kokomi_app/models/error_model.dart';
import 'package:wows_kokomi_app/models/server_name.dart';

class UserInfo {
  late ServerName serverName;
  late int userUID;
  ErrorHttpModel? errorModel;
  UserInfoModel? userInfoModel;
  UserInfo();

  Future<void> init(ServerName server, String nickname, int limit) async {
    String url = "$apiUrl/a/search-users/?server=$serverName&aid=$nickname";
    Response response = await httpTool.httpGet(url);
    Map<String, dynamic> json;
    if (response.statusCode == 404) {
      json = {
        "status": "error",
        "message": "APP错误,获取用户数据失败,请截图并联系开发者",
        "error": response.body
      };
    } else {
      final decodedData = utf8.decode(response.bodyBytes);
      json = jsonDecode(decodedData);
    }
    String status = json['status'];
        if (status == "error") {
      errorModel = ErrorHttpModel(json);
    } else {
      userInfoModel = UserInfoModel(json);
    }
  }
}

class UserInfoModel {
  late int battles_count;
  late int wins;
  late int damage_dealt;
  late int frags;
  late int original_exp;
  late int value_battles_count;
  late int personal_rating;
  late int n_damage_dealt;
  late int n_frags;

  UserInfoModel(Map<String, dynamic> json) {

  }
}

// curl -X 'GET' 'http://www.wows-coral.com:8000/a/basic-data/?server=asia&aid=2027994108' -H 'accept: application/json' -H 'Authorization: Bearer user123456'
