import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import 'package:scoreboard/entity/player.dart';
import 'package:scoreboard/score-board-app-state.dart';
import 'package:scoreboard/ui/player-add.dart';
import 'package:scoreboard/ui/player-score.dart';
import 'package:uuid/uuid.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayerList extends StatefulWidget {
  const PlayerList({super.key, required this.title});

  final String title;

  @override
  State<PlayerList> createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ScoreBoardAppState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.eraser_14),
            tooltip: 'Clear All Scores',
            onPressed: () {
              setState(() {
                appState.clearPlayerScores();
              });
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.grid_eraser5),
            tooltip:  AppLocalizations.of(context)!.deleteAllUsers,
            onPressed: () {
              setState(() {
                appState.deleteAllPlayers(context);
              });
            },
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  for (var player in appState.players)
                    ListTile(
                      title: Text(player.name),
                      trailing: Text(player.scores.sum.toString()),
                      onTap: () async {
                        final result = await Navigator.of(context).pushNamed(PlayerScore.routeName, arguments: player);
                        setState(() {
                          appState.updatePlayerScore(player, int.parse(result as String));
                        });
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed(PlayerAdd.routeName);
          setState(() {
            appState.addPlayer(Player(const Uuid().v1(), result as String, []));
          });
        },
        tooltip: AppLocalizations.of(context)!.addPlayer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
