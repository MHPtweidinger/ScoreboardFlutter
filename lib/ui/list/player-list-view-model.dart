import 'package:rxdart/rxdart.dart';

import '../../db/player-db.dart';
import '../../entity/player.dart';

class PlayerListViewModel {
  final PlayerDB playerDB;

  PlayerListViewModel({required this.playerDB});

  final _playerListObservable = BehaviorSubject<List<Player>>();

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
    var oldItem = _playerListObservable.value.firstWhere((element) => element.sorting == oldIndex);
    var newItem = _playerListObservable.value.firstWhere((element) => element.sorting == newIndex);

    await playerDB.update(id: oldItem.id, sorting: newIndex);
    await playerDB.update(id: newItem.id, sorting: oldIndex);
    await fetch();
  }
}
