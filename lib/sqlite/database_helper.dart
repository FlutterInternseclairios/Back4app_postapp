import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:back4app_posts_app/json/users.dart';

class DatabaseHelper {
  final databaseName = 'authentication.db';

  String user = '''
  CREATE TABLE users(
    userId INTEGER PRIMARY KEY AUTOINCREMENT,
    fullName TEXT,
    email TEXT,
    userName TEXT UNIQUE,
    password TEXT,
    phoneNumber TEXT,
    dateOfBirth TEXT,
    gender TEXT,
    imagePath TEXT
    address TEXT
  )
 ''';

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute(user);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute("ALTER TABLE users ADD COLUMN address TEXT");
        }
      },
    );
  }

  Future<bool> authenticate(Users usr) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "select * from users where userName = '${usr.userName}' AND password = '${usr.password}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> createUser(Users usr) async {
    final Database db = await initDB();
    return db.insert("users", usr.toJson());
  }

  Future<Users?> getUser(String userName) async {
    final Database db = await initDB();
    var res =
        await db.query("users", where: "userName = ?", whereArgs: [userName]);
    return res.isNotEmpty ? Users.fromJson(res.first) : null;
  }

  Future<int> updateUserImagePath(String userName, String imagePath) async {
    final Database db = await initDB();
    return await db.update(
      'users',
      {'imagePath': imagePath},
      where: "userName = ?",
      whereArgs: [userName],
    );
  }

  // Future<int> updateadress(address, userId) async {
  //   final Database db = await initDB();
  //   return db
  //       .rawUpdate('update users set address = ?, where userId = ?', [address]);
  // }

  // Future<int> updatedateofbith(dateOfBirth, userId) async {
  //   final Database db = await initDB();
  //   return db.rawUpdate(
  //       'update users set dateOfBirth = ?, where userId = ?', [dateOfBirth]);
  // }

  // Future<int> updatephoneNumber(phoneNumber, userId) async {
  //   final Database db = await initDB();
  //   return db.rawUpdate(
  //       'update users set address = ?, where userId = ?', [phoneNumber]);
  // }

  Future<void> updateUserProfile(String userName,
      {String? dateOfBirth,
      int? phoneNumber,
      String? address,
      String? imagePath}) async {
    final db = await initDB();
    await db.update(
      'users',
      {
        'dateOfBirth': dateOfBirth,
        'phoneNumber': phoneNumber,
        'address': address,
        'imagePath': imagePath
      },
      where: "userName = ?",
      whereArgs: [userName],
    );
  }
}
