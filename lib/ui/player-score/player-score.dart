import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scoreboard/ui/player-score/player-score-view-model.dart';

class PlayerScore extends StatefulWidget {
  final int playerID;

  const PlayerScore({
    required this.playerID,
    super.key,
  });

  static const routeName = '/player';

  @override
  State<PlayerScore> createState() => _PlayerScoreState();
}

class _PlayerScoreState extends State<PlayerScore> {
  late PlayerScoreViewModel viewModel;

  final textEditingController = TextEditingController();

  @override
  void initState() {
    viewModel = Provider.of<PlayerScoreViewModel>(context, listen: false);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      viewModel.fetch(widget.playerID);
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerScoreViewModel>(
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(model.player!.name),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                reverse: true,
                children: [
                  for (final (index, item) in model.player!.scores.reversed.indexed)
                    ListTile(
                      title: Text((model.player!.scores.length - index).toString()),
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
                            model.player!.scores.sum.toString(),
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
                          await model.updateScore(int.parse(textEditingController.text) * -1);
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
                          await model.updateScore(int.parse(textEditingController.text));
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
      ),
    );
  }
}
