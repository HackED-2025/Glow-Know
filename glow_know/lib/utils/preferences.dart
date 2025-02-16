import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<List<String>> getSkinTypes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('skinTypes') ?? [];
  }

  static Future<List<String>> getHairTypes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('hairTypes') ?? [];
  }

  static Future<bool> isVegan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isVegan') ?? false;
  }
}
