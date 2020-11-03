import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class LocalStorageController {
  final storage = new FlutterSecureStorage();

  Future<dynamic> getKey(String keyString) async {
    return await storage.read(key: keyString);
  }

  Future<Map<String, String>> getAll() async{
    return await storage.readAll();
  }

}