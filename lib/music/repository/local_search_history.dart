import 'package:shared_preferences/shared_preferences.dart';

const String KEY_HISTORY = "key_search_history";

List<String> _histories;

///get local search history
Future<List<String>> getSearchHistory() async {
  if (_histories != null) {
    return _histories;
  }
  SharedPreferences preferences = await SharedPreferences.getInstance();
  _histories = preferences.getStringList(KEY_HISTORY);
  if (_histories == null) {
    _histories = [];
  }
  return _histories;
}

Future<bool> clearSearchHistory() async {
  _histories?.clear();
  final preference = await SharedPreferences.getInstance();
  return await preference.remove(KEY_HISTORY);
}

Future<bool> insertSearchHistory(String query) async {
  if (_histories == null) {
    await getSearchHistory();
  }
  _histories.remove(query);
  _histories.insert(0, query);

  while (_histories.length > 10) {
    _histories.removeLast();
  }

  final preference = await SharedPreferences.getInstance();
  return preference.setStringList(KEY_HISTORY, _histories);
}
