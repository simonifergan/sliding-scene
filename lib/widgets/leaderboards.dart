import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliding_scene/models/leaderboard_entry.dart';
import 'package:sliding_scene/services/leaderboards_service.dart';
import 'package:sliding_scene/utils/format_time.dart';

const notAvailable = "N/A";

class Leaderboards extends StatefulWidget {
  const Leaderboards({Key? key}) : super(key: key);

  static get tag => "leaderboards";

  @override
  _LeaderboardsState createState() => _LeaderboardsState();
}

class _LeaderboardsState extends State<Leaderboards> {
  final Stream<QuerySnapshot> _leaderboardsStream =
      LeaderboardsService.instance.snapshots();
  @override
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _leaderboardsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return Table(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            LeaderboardEntry data = document.data()! as LeaderboardEntry;
            return TableRow(
              children: [
                Text(data.name),
                Text(data.moves.toString()),
                Text(FormatTime.formatTime(Duration(seconds: data.seconds)))
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

class LeaderboardsButton extends StatelessWidget {
  const LeaderboardsButton({Key? key, required this.button}) : super(key: key);
  final Widget button;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
