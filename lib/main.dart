import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scoreboard/ui/player-add/player-add.dart';
import 'package:scoreboard/score-board-app-state.dart';
import 'package:scoreboard/ui/list/player-list.dart';
import 'package:scoreboard/ui/player-score/player-score.dart';
import 'entity/player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScoreBoardAppState(),
      child: MaterialApp(
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
            return MaterialPageRoute(builder: (_) => PlayerScore(player: player));
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
      ),
    );
  }
}
