import 'dart:convert';

class PlaceShotResponse {
  final String message;
  final bool sunkShip;
  final bool won;
  PlaceShotResponse({
    required this.message,
    required this.sunkShip,
    required this.won,
  });



  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'sunk_ship': sunkShip,
      'won': won,
    };
  }

  factory PlaceShotResponse.fromMap(Map<String, dynamic> map) {
    return PlaceShotResponse(
      message: map['message'] ?? '',
      sunkShip: map['sunk_ship'] ?? false,
      won: map['won'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceShotResponse.fromJson(String source) => PlaceShotResponse.fromMap(json.decode(source));

  @override
  String toString() => message;

}