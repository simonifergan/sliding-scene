import 'package:equatable/equatable.dart';

class WindmillPuzzle extends Equatable {
  final List<List<int>> groups = [
    [3, 4, 7, 8]
  ];

  @override
  List<Object?> get props => [groups];
}
