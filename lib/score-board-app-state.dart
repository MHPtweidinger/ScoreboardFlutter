import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoreboard/entity/player.dart';

class ScoreBoardAppState extends ChangeNotifier {
  var players = <Player>[];

  void addPlayer(Player player) {
    players.add(player);
    notifyListeners();
  }

  void updatePlayerScore(Player player, int score) {
    player.scores.add(score);
    players[players.indexWhere((element) => element.id == player.id)] = player;
    notifyListeners();
  }

  void clearPlayerScores() {
    for (var element in players) {
      // element.scores = []; // TODO implement this
    }
  }
}
