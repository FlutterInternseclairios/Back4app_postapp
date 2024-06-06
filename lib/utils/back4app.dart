import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Back4app {
  static final String _baseUrl = "https://parseapi.back4app.com/classes/";

  static Future<void> initParse() async {
    final keyApplicationId = 'EC5heR8Lj9TujKEWAPS8RlRGatdy01sU6ziZnCv6';
    final keyClientKey = 'IhYYXny805pAfLzG3Sf7k30UkTI47riX3zcWZlOv';
    final keyParseServerUrl = 'https://parseapi.back4app.com';

    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true, debug: true);
  }
}
