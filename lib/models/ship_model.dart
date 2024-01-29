import 'dart:convert';

import 'package:http/http.dart';
import 'package:wows_kokomi_app/common/app_http_tool.dart';
import 'package:wows_kokomi_app/common/user_global.dart';
import 'package:wows_kokomi_app/models/error_model.dart';
import 'package:wows_kokomi_app/models/enum_name.dart';
import 'package:wows_kokomi_app/models/user_model.dart';

// curl -X 'GET' 'http://www.wows-coral.com:8000/a/ship-data/?server=asia&aid=2023619512&ship_id=3762272208' -H 'accept: application/json' -H 'Authorization: Bearer user123456'
// curl -X 'GET' 'http://www.wows-coral.com:8000/a/ships-data/?server=asia&aid=2023619512' -H 'accept: application/json' -H 'Authorization: Bearer user123456'

class ShipInfoResponse {
  ServerName? serverName;
  late int userUID;
  ErrorHttpModel? errorModel;
  ShipInfoModel? shipInfoModel;
  ShipInfoResponse();

  Future<void> init(ServerName server, String aid, String shipID) async {
    String url = "$apiUrl/a/ship-data/?server=${server.name}&aid=$aid&$shipID";
    Response response = await httpGet(url);
    Map<String, dynamic> json;
    if (response.statusCode == 404) {
      json = {
        "status": "error",
        "message": "获取船只数据失败,请截图并联系开发者",
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
      shipInfoModel = ShipInfoModel.fromMap(json);
      return;
    }
    json['error'] = getErrorMessage(json['message']);
    errorModel = ErrorHttpModel(json);
  }
}

class ShipInfoModel {
  String status;
  String message;
  Data data;

  ShipInfoModel({
    required this.status,
    required this.message,
    required this.data,
  });


  factory ShipInfoModel.fromMap(Map<String, dynamic> json) =>
      ShipInfoModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
      );
}

class Data {
  ShipInfo shipInfo;
  ShipData shipData;
  Record record;

  Data({
    required this.shipInfo,
    required this.shipData,
    required this.record,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        shipInfo: ShipInfo.fromMap(json["ship_info"]),
        shipData: ShipData.fromMap(json["ship_data"]),
        record: Record.fromMap(json["record"]),
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
  Pvp pvp;
  Pvp pvpSolo;
  Pvp pvpDiv2;
  Pvp pvpDiv3;

  ShipData({
    required this.pvp,
    required this.pvpSolo,
    required this.pvpDiv2,
    required this.pvpDiv3,
  });

  factory ShipData.fromMap(Map<String, dynamic> json) => ShipData(
        pvp: Pvp.fromMap(json["pvp"]),
        pvpSolo: Pvp.fromMap(json["pvp_solo"]),
        pvpDiv2: Pvp.fromMap(json["pvp_div2"]),
        pvpDiv3: Pvp.fromMap(json["pvp_div3"]),
      );
}

class Pvp {
  int battlesCount;
  double winRate;
  int avgDamage;
  double avgFrags;
  int avgPr;
  int avgPrDis;
  String avgPrDes;
  String winRateColor;
  String avgDamageColor;
  String avgFragsColor;
  String avgPrColor;

  Pvp({
    required this.battlesCount,
    required this.winRate,
    required this.avgDamage,
    required this.avgFrags,
    required this.avgPr,
    required this.avgPrDis,
    required this.avgPrDes,
    required this.winRateColor,
    required this.avgDamageColor,
    required this.avgFragsColor,
    required this.avgPrColor,
  });

  factory Pvp.fromMap(Map<String, dynamic> json) => Pvp(
        battlesCount: json["battles_count"],
        winRate: json["win_rate"].toDouble(),
        avgDamage: json["avg_damage"],
        avgFrags: json["avg_frags"].toDouble(),
        avgPr: json["avg_pr"],
        avgPrDis: json["avg_pr_dis"],
        avgPrDes: json["avg_pr_des"],
        winRateColor: json["win_rate_color"],
        avgDamageColor: json["avg_damage_color"],
        avgFragsColor: json["avg_frags_color"],
        avgPrColor: json["avg_pr_color"],
      );
}

class Record {
  int maxFrags;
  int maxDamageDealt;
  int maxExp;
  int maxTotalAgro;
  int maxScoutingDamage;
  int maxPlanesKilled;

  Record({
    required this.maxFrags,
    required this.maxDamageDealt,
    required this.maxExp,
    required this.maxTotalAgro,
    required this.maxScoutingDamage,
    required this.maxPlanesKilled,
  });

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        maxFrags: json["max_frags"],
        maxDamageDealt: json["max_damage_dealt"],
        maxExp: json["max_exp"],
        maxTotalAgro: json["max_total_agro"],
        maxScoutingDamage: json["max_scouting_damage"],
        maxPlanesKilled: json["max_planes_killed"],
      );
}