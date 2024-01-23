import 'dart:convert';

import 'package:http/http.dart';
import 'package:wows_kokomi_app/common/app_http_tool.dart';
import 'package:wows_kokomi_app/common/user_global.dart';
import 'package:wows_kokomi_app/models/error_model.dart';
import 'package:wows_kokomi_app/models/server_name.dart';

class UserInfo {
  ServerName? serverName;
  late int userUID;
  ErrorHttpModel? errorModel;
  UserInfoModel? userInfoModel;
  UserInfo();

  Future<void> init(ServerName server, String aid) async {
    String url = "$apiUrl/a/basic-data/?server=${server.name}&aid=$aid";
    Response response = await httpGet(url);
    Map<String, dynamic> json;
    if (response.statusCode == 404) {
      json = {
        "status": "error",
        "message": "获取用户数据失败,请截图并联系开发者",
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
      userInfoModel = UserInfoModel.fromJson(json);
      return;
    }
    json['error'] = getErrorMessage(json['message']);
    errorModel = ErrorHttpModel(json);
  }
}

String getErrorMessage(String message) {
  switch (message) {
    case 'NETWORK FAILURE':
      return '网络请求失败';
    case 'NETWORK TIMEOUT':
      return '网络请求超时';
    case 'PROGRAM ERROR':
      return '程序内部错误';
    case 'HIDDEN PROFILE':
      return '该账号隐藏战绩';
    case 'NO STATISTICS':
      return '该账号没有统计数据';
    case 'USER NOT EXIST':
      return '用户数据不存在';
    default:
      return '未知错误';
  }
}

class UserInfoModel {
  String status;
  String message;
  UserData data;

  UserInfoModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      status: json['status'],
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  String nickname;
  User user;
  Clan clan;
  BattleType battleType;
  Record record;

  UserData({
    required this.nickname,
    required this.user,
    required this.clan,
    required this.battleType,
    required this.record,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      nickname: json['nickname'],
      user: User.fromJson(json['user']),
      clan: Clan.fromJson(json['clan']),
      battleType: BattleType.fromJson(json['battle_type']),
      record: Record.fromJson(json['record']),
    );
  }
}

class User {
  String accountCreationTime;
  String lastBattleTime;

  User({
    required this.accountCreationTime,
    required this.lastBattleTime,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accountCreationTime: json['account_creation_time'],
      lastBattleTime: json['last_battle_time'],
    );
  }
}

class Clan {
  String tag;
  String color;

  Clan({
    required this.tag,
    required this.color,
  });

  factory Clan.fromJson(Map<String, dynamic> json) {
    if (json['tag'] == null) {
      return Clan(
        tag: '无工会',
        color: '000000',
      );
    }
    return Clan(
      tag: json['tag'],
      color: json['color'],
    );
  }
}

class BattleType {
  BattleData pvp;
  BattleData pvpSolo;
  BattleData pvpDiv2;
  BattleData pvpDiv3;
  BattleData rankSolo;

  BattleType({
    required this.pvp,
    required this.pvpSolo,
    required this.pvpDiv2,
    required this.pvpDiv3,
    required this.rankSolo,
  });

  factory BattleType.fromJson(Map<String, dynamic> json) {
    return BattleType(
      pvp: BattleData.fromJson(json['pvp']),
      pvpSolo: BattleData.fromJson(json['pvp_solo']),
      pvpDiv2: BattleData.fromJson(json['pvp_div2']),
      pvpDiv3: BattleData.fromJson(json['pvp_div3']),
      rankSolo: BattleData.fromJson(json['rank_solo']),
    );
  }
}

class BattleData {
  int battlesCount;
  double winRate;
  int avgDamage;
  double avgFrags;
  int avgExp;
  double hitRatio;
  int avgPr;
  int avgPrDis;
  String avgPrDes;
  String winRateColor;
  String avgDamageColor;
  String avgFragsColor;
  String avgPrColor;

  BattleData({
    required this.battlesCount,
    required this.winRate,
    required this.avgDamage,
    required this.avgFrags,
    required this.avgExp,
    required this.hitRatio,
    required this.avgPr,
    required this.avgPrDis,
    required this.avgPrDes,
    required this.winRateColor,
    required this.avgDamageColor,
    required this.avgFragsColor,
    required this.avgPrColor,
  });

  factory BattleData.fromJson(Map<String, dynamic> json) {
    return BattleData(
      battlesCount: json['battles_count'],
      winRate: (json['win_rate'] as num).toDouble(),
      avgDamage: json['avg_damage'],
      avgFrags: (json['avg_frags'] as num).toDouble(),
      avgExp: json['avg_exp'],
      hitRatio: (json['hit_ratio'] as num).toDouble(),
      avgPr: json['avg_pr'],
      avgPrDis: json['avg_pr_dis'],
      avgPrDes: json['avg_pr_des'],
      winRateColor: json['win_rate_color'],
      avgDamageColor: json['avg_damage_color'],
      avgFragsColor: json['avg_frags_color'],
      avgPrColor: json['avg_pr_color'],
    );
  }
}

class Record {
  RecordData maxBattlesCount;
  RecordData maxPlanesKilled;
  RecordData maxDamageDealt;
  RecordData maxExp;
  RecordData maxFrags;
  RecordData maxTotalAgro;
  RecordData maxScoutingDamage;

  Record({
    required this.maxBattlesCount,
    required this.maxPlanesKilled,
    required this.maxDamageDealt,
    required this.maxExp,
    required this.maxFrags,
    required this.maxTotalAgro,
    required this.maxScoutingDamage,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      maxBattlesCount: RecordData.fromJson(json['max_battles_count']),
      maxPlanesKilled: RecordData.fromJson(json['max_planes_killed']),
      maxDamageDealt: RecordData.fromJson(json['max_damage_dealt']),
      maxExp: RecordData.fromJson(json['max_exp']),
      maxFrags: RecordData.fromJson(json['max_frags']),
      maxTotalAgro: RecordData.fromJson(json['max_total_agro']),
      maxScoutingDamage: RecordData.fromJson(json['max_scouting_damage']),
    );
  }
}

class RecordData {
  Map<String, int> data;

  RecordData({
    required this.data,
  });

  factory RecordData.fromJson(Map<String, dynamic> json) {
    return RecordData(
      data: Map<String, int>.from(json),
    );
  }
}
// curl -X 'GET' 'http://www.wows-coral.com:8000/a/basic-data/?server=asia&aid=2027994108' -H 'accept: application/json' -H 'Authorization: Bearer user123456'
