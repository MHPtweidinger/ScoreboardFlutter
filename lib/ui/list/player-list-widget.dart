import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:scoreboard/ui/list/player-list-view-model.dart';
import 'package:scoreboard/ui/player-add/player-add.dart';

import '../../di/locator.dart';
import '../../entity/player.dart';
import '../player-score/player-score-widget.dart';

class PlayerList extends StatefulWidget {
  const PlayerList({super.key});

  @override
  State<PlayerList> createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  late PlayerListViewModel _viewModel;

  @override
  void initState() {
    _viewModel = locator<PlayerListViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetch();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.appName),
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
      body: StreamBuilder<List<Player>>(
        stream: _viewModel.playerList,
        builder: (context, state) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ReorderableListView(
                  scrollController: scrollController,
                  onReorder: (int oldIndex, int newIndex) async {
                    int targetIndex = (oldIndex < newIndex) ? newIndex - 1 : newIndex;
                    await _viewModel.changeOrder(oldIndex, targetIndex);
                  },
                  children: [
                    if (state.data != null)
                      for (var player in state.data!)
                        ListTile(
                          key: Key('${player.id}'),
                          title: Text(player.name),
                          trailing: Text(player.scores.sum.toString()),
                          onTap: () async {
                            await Navigator.of(context).pushNamed(PlayerScore.routeName, arguments: player);
                            _viewModel.fetch();
                          },
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(PlayerAdd.routeName);
          _viewModel.fetch();
        },
        tooltip: AppLocalizations.of(context)!.addPlayer,
        child: const Icon(Icons.add),
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
                _viewModel.onClearScores();
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
                _viewModel.onDeleteAllPlayers();
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
