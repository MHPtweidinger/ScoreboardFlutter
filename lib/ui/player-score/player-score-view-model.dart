import 'package:flutter/foundation.dart';
import '../../db/player-db.dart';
import '../../entity/player.dart';

class PlayerScoreViewModel extends ChangeNotifier {
  final PlayerDB playerDB;

  Player? _player;

  Player? get player => _player;

  fetch(int id) async {
    _player = await playerDB.fetchById(id);
    notifyListeners();
  }

  PlayerScoreViewModel({required this.playerDB});

  updateScore(int newScore) async {
    if (_player != null) {
      var updatedScores = _player!.scores;
      updatedScores.add(newScore);
      await playerDB.update(id: _player!.id, name: _player!.name, scores: updatedScores);
    }
  }
}
