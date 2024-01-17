import 'dart:convert';

class Player {
  final int id;
  final String name;
  final List<int> scores;

  const Player({
    required this.id,
    required this.name,
    required this.scores,
  });

  factory Player.fromSqfliteDatabase(Map<String, dynamic> map) {
    return Player(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      scores: new List<int>.from(jsonDecode(map['scores'] ?? '[]')),
    );
  }
}
