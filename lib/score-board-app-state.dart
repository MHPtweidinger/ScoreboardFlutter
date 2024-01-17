import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoreboard/entity/player.dart';

class ScoreBoardAppState extends ChangeNotifier {
  var players = <Player>[];

  void clearPlayerScores() {
    for (var element in players) {
      // element.scores = []; // TODO implement this
    }
  }
}
