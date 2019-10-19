import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = new FlutterSecureStorage();
class Storage{
  static Future<bool> doesValuesExist(List<String> keys) async{
    bool entered = true;
    for (String key in keys) {
      if(await storage.read(key: key) == null){
        entered = false;
        break;
      }
    }

    return entered;
  }

  static Future<String> readValue(String key) async {
    return storage.read(key:key);
  }

  static Future<void> writeValue(String key, String value) async {
    await storage.write(key: key, value: value);
  }


}