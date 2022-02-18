import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/models/leaderboard_entry.dart';
import 'package:sliding_scene/services/leaderboards_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/styles/colors.dart';

class GameCompletionDialog extends StatefulWidget {
  const GameCompletionDialog({Key? key}) : super(key: key);

  @override
  _GameCompletionDialogState createState() => _GameCompletionDialogState();
}

class _GameCompletionDialogState extends State<GameCompletionDialog> {
  final _textEditingController = TextEditingController();
  final _keyDialogForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = "";
  }

  Future<void> onSubmitDialog() async {
    final state = StoreProvider.of<PuzzleState>(context).state;
    final moves = state.moves;
    final seconds = state.secondsElpased.inSeconds;
    final name = _textEditingController.text;

    await LeaderboardsService.instance.add(LeaderboardEntry(
        name: name, moves: moves, seconds: seconds, timestamp: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(
          Duration.zero,
          () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: ThemeColors.darkBlue,
                  title: Form(
                    key: _keyDialogForm,
                    child: Column(
                      children: [
                        TextFormField(
                          style: TextStyle(color: ThemeColors.lightBlue),
                          decoration: InputDecoration(
                            fillColor: ThemeColors.lightBlue,
                            icon: Icon(
                              Icons.tag_faces_rounded,
                              color: ThemeColors.lightBlue,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (val) {
                            _textEditingController.text = val;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Your Name';
                            }

                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        onSubmitDialog();
                        Navigator.pop(context);
                      },
                      child: const Text('Submit'),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                  ],
                );
              })),
      builder: (context, _) => const SizedBox(),
    );
  }
}
