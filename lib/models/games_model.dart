import 'dart:convert';

class GameModel {
  final List<Game> games;
  GameModel({
    required this.games,
  });

  Map<String, dynamic> toMap() {
    return {
      'games': games.map((x) => x.toMap()).toList(),
    };
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      games: List<Game>.from(map['games']?.map((x) => Game.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameModel.fromJson(String source) => GameModel.fromMap(json.decode(source));

  GameModel copyWith({
    List<Game>? games,
  }) {
    return GameModel(
      games: games ?? this.games,
    );
  }
}

class Game {
  final int id;
  final String player1;
  final String player2;
  final int position;
  final int status;
  final int turn;
  Game({
    required this.id,
    required this.player1,
    required this.player2,
    required this.position,
    required this.status,
    required this.turn,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'player1': player1,
      'player2': player2,
      'position': position,
      'status': status,
      'turn': turn,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id']?.toInt() ?? 0,
      player1: map['player1'] ?? '',
      player2: map['player2'] ?? '',
      position: map['position']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
      turn: map['turn']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Game.fromJson(String source) => Game.fromMap(json.decode(source));

  @override
  String toString() => '$id $player1 vs $player2';
}