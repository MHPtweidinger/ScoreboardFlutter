import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../db/player-db.dart';

class PlayerAdd extends StatefulWidget {
  const PlayerAdd({super.key});

  static const routeName = '/player-add';

  @override
  State<PlayerAdd> createState() => _PlayerAddState();
}

class _PlayerAddState extends State<PlayerAdd> {
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
        title: Text(AppLocalizations.of(context)!.addPlayer),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                onFieldSubmitted: (text) async {
                  await playerDB.create(name: textEditingController.text);
                  Navigator.pop(context);
                },
                autofocus: true,
                controller: textEditingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.playerName,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await playerDB.create(name: textEditingController.text);
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.submit),
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
