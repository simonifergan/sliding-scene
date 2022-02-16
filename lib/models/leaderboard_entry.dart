import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardEntry {
  LeaderboardEntry(
      {required this.name,
      required this.moves,
      required this.seconds,
      required this.timestamp});

  LeaderboardEntry.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name']! as String,
          moves: json['moves']! as int,
          seconds: json['seconds']! as int,
          timestamp: json['timestamp']?.toDate(),
        );

  final String name;
  final int moves;
  final int seconds;
  final DateTime timestamp;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'moves': moves,
      'seconds': seconds,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
