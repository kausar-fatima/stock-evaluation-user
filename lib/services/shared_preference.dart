import 'package:stock_management/headers.dart';

Future<void> saveUserId(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
}

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

Future<void> saveShopIds(List<String> shopIds) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String shopIdsJson = jsonEncode(shopIds);
  await prefs.setString('shop_ids', shopIdsJson);
}

Future<List<String>> getShopIds() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? shopIdsJson = prefs.getString('shop_ids');
  if (shopIdsJson != null) {
    List<dynamic> shopIdsDynamic = jsonDecode(shopIdsJson);
    return shopIdsDynamic.cast<String>();
  } else {
    return [];
  }
}

Future<void> clearShopIds() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('shop_ids');
}
