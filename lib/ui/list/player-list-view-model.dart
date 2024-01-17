import 'package:flutter/cupertino.dart';
import '../../db/player-db.dart';
import '../../entity/player.dart';

class PlayerListViewModel extends ChangeNotifier {
  final PlayerDB playerDB;

  PlayerListViewModel({required this.playerDB});

  List<Player> _players = [];

  List<Player> get players => _players;

  fetch() async {
    _players = await playerDB.fetchAll();
    notifyListeners();
  }

  onDeleteAllPlayers() async {
    await playerDB.deleteAll();
    await fetch();
  }

  onClearScores() async {
    _players.forEach((element) async {
      await playerDB.update(id: element.id, name: element.name, scores: []);
    });
    await fetch();
  }
}
