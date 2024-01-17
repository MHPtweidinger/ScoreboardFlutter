import 'package:flutter/material.dart';
import 'package:scoreboard/entity/player.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../db/player-db.dart';

class PlayerScore extends StatefulWidget {
  final Player player;

  const PlayerScore({
    required this.player,
    super.key,
  });

  static const routeName = '/player';

  @override
  State<PlayerScore> createState() => _PlayerScoreState();
}

class _PlayerScoreState extends State<PlayerScore> {
  final textEditingController = TextEditingController();
  final playerDB = PlayerDB();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player.name),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: ListView(
              reverse: true,
              children: [
                for (final (index, item) in widget.player.scores.reversed.indexed)
                  ListTile(
                    title: Text((widget.player.scores.length - index).toString()),
                    trailing: Text(
                      item.toString(),
                      textScaler: TextScaler.linear(1.5),
                    ),
                  ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Text(
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        AppLocalizations.of(context)!.currentScore,
                        textAlign: TextAlign.start,
                      ),
                      Expanded(
                        child: Text(
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          widget.player.scores.sum.toString(),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.number,
                controller: textEditingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.newScore,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        var scores = widget.player.scores;
                        scores.add((int.parse(textEditingController.text) * -1));
                        await playerDB.update(id: widget.player.id, name: widget.player.name, scores: widget.player.scores);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "-",
                        textScaler: TextScaler.linear(5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // give it width
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        var scores = widget.player.scores;
                        scores.add(int.parse(textEditingController.text));
                        await playerDB.update(id: widget.player.id, name: widget.player.name, scores: widget.player.scores);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "+",
                        textScaler: TextScaler.linear(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
