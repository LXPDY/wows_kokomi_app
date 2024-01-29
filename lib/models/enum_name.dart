enum ServerName { asia, cn, eu, na, ru }

extension ServerNameExtension on ServerName {
  String get name {
    return toString().split('.').last;
  }

  String get str {
    switch (this) {
      case ServerName.asia:
        return '亚服';
      case ServerName.cn:
        return '国服';
      case ServerName.eu:
        return '欧服';
      case ServerName.na:
        return '美服';
      case ServerName.ru:
        return '俄服';
      default:
        return '未知';
    }
  }
}

enum NationName { cw,e,hl,i,m,c,f,s,d,y,r,fm,x }

extension NationNameExtension on NationName {
  String get name {
    return toString().split('.').last;
  }
}


enum ShipTypeName { aircarrier, battleship, destroyer, submarine, cruiser}

extension ShipTypeNameExtension on ShipTypeName {
  String get name {
    return toString().split('.').last;
  }
}

Map<NationName, String> nationNameChinese = {
  NationName.cw: '英联邦',
  NationName.e: '欧洲',
  NationName.hl: '荷兰',
  NationName.i: '意大利',
  NationName.m: '美国',
  NationName.c: '泛亚',
  NationName.f: '法国',
  NationName.s: '苏联',
  NationName.d: '德国',
  NationName.y: '英国',
  NationName.r: '日本',
  NationName.fm: '泛美',
  NationName.x: '西班牙',
};

Map<ShipTypeName, String> shipTypeNameChinese = {
  ShipTypeName.aircarrier: '航母',
  ShipTypeName.battleship: '战列',
  ShipTypeName.destroyer: '驱逐',
  ShipTypeName.submarine: '潜艇',
  ShipTypeName.cruiser: '巡洋',
};

Map<String, NationName> nationNameMap = {
  'commonwealth': NationName.cw,
  'europe': NationName.e,
  'france': NationName.f,
  'germany': NationName.d,
  'italy': NationName.i,
  'japan': NationName.r,
  'netherlands': NationName.hl,
  'pan_america': NationName.fm,
  'pan_asia': NationName.c,
  'spain': NationName.x,
  'uk': NationName.y,
  'ussr': NationName.s,
  'usa': NationName.m,
};

Map<String, ShipTypeName> shipTypeNameMap = {
  'AirCarrier': ShipTypeName.aircarrier,
  'Battleship': ShipTypeName.battleship,
  'Cruiser': ShipTypeName.cruiser,
  'Destroyer': ShipTypeName.destroyer,
  'Submarine': ShipTypeName.submarine,
};