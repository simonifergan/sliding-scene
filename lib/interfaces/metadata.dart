import 'package:equatable/equatable.dart';

typedef AnimationGroups = List<List<int>>;

class PuzzleMetadata extends Equatable {
  const PuzzleMetadata({required this.animationGroups});

  final AnimationGroups animationGroups;

  @override
  List<Object?> get props => [animationGroups];
}
