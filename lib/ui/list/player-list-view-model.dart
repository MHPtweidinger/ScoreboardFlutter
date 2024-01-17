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
      await playerDB.update(id: element.id, scores: []);
    });
    await fetch();
  }

  changeOrder(int oldIndex, int newIndex) async {
    var oldItem = _players.firstWhere((element) => element.sorting == oldIndex);
    var newItem = _players.firstWhere((element) => element.sorting == newIndex);

    await playerDB.update(id: oldItem.id, sorting: newIndex);
    await playerDB.update(id: newItem.id, sorting: oldIndex);
    await fetch();
  }
}
