import 'package:equatable/equatable.dart';

typedef AnimationGroup = List<int>;

typedef AnimationGroups = List<AnimationGroup>;

class PuzzleMetadata extends Equatable {
  const PuzzleMetadata({required this.animationGroups});

  final AnimationGroups animationGroups;

  @override
  List<Object?> get props => [animationGroups];
}
