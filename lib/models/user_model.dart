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

  UserData({
    required this.nickname,
    required this.user,
    required this.clan,
    required this.battleType,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      nickname: json['nickname'],
      user: User.fromJson(json['user']),
      clan: Clan.fromJson(json['clan']),
      battleType: BattleType.fromJson(json['battle_type']),
    );
  }
}

class User {
  int levelingTier;
  int createdAt;
  int levelingPoints;
  int karma;
  int lastBattleTime;

  User({
    required this.levelingTier,
    required this.createdAt,
    required this.levelingPoints,
    required this.karma,
    required this.lastBattleTime,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      levelingTier: json['leveling_tier'],
      createdAt: json['created_at'],
      levelingPoints: json['leveling_points'],
      karma: json['karma'],
      lastBattleTime: json['last_battle_time'],
    );
  }
}

class Clan {
  int membersCount;
  String name;
  String tag;
  int color;

  Clan({
    required this.membersCount,
    required this.name,
    required this.tag,
    required this.color,
  });

  factory Clan.fromJson(Map<String, dynamic> json) {
    if (json['members_count'] == null) {
      return Clan(
        membersCount: 0,
        name: '无公会',
        tag: '无公会',
        color: 0,
      );
    }
    return Clan(
      membersCount: json['members_count'],
      name: json['name'],
      tag: json['tag'],
      color: json['color'],
    );
  }
}

class BattleType {
  Pvp pvp;
  PvpSolo pvpSolo;
  PvpDiv2 pvpDiv2;

  BattleType({
    required this.pvp,
    required this.pvpSolo,
    required this.pvpDiv2,
  });

  factory BattleType.fromJson(Map<String, dynamic> json) {
    return BattleType(
      pvp: Pvp.fromJson(json['pvp']),
      pvpSolo: PvpSolo.fromJson(json['pvp_solo']),
      pvpDiv2: PvpDiv2.fromJson(json['pvp_div2']),
    );
  }
}

class Pvp {
  int battlesCount;
  int wins;
  int damageDealt;
  int frags;
  int originalExp;
  int hitsByMain;
  int shotsByMain;
  int valueBattlesCount;
  double personalRating;
  double nDamageDealt;
  double nFrags;

  Pvp({
    required this.battlesCount,
    required this.wins,
    required this.damageDealt,
    required this.frags,
    required this.originalExp,
    required this.hitsByMain,
    required this.shotsByMain,
    required this.valueBattlesCount,
    required this.personalRating,
    required this.nDamageDealt,
    required this.nFrags,
  });

  factory Pvp.fromJson(Map<String, dynamic> json) {
    return Pvp(
      battlesCount: json['battles_count'],
      wins: json['wins'],
      damageDealt: json['damage_dealt'],
      frags: json['frags'],
      originalExp: json['original_exp'],
      hitsByMain: json['hits_by_main'],
      shotsByMain: json['shots_by_main'],
      valueBattlesCount: json['value_battles_count'],
      personalRating: json['personal_rating'],
      nDamageDealt: json['n_damage_dealt'],
      nFrags: json['n_frags'],
    );
  }
}

class PvpSolo {
  int battlesCount;
  int wins;
  int damageDealt;
  int frags;
  int originalExp;
  int hitsByMain;
  int shotsByMain;
  int valueBattlesCount;
  double personalRating;
  double nDamageDealt;
  double nFrags;

  PvpSolo({
    required this.battlesCount,
    required this.wins,
    required this.damageDealt,
    required this.frags,
    required this.originalExp,
    required this.hitsByMain,
    required this.shotsByMain,
    required this.valueBattlesCount,
    required this.personalRating,
    required this.nDamageDealt,
    required this.nFrags,
  });

  factory PvpSolo.fromJson(Map<String, dynamic> json) {
    return PvpSolo(
      battlesCount: json['battles_count'],
      wins: json['wins'],
      damageDealt: json['damage_dealt'],
      frags: json['frags'],
      originalExp: json['original_exp'],
      hitsByMain: json['hits_by_main'],
      shotsByMain: json['shots_by_main'],
      valueBattlesCount: json['value_battles_count'],
      personalRating: json['personal_rating'],
      nDamageDealt: json['n_damage_dealt'],
      nFrags: json['n_frags'],
    );
  }
}

class PvpDiv2 {
  int battlesCount;
  int wins;
  int damageDealt;
  int frags;

  PvpDiv2({
    required this.battlesCount,
    required this.wins,
    required this.damageDealt,
    required this.frags,
  });

  factory PvpDiv2.fromJson(Map<String, dynamic> json) {
    return PvpDiv2(
      battlesCount: json['battles_count'],
      wins: json['wins'],
      damageDealt: json['damage_dealt'],
      frags: json['frags'],
    );
  }
}


// curl -X 'GET' 'http://www.wows-coral.com:8000/a/basic-data/?server=asia&aid=2027994108' -H 'accept: application/json' -H 'Authorization: Bearer user123456'
