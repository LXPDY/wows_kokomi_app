import 'package:wows_kokomi_app/models/server_name.dart';

import 'package:shared_preferences/shared_preferences.dart';
const String apiUrl = "http://www.wows-coral.com:8000";


class LocalStorage {
  static const String defaultAccountKey = 'defaultAccount';
  static const String accountListKey = 'accountList';

  static Future<bool> hasDefaultAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(defaultAccountKey);
  }

  static Future<void> bindDefaultAccount(String aid, ServerName serverName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(defaultAccountKey, '$aid:${serverName.name}');
  }

  static Future<String?> getDefaultAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(defaultAccountKey);
  }

  static Future<List<String>> getAccountList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(accountListKey) ?? [];
  }

  static Future<void> addAccountToList(String aid, ServerName serverName) async {
    final prefs = await SharedPreferences.getInstance();
    final accountList = prefs.getStringList(accountListKey) ?? [];
    accountList.add('$aid:${serverName.name}');
    await prefs.setStringList(accountListKey, accountList);
  }

  static Future<void> removeAccountFromList(String aid, ServerName serverName) async {
    final prefs = await SharedPreferences.getInstance();
    final accountList = prefs.getStringList(accountListKey) ?? [];
    accountList.remove('$aid:${serverName.name}');
    await prefs.setStringList(accountListKey, accountList);
  }
}