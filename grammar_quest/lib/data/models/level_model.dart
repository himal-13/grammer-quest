enum LevelType { paragraph, sentence }

class Level {
  final int id;
  final String title;
  final String paragraph; // Full paragraph with ___ placeholders
  final int blanks;
  final List<String> options;
  final List<String> answers;
  final String contextHint; // Optional hint about the paragraph
  final LevelType type;

  Level({
    required this.id,
    required this.title,
    required this.paragraph,
    required this.blanks,
    required this.options,
    required this.answers,
    this.contextHint = '',
    this.type = LevelType.paragraph,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['level'] as int,
      title: json['title'] as String? ?? 'Level ${json['level']}',
      paragraph: json['paragraph'] as String,
      blanks: json['blanks'] as int,
      options: List<String>.from(json['options'] as List),
      answers: List<String>.from(json['answers'] as List),
      contextHint: json['contextHint'] as String? ?? '',
      type: json['type'] == 'sentence' ? LevelType.sentence : LevelType.paragraph,
    );
  }
}