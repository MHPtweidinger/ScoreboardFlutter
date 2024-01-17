import 'package:scoreboard/entity/player.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import 'dao.dart';

class PlayerDB {
  final tableName = "player";

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
    "id" INTEGER not null,
    "name" STRING not null, 
    "scores" STRING, 
    "sorting" INTEGER, 
    PRIMARY KEY ("id" AUTOINCREMENT)    
    ); """);
  }

  Future<int> create({required String name, required int sorting}) async {
    final database = await PlayerDao().database;
    return await database.rawInsert('''INSERT INTO $tableName (name, sorting) VALUES (?,?)''', [name, sorting]);
  }

  Future<List<Player>> fetchAll() async {
    final database = await PlayerDao().database;
    final players = await database.rawQuery('''SELECT *  from $tableName ORDER BY sorting''');
    return players.map((player) => Player.fromSqfliteDatabase(player)).toList();
  }

  Future<Player> fetchById(int id) async {
    final database = await PlayerDao().database;
    final List<Map<String, Object?>> player = await database.rawQuery('''select * from $tableName WHERE id = ?''', [id]);
    return Player.fromSqfliteDatabase(player.first);
  }

  Future<int> update({required int id, String? name, List<int>? scores, int? sorting}) async {
    final database = await PlayerDao().database;
    return await database.update(
        tableName,
        {
          if (name != null) 'name': name,
          if (scores != null) 'scores': jsonEncode(scores),
          if (sorting != null) 'sorting': sorting,
        },
        where: 'id = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final database = await PlayerDao().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE ID = ?''', [id]);
  }

  Future<void> deleteAll() async {
    final database = await PlayerDao().database;
    await database.rawDelete('''DELETE FROM $tableName''');
  }
}
