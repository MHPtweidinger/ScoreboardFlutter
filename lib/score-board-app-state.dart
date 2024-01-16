import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoreboard/entity/player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      element.scores = [];
    }
  }

  void deleteAllPlayers(BuildContext context) {
    players.clear();
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)!.allPlayersDeleted,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      // backgroundColor: Colors.red,
      // textColor: Colors.white,
      // fontSize: 16.0
    );
  }
}
