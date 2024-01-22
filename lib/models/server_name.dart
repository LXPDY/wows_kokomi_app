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
