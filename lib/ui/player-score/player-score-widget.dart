import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scoreboard/ui/player-score/player-score-view-model.dart';
import 'package:scoreboard/ui/player-score/player-state-view-state.dart';

import '../../di/locator.dart';

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
  late PlayerScoreViewModel _viewModel;

  final _textEditingController = TextEditingController();

  @override
  void initState() {
    _viewModel = locator<PlayerScoreViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetch(widget.playerID);
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ViewState>(
      stream: _viewModel.viewState,
      builder: (context, state) => switch (state.data) {
        LoadingViewState() => Text("Loading"),
        ScoreViewState(
          name: var name,
          scores: var scores,
        ) =>
          _playerScoreWidget(name, scores, context),
        null => Expanded(child: Spacer()),
      },
    );
  }

  Widget _playerScoreWidget(String name, List<int> scores, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollStartNotification && scrollNotification.metrics.axisDirection == AxisDirection.up) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                  return true;
                },
                child: ListView(
                  reverse: true,
                  children: [
                    for (final (index, item) in scores.reversed.indexed)
                      ListTile(
                        title: Text((scores.length - index).toString()),
                        trailing: Text(
                          item.toString(),
                          textScaler: TextScaler.linear(1.5),
                        ),
                      ),
                  ],
                ),
              ),
            ),
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
                          scores.sum.toString(),
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
                onChanged: (text) {
                  _viewModel.onInputChanged(text);
                },
                keyboardType: TextInputType.number,
                controller: _textEditingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.newScore,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _submitButtons(viewModel: _viewModel, textEditingController: _textEditingController),
            ),
          ],
        ),
      ),
    );
  }
}

class _submitButtons extends StatelessWidget {
  const _submitButtons({
    super.key,
    required PlayerScoreViewModel viewModel,
    required TextEditingController textEditingController,
  })  : _viewModel = viewModel,
        _textEditingController = textEditingController;

  final PlayerScoreViewModel _viewModel;
  final TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _viewModel.buttonsEnabled
                ? () async {
                    await _viewModel.updateScore(int.parse(_textEditingController.text) * -1);
                    Navigator.pop(context);
                  }
                : null,
            child: const Text(
              "-",
              textScaler: TextScaler.linear(5),
            ),
          ),
        ),
        const SizedBox(width: 20), // give it width
        Expanded(
          child: ElevatedButton(
            onPressed: _viewModel.buttonsEnabled
                ? () async {
                    await _viewModel.updateScore(int.parse(_textEditingController.text));
                    Navigator.pop(context);
                  }
                : null,
            child: const Text(
              "+",
              textScaler: TextScaler.linear(5),
            ),
          ),
        ),
      ],
    );
  }
}
