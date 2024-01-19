import 'package:flutter/src/widgets/dismissible.dart';
import 'package:rxdart/rxdart.dart';

import '../../db/player-db.dart';
import '../../entity/player.dart';

class PlayerListViewModel {
  final PlayerDB playerDB;

  PlayerListViewModel({required this.playerDB});

  final BehaviorSubject<List<Player>> _playerListObservable = BehaviorSubject<List<Player>>();

  Stream<List<Player>> get playerList {
    return _playerListObservable.stream;
  }

  fetch() async {
    _playerListObservable.value = await playerDB.fetchAll();
  }

  onDeleteAllPlayers() async {
    await playerDB.deleteAll();
    await fetch();
  }

  onClearScores() async {
    _playerListObservable.value.forEach((element) async {
      await playerDB.update(id: element.id, scores: []);
    });
    await fetch();
  }

  changeOrder(int oldIndex, int newIndex) async {
    List<Player> sortedPlayers = _playerListObservable.value;
    Player item = sortedPlayers.elementAt(oldIndex);
    sortedPlayers.remove(item);
    sortedPlayers.insert(newIndex, item);
    _playerListObservable.value = sortedPlayers;

    for (final (index, item) in sortedPlayers.indexed) {
      await playerDB.update(id: item.id, sorting: index);
    }
    await fetch();
  }

  onItemDismissed(int id) {
    playerDB.delete(id);
    fetch();
  }
}
