import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scoreboard/db/player-db.dart';
import 'package:scoreboard/di/locator.dart';
import 'package:scoreboard/ui/list/player-list-view-model.dart';
import 'package:scoreboard/ui/list/player-list-widget.dart';
import 'package:scoreboard/ui/player-add/player-add.dart';
import 'package:scoreboard/ui/player-score/player-score-view-model.dart';
import 'package:scoreboard/ui/player-score/player-score-widget.dart';

import 'entity/player.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerListViewModel(playerDB: locator<PlayerDB>())),
        ChangeNotifierProvider(create: (_) => PlayerScoreViewModel(playerDB: locator<PlayerDB>())),
      ],
      child: ScoreBoardApp(),
    ),
  );
}

class ScoreBoardApp extends StatelessWidget {
  const ScoreBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: "Score Board",
      themeMode: ThemeMode.system,
      onGenerateRoute: (settings) {
        if (settings.name == PlayerAdd.routeName) {
          return MaterialPageRoute(builder: (_) => const PlayerAdd());
        } else if (settings.name == PlayerScore.routeName) {
          final player = settings.arguments as Player;
          return MaterialPageRoute(builder: (_) => PlayerScore(playerID: player.id));
        }
        return null; // Let `onUnknownRoute` handle this behavior.
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const PlayerList(title: "Score Board"),
      // ),
    );
  }
}
