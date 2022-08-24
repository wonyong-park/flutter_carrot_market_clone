import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageRepository {
  final storage = FlutterSecureStorage(); //스토리지 생성

  ///get
  Future<String?> getStoreValue(String key) async {
    try {
      return await storage.read(key: key);
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///set
  Future<void> storeValue(String key, String value) async {
    try {
      return await storage.write(key: key, value: value);
    } catch (e) {
      print(e);
    }
  }
}