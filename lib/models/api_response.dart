import 'package:pokedex/models/character.dart';

class ApiResponse {
  final Info info;
  final List<Character> results;

  ApiResponse({
    required this.info,
    required this.results,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      info: Info.fromJson(json['info']),
      results: List<Character>.from(
        json['results'].map((x) => Character.fromJson(x)),
      ),
    );
  }
}

class Info {
  final int count;
  final int pages;
  final String next;
  final String? prev;

  Info({
    required this.count,
    required this.pages,
    required this.next,
    this.prev,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      count: json['count'],
      pages: json['pages'],
      next: json['next'] ?? '',
      prev: json['prev'],
    );
  }
}


