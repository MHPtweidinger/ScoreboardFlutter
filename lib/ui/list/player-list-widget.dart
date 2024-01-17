import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scoreboard/ui/list/player-list-view-model.dart';
import 'package:scoreboard/ui/player-add/player-add.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../player-score/player-score-widget.dart';

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
      builder: (_, viewModel, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.eraser_14),
              tooltip: 'Clear All Scores',
              onPressed: () {
                _showClearAllScoresDialog();
              },
            ),
            IconButton(
              icon: const Icon(Iconsax.grid_eraser5),
              tooltip: AppLocalizations.of(context)!.deleteAllUsers,
              onPressed: () async {
                await _showDeleteAllUsersDialog();
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
                  onReorder: (int oldIndex, int newIndex) async {
                    late int targetIndex;
                    if (oldIndex < newIndex) {
                      targetIndex = newIndex - 1;
                    } else {
                      targetIndex = newIndex;
                    }
                    ;
                    await viewModel.changeOrder(oldIndex, targetIndex);
                  },
                  children: [
                    for (var player in viewModel.players)
                      ListTile(
                        key: Key('${player.sorting}${player.id}'),
                        title: Text(player.name),
                        trailing: Text(player.scores.sum.toString()),
                        onTap: () async {
                          await Navigator.of(context).pushNamed(PlayerScore.routeName, arguments: player);
                          viewModel.fetch();
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
            viewModel.fetch();
          },
          tooltip: AppLocalizations.of(context)!.addPlayer,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showClearAllScoresDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.clearScoresDialogTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.clearScoresDialogMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(AppLocalizations.of(context)!.clearScoresDialogDiscard),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text(AppLocalizations.of(context)!.clearScoresDialogSubmit),
              onPressed: () {
                viewModel.onClearScores();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteAllUsersDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.wipePlayersDialogTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.wipePlayersDialogMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(AppLocalizations.of(context)!.wipePlayersDialogDiscard),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text(AppLocalizations.of(context)!.wipePlayersDialogSubmit),
              onPressed: () {
                viewModel.onDeleteAllPlayers();
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.allPlayersDeleted,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
