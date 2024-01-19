import 'dart:async';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoreboard/ui/player-score/player-state-view-state.dart';

import '../../db/player-db.dart';
import '../../entity/player.dart';

class PlayerScoreViewModel {
  final PlayerDB playerDB;

  final _inputObservable = BehaviorSubject<String>();

  PlayerScoreViewModel({required this.playerDB}) {
    _inputObservable.value = "";
  }

  final _playerObservable = BehaviorSubject<Player>();

  Stream<ViewState> get viewState => Rx.combineLatest2(
        _playerObservable.stream,
        _inputObservable.stream,
        (player, input) => ScoreViewState(
          name: player.name,
          buttonsEnabled: input.isNotEmpty,
          sum: player.scores.sum,
          scores: player.scores,
        ),
      );

  bool buttonsEnabled = false;

  fetch(int id) async {
    var player = await playerDB.fetchById(id);
    _playerObservable.value = player;
  }

  updateScore(int newScore) async {
    var updatedScores = _playerObservable.value.scores;
    updatedScores.add(newScore);
    await playerDB.update(
      id: _playerObservable.value.id,
      name: _playerObservable.value.name,
      scores: updatedScores,
    );
  }

  onInputChanged(String input) {
    _inputObservable.value = input;
    buttonsEnabled = (input.isNotEmpty) ? true : false;
  }
}
