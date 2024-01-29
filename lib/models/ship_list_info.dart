
import 'dart:convert';

import 'package:http/http.dart';
import 'package:wows_kokomi_app/common/app_http_tool.dart';
import 'package:wows_kokomi_app/common/user_global.dart';
import 'package:wows_kokomi_app/models/enum_name.dart';
import 'package:wows_kokomi_app/models/error_model.dart';
import 'package:wows_kokomi_app/models/user_model.dart';

class ShipListResponse {
  ServerName? serverName;
  late int userUID;
  ErrorHttpModel? errorModel;
  ShipListModel? shipListModel;
  ShipListResponse();

  Future<void> init(ServerName server, String aid) async {
    String url = "$apiUrl/a/ships-data/?server=${server.name}&aid=$aid";
    Response response = await httpGet(url);
    Map<String, dynamic> json;
    if (response.statusCode == 404) {
      json = {
        "status": "error",
        "message": "获取船只列表数据失败,请截图并联系开发者",
        "error": response.body
      };
    } else {
      final decodedData = utf8.decode(response.bodyBytes);
      json = jsonDecode(decodedData);
    }
    String status = json['status'];
    if (status == "error") {
      errorModel = ErrorHttpModel(json);
      return;
    }
    if (json['message'] == "SUCCESS") {
      shipListModel = ShipListModel.fromMap(json);
      return;
    }
    json['error'] = getErrorMessage(json['message']);
    errorModel = ErrorHttpModel(json);
  }
}

class ShipListModel {
  String status;
  String message;
  Map<String, Ship> data;

  ShipListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ShipListModel.fromMap(Map<String, dynamic> json) => ShipListModel(
        status: json["status"],
        message: json["message"],
        data: Map.from(json["data"]).map((k, v) => MapEntry<String, Ship>(k, Ship.fromMap(v))),
      );
}

class Ship {
  ShipInfo shipInfo;
  ShipData shipData;

  Ship({
    required this.shipInfo,
    required this.shipData,
  });

  factory Ship.fromMap(Map<String, dynamic> json) => Ship(
        shipInfo: ShipInfo.fromMap(json["ship_info"]),
        shipData: ShipData.fromMap(json["ship_data"]),
      );
}

class ShipInfo {
  int tier;
  String type;
  String nation;
  String nameZh;
  String nameEn;
  String pngUrl;

  ShipInfo({
    required this.tier,
    required this.type,
    required this.nation,
    required this.nameZh,
    required this.nameEn,
    required this.pngUrl,
  });

  factory ShipInfo.fromMap(Map<String, dynamic> json) => ShipInfo(
        tier: json["tier"],
        type: json["type"],
        nation: json["nation"],
        nameZh: json["name_zh"],
        nameEn: json["name_en"],
        pngUrl: json["png_url"],
      );
}

class ShipData {
  int battlesCount;
  double winRate;
  int avgDamage;
  double avgFrags;
  int avgPr;
  int avgPrDis;
  String avgPrDes;
  String avgPrColor;

  ShipData({
    required this.battlesCount,
    required this.winRate,
    required this.avgDamage,
    required this.avgFrags,
    required this.avgPr,
    required this.avgPrDis,
    required this.avgPrDes,
    required this.avgPrColor,
  });

  factory ShipData.fromMap(Map<String, dynamic> json) => ShipData(
        battlesCount: json["battles_count"],
        winRate: json["win_rate"].toDouble(),
        avgDamage: json["avg_damage"],
        avgFrags: json["avg_frags"].toDouble(),
        avgPr: json["avg_pr"],
        avgPrDis: json["avg_pr_dis"],
        avgPrDes: json["avg_pr_des"],
        avgPrColor: json["avg_pr_color"],
      );
}