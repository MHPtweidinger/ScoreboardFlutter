import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scoreboard/ui/list/player-list-view-model.dart';
import 'package:scoreboard/ui/player-add/player-add.dart';
import 'package:scoreboard/ui/player-score/player-score.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayerList extends StatefulWidget {
  const PlayerList({super.key, required this.title});

  final String title;

  @override
  State<PlayerList> createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  late PlayerListViewModel viewModel;

  @override
  void initState() {
    viewModel = Provider.of<PlayerListViewModel>(context, listen: false);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      viewModel.fetch();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerListViewModel>(
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.eraser_14),
              tooltip: 'Clear All Scores',
              onPressed: () {
                model.onClearScores();
              },
            ),
            IconButton(
              icon: const Icon(Iconsax.grid_eraser5),
              tooltip: AppLocalizations.of(context)!.deleteAllUsers,
              onPressed: () async {
                await model.onDeleteAllPlayers();
                Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.allPlayersDeleted,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                );
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
                child: ReorderableListView(
                  onReorder: (int oldIndex, int newIndex) {  },
                  children: [
                    for (var player in model.players)
                      ListTile(
                        key: Key('${player.id}'),
                        title: Text(player.name),
                        trailing: Text(player.scores.sum.toString()),
                        onTap: () async {
                          await Navigator.of(context).pushNamed(PlayerScore.routeName, arguments: player);
                          model.fetch();
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
            await Navigator.of(context).pushNamed(PlayerAdd.routeName);
            model.fetch();
          },
          tooltip: AppLocalizations.of(context)!.addPlayer,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
