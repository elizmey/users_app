import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:users_app_sql/models/user_model.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;
  DbService._internal();

  Database? _db;
  final _store = intMapStoreFactory.store('users');

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    return await databaseFactoryWeb.openDatabase('app.db');
  }

  Future<void> closeDb() async {
    await _db?.close();
    _db = null;
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    final key = await _store.add(db, user.toMap());
    return key as int;
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final records = await _store.find(db);
    return records.map((r) {
      final map = Map<String, dynamic>.from(r.value);
      map['id'] = r.key;
      return User.fromMap(map);
    }).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    if (user.id == null) return 0;
    final finder = Finder(filter: Filter.byKey(user.id));
    return await _store.update(db, user.toMap(), finder: finder);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await _store.delete(db, finder: Finder(filter: Filter.byKey(id)));
  }
}
