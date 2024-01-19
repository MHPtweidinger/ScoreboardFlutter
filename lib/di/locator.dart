import 'package:get_it/get_it.dart';
import 'package:scoreboard/db/player-db.dart';

import '../ui/list/player-list-view-model.dart';
import '../ui/player-score/player-score-view-model.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory<PlayerDB>(() => PlayerDB());
  locator.registerFactory<PlayerScoreViewModel>(() => PlayerScoreViewModel(playerDB: locator<PlayerDB>()));
  locator.registerFactory<PlayerListViewModel>(() => PlayerListViewModel(playerDB: locator<PlayerDB>()));
}
