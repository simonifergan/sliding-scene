import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliding_scene/models/leaderboard_entry.dart';
import 'package:sliding_scene/services/leaderboards_service.dart';
import 'package:sliding_scene/styles/colors.dart';
import 'package:sliding_scene/utils/format.dart';

class Leaderboards extends StatefulWidget {
  const Leaderboards({Key? key}) : super(key: key);

  static get tag => "leaderboards";

  @override
  _LeaderboardsState createState() => _LeaderboardsState();
}

class _LeaderboardsState extends State<Leaderboards> {
  final Stream<QuerySnapshot> _leaderboardsStream =
      LeaderboardsService.instance.orderBy("seconds").limit(10).snapshots();

  Widget tableHeaderTextStyle(text) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ThemeColors.darkBlue,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontStyle: FontStyle.italic,
        ),
      );

  Widget tableCellTextStyle(text) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: ThemeColors.darkBlue,
            fontSize: 16,
            fontStyle: FontStyle.italic),
      );

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

        return Card(
          color: ThemeColors.lightBlue,
          shadowColor: ThemeColors.lightBlue,
          elevation: 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Leaderboards",
                  style: TextStyle(
                      color: ThemeColors.yellow,
                      fontSize: 40,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 2,
                      fontFamily: "MaShanZheng"),
                ),
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FractionColumnWidth(0.3),
                  1: FractionColumnWidth(0.2),
                  2: FractionColumnWidth(0.2),
                  3: FractionColumnWidth(0.3),
                  4: FractionColumnWidth(0)
                },
                border: TableBorder(
                    horizontalInside: BorderSide(
                        color: ThemeColors.darkYellow,
                        width: 1,
                        style: BorderStyle.solid)),
                textBaseline: TextBaseline.alphabetic,
                children: [
                  TableRow(children: [
                    tableHeaderTextStyle("Player"),
                    tableHeaderTextStyle("Moves"),
                    tableHeaderTextStyle("Time"),
                    tableHeaderTextStyle("Date"),
                    const SizedBox(height: 30),
                  ]),
                  ...snapshot.data!.docs.map((DocumentSnapshot document) {
                    LeaderboardEntry data =
                        document.data()! as LeaderboardEntry;
                    return TableRow(
                      children: [
                        tableCellTextStyle(data.name),
                        tableCellTextStyle(data.moves.toString()),
                        tableCellTextStyle(FormatTime.formatTime(
                            Duration(seconds: data.seconds))),
                        tableCellTextStyle(
                            FormatTime.formatDate(data.timestamp.toLocal())),
                        const SizedBox(height: 50),
                      ],
                    );
                  }).toList()
                ],
              ),
            ],
          ),
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
