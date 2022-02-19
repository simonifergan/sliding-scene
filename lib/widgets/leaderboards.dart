import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/models/leaderboard_entry.dart';
import 'package:sliding_scene/services/leaderboards_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/styles/colors.dart';
import 'package:sliding_scene/styles/responsive_tile_size.dart';
import 'package:sliding_scene/utils/format.dart';

class Leaderboards extends StatefulWidget {
  const Leaderboards(
      {Key? key, this.showText = false, this.child, this.eventController})
      : super(key: key);
  final bool showText;
  final Widget? child;
  final StreamController? eventController;

  @override
  _LeaderboardsState createState() => _LeaderboardsState();
}

class _LeaderboardsState extends State<Leaderboards>
    with TickerProviderStateMixin {
  late OverlayEntry _overlayEntry;
  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;
  final Stream<QuerySnapshot> _leaderboardsStream = LeaderboardsService.instance
      .orderBy("seconds")
      .where("seconds", isGreaterThan: 0)
      .limit(10)
      .snapshots();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _offsetFloat =
        Tween(begin: const Offset(0.0, -5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget tableHeaderTextStyle(text) => Stack(
        alignment: Alignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = ThemeColors.lightBlue),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeColors.darkYellow,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );

  Widget tableCellTextStyle(
    text,
  ) =>
      Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
      );

  void dismissLeaderboards() {
    _controller.reset();
    _overlayEntry.remove();
  }

  Color? getTrophyColor(int index) {
    switch (index) {
      case 0:
        // return Colors.yellow[700];
        return ThemeColors.yellow;
      case 1:
        return Colors.grey[350];
      case 2:
        return Colors.orange[400];
      default:
        return null;
    }
  }

  void showLeaderboards() {
    final tileSize = StoreProvider.of<PuzzleState>(context).state.tileSize;
    _overlayEntry = OverlayEntry(
        builder: (context) => Material(
              type: MaterialType.transparency,
              child: Stack(alignment: Alignment.center, children: [
                Positioned.fill(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: dismissLeaderboards,
                      child: Container(
                        color: ThemeColors.backdrop,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    child: SlideTransition(
                        position: _offsetFloat,
                        child: Container(
                            width: tileSize * 4,
                            height: tileSize < ResponseTileSize.medium
                                ? tileSize * 8
                                : tileSize * 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    ThemeColors.red,
                                    ThemeColors.darkBlue,
                                  ]),
                              color: ThemeColors.darkBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Stack(
                                    children: [
                                      Text(
                                        "Leaderboards",
                                        style: TextStyle(
                                            fontSize: 52,
                                            fontFamily: "MaShanZheng",
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: 3,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 2
                                              ..color = ThemeColors.darkBlue),
                                      ),
                                      Text(
                                        "Leaderboards",
                                        style: TextStyle(
                                            fontSize: 52,
                                            color: ThemeColors.yellow,
                                            fontFamily: "MaShanZheng",
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: 3),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: _leaderboardsStream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError ||
                                            snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                          return Row(
                                            children: const [
                                              Text(
                                                  "Leaderboards unavailable at the moment"),
                                              Icon(
                                                Icons
                                                    .do_not_disturb_alt_outlined,
                                                color: Colors.white,
                                                size: 30,
                                                semanticLabel:
                                                    "Leaderboards button disabled",
                                              ),
                                            ],
                                          );
                                        }

                                        return Table(
                                            border: TableBorder(
                                                horizontalInside: BorderSide(
                                                    width: 1,
                                                    color:
                                                        ThemeColors.lightBlue,
                                                    style: BorderStyle.solid)),
                                            columnWidths: const {
                                              0: FractionColumnWidth(0.0005),
                                              1: FractionColumnWidth(0.35),
                                              2: FractionColumnWidth(0.1),
                                              3: FractionColumnWidth(0.2),
                                              4: FractionColumnWidth(0.3),
                                            },
                                            defaultVerticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            children: [
                                              TableRow(children: [
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                                tableHeaderTextStyle("Player"),
                                                tableHeaderTextStyle("Moves"),
                                                tableHeaderTextStyle("Time"),
                                                tableHeaderTextStyle("Date")
                                              ]),
                                              ...List.generate(
                                                  snapshot.data!.docs.length,
                                                  (index) {
                                                LeaderboardEntry row = snapshot
                                                        .data!.docs[index]
                                                        .data()!
                                                    as LeaderboardEntry;

                                                return TableRow(children: [
                                                  TableCell(
                                                      child: index < 3
                                                          ? SizedBox(
                                                              height: 40,
                                                              child: Icon(
                                                                Icons
                                                                    .emoji_events_rounded,
                                                                size: 30,
                                                                color:
                                                                    getTrophyColor(
                                                                        index),
                                                              ),
                                                            )
                                                          : const SizedBox(
                                                              height: 40,
                                                            )),
                                                  TableCell(
                                                      child: tableCellTextStyle(
                                                          row.name)),
                                                  TableCell(
                                                      child: tableCellTextStyle(
                                                          row.moves
                                                              .toString())),
                                                  TableCell(
                                                    child: tableCellTextStyle(
                                                        FormatTime.formatTime(
                                                            Duration(
                                                                seconds: row
                                                                    .seconds))),
                                                  ),
                                                  TableCell(
                                                      child: tableCellTextStyle(
                                                          FormatTime.formatDate(
                                                              row.timestamp
                                                                  .toLocal()))),
                                                ]);
                                              })
                                            ]);
                                      }),
                                ),
                              ],
                            ))))
              ]),
            ));

    Overlay.of(context)?.insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        _controller.forward();
        showLeaderboards();
      },
      child: widget.child ??
          const Icon(
            Icons.leaderboard_rounded,
            color: Colors.white,
            size: 30,
            semanticLabel: "Show leaderboards button",
          ),
    );
  }
}
