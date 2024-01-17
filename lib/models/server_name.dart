enum ServerName { asia, cn, eu, na, ru }

extension ServerNameExtension on ServerName {
  String get name {
    return toString().split('.').last;
  }
}
