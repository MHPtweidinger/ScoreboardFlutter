import 'dart:convert';

class Player {
  final int id;
  final int sorting;
  final String name;
  final List<int> scores;

  const Player({
    required this.id,
    required this.name,
    required this.sorting,
    required this.scores,
  });

  factory Player.fromSqfliteDatabase(Map<String, dynamic> map) {
    return Player(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      sorting: map['sorting'] ?? 0,
      scores: new List<int>.from(jsonDecode(map['scores'] ?? '[]')),
    );
  }
}
