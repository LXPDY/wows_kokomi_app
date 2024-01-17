import 'dart:convert';

/// 用户搜索数据集
class UserListModel {
  String? status;
  String? message;
  List<ListUserData>? data;

/// 接受http返回的body，解析出相关数据
 UserListModel(String body) {
    Map<String, dynamic> json = jsonDecode(body);
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