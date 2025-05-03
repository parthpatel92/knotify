import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class NotificationDB {
  static Database? _database;

  // Singleton pattern
  static Future<Database> get database async {
    if (_database != null) return _database!;

    // If database is null, initialize it
    _database = await _initDB();
    return _database!;
  }

  // Initialize database
  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'notifications.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notifications(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            body TEXT,
            scheduleDate TEXT
          )
        ''');
      },
    );
  }

  // Insert new notification
  static Future<void> insertNotification(NotificationModel notification) async {
    final db = await database;
    await db.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all notifications
  static Future<List<NotificationModel>> getNotifications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notifications');

    return List.generate(maps.length, (i) {
      return NotificationModel.fromMap(maps[i]);
    });
  }

  // Update notification
  static Future<void> updateNotification(NotificationModel notification) async {
    final db = await database;
    await db.update(
      'notifications',
      notification.toMap(),
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  // Delete notification
  static Future<void> deleteNotification(int id) async {
    final db = await database;
    await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
