class Level {
  final int id;
  final String text;
  final int blanks;
  final List<String> options;
  final List<String> answers;

  Level({
    required this.id,
    required this.text,
    required this.blanks,
    required this.options,
    required this.answers,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['level'] as int,
      text: json['text'] as String,
      blanks: json['blanks'] as int,
      options: List<String>.from(json['options'] as List),
      answers: List<String>.from(json['answers'] as List),
    );
  }
}
