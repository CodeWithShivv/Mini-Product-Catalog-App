import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> initHive() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    await createBoxes();
  }

  Future<void> createBoxes() async {
    try {
      await Hive.openBox('products');
    } catch (e) {
      return;
    }
  }

  Future<void> saveData(String boxName, String key, dynamic data) async {
    try {
      var box = await Hive.openBox(boxName);
      await box.put(key, data);
    } catch (e) {
      return;
    }
  }

  Future<dynamic> getData(String boxName, String key) async {
    try {
      var box = await Hive.openBox(boxName);
      return box.get(key);
    } catch (e) {
      return;
    }
  }

  Future<void> deleteData(String boxName, String key) async {
    try {
      var box = await Hive.openBox(boxName);
      await box.delete(key);
    } catch (e) {
      return;
    }
  }

  Future<void> clearBox(String boxName) async {
    try {
      var box = await Hive.openBox(boxName);
      await box.clear();
    } catch (e) {
      return;
    }
  }
}
