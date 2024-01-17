import 'package:get_it/get_it.dart';
import 'package:scoreboard/db/player-db.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory<PlayerDB>(() => PlayerDB());
}
