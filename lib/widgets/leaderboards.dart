import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliding_scene/models/leaderboard_entry.dart';
import 'package:sliding_scene/utils/format_time.dart';

const notAvailable = "N/A";

class Leaderboards extends StatefulWidget {
  const Leaderboards({Key? key}) : super(key: key);

  @override
  _LeaderboardsState createState() => _LeaderboardsState();
}

class _LeaderboardsState extends State<Leaderboards> {
  final Stream<QuerySnapshot> _leaderboardsStream = FirebaseFirestore.instance
      .collection('leaderboards')
      .withConverter<LeaderboardEntry>(
          fromFirestore: (snapshot, _) =>
              LeaderboardEntry.fromJson(snapshot.data()!),
          toFirestore: (entry, _) => entry.toJson())
      .snapshots();
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
            print(data);
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
