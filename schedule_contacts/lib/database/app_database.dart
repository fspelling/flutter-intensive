import 'package:schedule_contacts/database/dao/contact_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase.internal();
  Database _db;

  factory AppDatabase() => _instance;

  AppDatabase.internal();

  Future<Database> get db async {
    if (_db == null) _db = await _initDB();
    return _db;
  }

  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contacts.db');

    return await openDatabase(path, version: 1,
        onCreate: (database, version) async {
      await database.execute(ContactDao.SQL);
    });
  }
}
