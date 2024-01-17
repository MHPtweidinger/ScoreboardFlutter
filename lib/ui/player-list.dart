import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scoreboard/db/player-db.dart';
import 'package:scoreboard/entity/player.dart';
import 'package:scoreboard/score-board-app-state.dart';
import 'package:scoreboard/ui/player-add.dart';
import 'package:scoreboard/ui/player-score.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayerList extends StatefulWidget {
  const PlayerList({super.key, required this.title});

  final String title;

  @override
  State<PlayerList> createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  Future<List<Player>>? futurePlayers;
  final playerDB = PlayerDB();

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  void fetchPlayers() {
    setState(() {
      futurePlayers = playerDB.fetchAll();
    });
  }

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
            tooltip: AppLocalizations.of(context)!.deleteAllUsers,
            onPressed: () async {
              await deletePlayers(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Player>>(
          future: futurePlayers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          for (var player in snapshot.data!)
                            ListTile(
                              title: Text(player.name),
                              trailing: Text(player.scores.sum.toString()),
                              onTap: () async {
                                await Navigator.of(context).pushNamed(PlayerScore.routeName, arguments: player);
                                fetchPlayers();
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(PlayerAdd.routeName);
          fetchPlayers();
        },
        tooltip: AppLocalizations.of(context)!.addPlayer,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> deletePlayers(BuildContext context) async {
    await playerDB.deleteAll();
    fetchPlayers();
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)!.allPlayersDeleted,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
    );
  }
}
