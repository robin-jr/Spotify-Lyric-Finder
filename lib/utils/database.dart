import 'package:spotify_lyric_finder/models/lyric.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';

Future<Lyrics?> getLyricsFromDatabase(String query) async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps =
      await db.query('lyrics', where: "query = ?", whereArgs: [query]);
  if (maps.isEmpty) {
    return null;
  }
  return Lyrics(query, maps[0]['url'], maps[0]['lyrics']);
}

Future<void> insertLyrics(Lyrics lyrics) async {
  final Database db = await database;

  await db.insert(
    'lyrics',
    lyrics.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

//for debugging
Future<List<Lyrics>> allLyrics() async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query('lyrics');
  return List.generate(maps.length, (i) {
    return Lyrics(
      maps[i]['query'],
      maps[i]['url'],
      maps[i]['lyrics'],
    );
  });
}
