import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../utils/app_logger.dart';

class StorageService extends GetxService {
  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    AppLogger.info('StorageService initialized', 'Storage');
    return this;
  }

  // Generic String
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  // Generic Bool
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  // Generic Int
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);

  // Generic Remove / Clear
  Future<bool> remove(String key) => _prefs.remove(key);
  Future<bool> clear() => _prefs.clear();

  // JSON Objects
  Future<bool> setObject(String key, Map<String, dynamic> jsonMap) {
    return _prefs.setString(key, jsonEncode(jsonMap));
  }

  Map<String, dynamic>? getObject(String key) {
    final str = _prefs.getString(key);
    if (str == null || str.isEmpty) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.error('Failed to decode JSON for key: $key', e, null, 'Storage');
      return null;
    }
  }

  // JSON Lists
  Future<bool> setObjectList(String key, List<Map<String, dynamic>> list) {
    return _prefs.setString(key, jsonEncode(list));
  }

  List<Map<String, dynamic>>? getObjectList(String key) {
    final str = _prefs.getString(key);
    if (str == null || str.isEmpty) return null;
    try {
      final decoded = jsonDecode(str) as List;
      return decoded.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      AppLogger.error('Failed to decode list for key: $key', e, null, 'Storage');
      return null;
    }
  }

  // Search History
  List<String> getSearchHistory() {
    return _prefs.getStringList(AppConstants.keySearchHistory) ?? [];
  }

  Future<void> addSearchHistory(String city) async {
    final history = getSearchHistory();
    history.removeWhere((item) => item.toLowerCase() == city.toLowerCase());
    history.insert(0, city);
    if (history.length > AppConstants.maxSearchHistory) {
      history.removeLast();
    }
    await _prefs.setStringList(AppConstants.keySearchHistory, history);
  }

  Future<void> removeSearchHistoryItem(String city) async {
    final history = getSearchHistory();
    history.removeWhere((item) => item.toLowerCase() == city.toLowerCase());
    await _prefs.setStringList(AppConstants.keySearchHistory, history);
  }

  Future<void> clearSearchHistory() async {
    await _prefs.remove(AppConstants.keySearchHistory);
  }
}
