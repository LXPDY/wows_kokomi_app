import 'package:wows_kokomi_app/models/server_name.dart';

import 'package:shared_preferences/shared_preferences.dart';
const String apiUrl = "http://www.wows-coral.com:8000";


class LocalStorage {
  static const String defaultAccountKey = 'defaultAccount';
  static const String accountListKey = 'accountList';
  static const String searchHistoryKey = 'searchHistory'; 
  static Future<bool> hasDefaultAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(defaultAccountKey);
  }

  static Future<void> bindDefaultAccount(String aid, String userName, ServerName serverName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(defaultAccountKey, '$aid:$userName:${serverName.name}');
  }

  static Future<String?> getDefaultAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(defaultAccountKey);
  }

  static Future<List<String>> getAccountList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(accountListKey) ?? [];
  }

  static Future<void> addAccountToList(String aid, String userName, ServerName serverName) async {
    final prefs = await SharedPreferences.getInstance();
    final accountList = prefs.getStringList(accountListKey) ?? [];
    accountList.add('$aid:$userName:${serverName.name}');
    await prefs.setStringList(accountListKey, accountList);
  }

  static Future<void> removeAccountFromList(String aid, String userName, ServerName serverName) async {
    final prefs = await SharedPreferences.getInstance();
    final accountList = prefs.getStringList(accountListKey) ?? [];
    accountList.remove('$aid:$userName:${serverName.name}');
    await prefs.setStringList(accountListKey, accountList);
  }

    static Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(searchHistoryKey) ?? [];
  }

  static Future<void> addSearchHistory(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    final searchHistory = prefs.getStringList(searchHistoryKey) ?? [];
    searchHistory.remove(userName);
    searchHistory.insert(0, userName);
    if (searchHistory.length > 6) {
      searchHistory.removeLast();
    }
    await prefs.setStringList(searchHistoryKey, searchHistory);
  }

  static Future<void> removeSearchHistory(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    final searchHistory = prefs.getStringList(searchHistoryKey) ?? [];
    searchHistory.remove(userName);
    await prefs.setStringList(searchHistoryKey, searchHistory);
  }
}