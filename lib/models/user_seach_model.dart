import 'dart:convert';

import 'package:http/http.dart';
import 'package:wows_kokomi_app/models/api_url.dart';
import 'package:wows_kokomi_app/models/server_name.dart';

import '../common/kkm_http_tool.dart';
import 'error_model.dart';

/// 用户搜索数据集
class UserListModel {
  String? status;
  String? message;
  List<ListUserData>? data;

/// 接受http返回的body，解析出相关数据
 UserListModel(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = <ListUserData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data?.add(ListUserData(v));
      });
    }
  }
}

/// 用户搜索-单个用户数据
class ListUserData {
  String? name;
  int? aid;
  ListUserData(Map<String, dynamic> json) {
    name = json['name'];
    aid = json['aid'];
  }
}

/// 获取用户列表数据
class UserList {
  UserListModel? userListModel;
  ErrorHttpModel? errorModel;

  UserList();

  Future<void> init(ServerName server, String nickname, int limit) async {
    String strLimit = limit.toString();
    String serverName = server.name;
    String url = "$api_url/a/search-users/?server=$serverName&nickname=$nickname&limit=$strLimit";
    Response response = await httpTool.httpGet(url);
    Map<String, dynamic> json;
    if (response.statusCode == 404) {
      json = {
          "status": "error",
          "message": "APP ERROR",
          "error": "Http get fail"
      };
    } else {
      json = jsonDecode(response.body);
    }
    String status = json['status'];
    if (status == "error") {
      errorModel = ErrorHttpModel(json);
    } else {
      userListModel = UserListModel(json);
    }
  }
}