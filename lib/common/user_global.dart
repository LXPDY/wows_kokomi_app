import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/common/app_http_tool.dart';
import 'package:wows_kokomi_app/models/enum_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart'; 
const String apiUrl = "http://www.wows-coral.com:8000";

class LocalStorage {
  static const String defaultAccountKey = 'defaultAccount';
  static const String accountListKey = 'accountList';
  static const String searchHistoryKey = 'searchHistory';
  static const String imagesKey = 'images';
  static Future<bool> hasDefaultAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(defaultAccountKey);
  }

  static Future<void> bindDefaultAccount(
      String aid, String userName, ServerName serverName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        defaultAccountKey, '$aid:$userName:${serverName.name}');
  }

  static Future<String?> getDefaultAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(defaultAccountKey);
  }

  static Future<List<String>> getAccountList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(accountListKey) ?? [];
  }

  static Future<void> addAccountToList(
      String aid, String userName, ServerName serverName) async {
    final prefs = await SharedPreferences.getInstance();
    final accountList = prefs.getStringList(accountListKey) ?? [];
    accountList.add('$aid:$userName:${serverName.name}');
    await prefs.setStringList(accountListKey, accountList);
  }

  static Future<void> removeAccountFromList(
      String aid, String userName, ServerName serverName) async {
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

static Future<String> getImagePath(String imageUrl) async {
  final prefs = await SharedPreferences.getInstance();
  final imagesJson = prefs.getString(imagesKey) ?? '{}';
  final imagesMap = json.decode(imagesJson) as Map<String, dynamic>;

  if (imagesMap.containsKey(imageUrl)) {
    final imagePath = imagesMap[imageUrl];
    final file = File(imagePath);

    if (await file.exists()) {
      return imagePath;
    } else {
      final newPath = await _downloadAndSaveImage(imageUrl);
      imagesMap[imageUrl] = newPath;
      final updatedImagesJson = json.encode(imagesMap);
      await prefs.setString(imagesKey, updatedImagesJson);
      return newPath;
    }
  } else {
    final imagePath = await _downloadAndSaveImage(imageUrl);
    imagesMap[imageUrl] = imagePath;
    final updatedImagesJson = json.encode(imagesMap);
    await prefs.setString(imagesKey, updatedImagesJson);
    return imagePath;
  }
}

static Future<String> _downloadAndSaveImage(String imageUrl) async {
  final response = await httpGet(imageUrl);

  if (response.statusCode == 200) {
    final directory = await getApplicationDocumentsDirectory();
    const uuid = Uuid();
    final fileName = '${uuid.v4()}.png';
    final imagePath = '${directory.path}/$fileName';

    final file = File(imagePath);
    await file.writeAsBytes(response.bodyBytes);

    return imagePath;
  } else {
    throw Exception('Failed to download image from $imageUrl');
  }
}

  static Future<Image> getImage(String imageUrl) async {
    final imagePath = await LocalStorage.getImagePath(imageUrl);

    if (imagePath.isNotEmpty) {
      return Image.file(File(imagePath));
    } else {
      return Image.network(imageUrl);
    }
  }
}
