import 'dart:convert';

class SetGameResponse {
  final int id;
  final bool matched;
  final int player;
  SetGameResponse({
    required this.id,
    required this.matched,
    required this.player,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'matched': matched,
      'player': player,
    };
  }

  factory SetGameResponse.fromMap(Map<String, dynamic> map) {
    return SetGameResponse(
      id: map['id']?.toInt() ?? 0,
      matched: map['matched'] ?? false,
      player: map['player']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SetGameResponse.fromJson(String source) => SetGameResponse.fromMap(json.decode(source));

  @override
  String toString() => 'SetGameResponse(id: $id, matched: $matched, player: $player)';
}