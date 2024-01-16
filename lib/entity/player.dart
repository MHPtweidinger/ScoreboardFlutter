class Player {
  final int id;
  final String name;
  final List<int> scores;

  const Player({
    required this.id,
    required this.name,
    required this.scores,
  });

  factory Player.fromSqfliteDatabase(Map<String, dynamic> map) => Player(
        id: map['id']?.toInt() ?? 0,
        name: map['name'] ?? '',
        scores: [], // TODO map this correctly
      );
}
