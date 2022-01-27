import 'package:equatable/equatable.dart';
import 'package:hackathon_slide_puzzle/interfaces/position.dart';

class Tile extends Equatable {
  const Tile({
    required this.position,
    required this.currentPosition,
    required this.number,
    this.isWhitespace = false,
  });

  final Position position;
  final Position currentPosition;
  final int number;
  final bool isWhitespace;

  Tile clone({required Position nextPosition}) {
    return Tile(
      position: position,
      currentPosition: nextPosition,
      number: number,
      isWhitespace: isWhitespace,
    );
  }

  @override
  List<Object?> get props => [position, currentPosition, number, isWhitespace];
}
