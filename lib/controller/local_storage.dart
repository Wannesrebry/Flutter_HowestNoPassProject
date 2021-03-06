import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageController {
  final storage = new FlutterSecureStorage();

  Future<dynamic> getKey(String keyString) async {
    return await storage.read(key: keyString);
  }

  Future<Map<String, String>> getAll() async{
    return await storage.readAll();
  }

  Future<void> add(String key, String value, {force: false})async{
    if(force || !await storage.containsKey(key: key)){
      await storage.write(key: key, value: value);
    }
  }
}