import 'models/level_model.dart';

class LevelData {
  static List<Level> levels = [
    Level(
      id: 1,
      text: "I ___ apples.",
      blanks: 1,
      options: ["like", "likes", "liking"],
      answers: ["like"],
    ),
    Level(
      id: 2,
      text: "She ___ to school every day.",
      blanks: 1,
      options: ["go", "goes", "going"],
      answers: ["goes"],
    ),
    Level(
      id: 3,
      text: "They ___ playing football in the park.",
      blanks: 1,
      options: ["am", "is", "are"],
      answers: ["are"],
    ),
    Level(
      id: 10,
      text: "She ___ to school ___ the morning.",
      blanks: 2,
      options: ["goes", "go", "in", "at"],
      answers: ["goes", "in"],
    ),
    Level(
      id: 20,
      text: "If I ___ you, I ___ that job.",
      blanks: 2,
      options: ["was", "were", "would take", "will take"],
      answers: ["were", "would take"],
    ),
    Level(
      id: 40,
      text: "The book ___ I was reading ___ very interesting.",
      blanks: 2,
      options: ["who", "which", "was", "were"],
      answers: ["which", "was"],
    ),
    Level(
      id: 60,
      text: "Technology has ___ the way we communicate. ___ people used to write letters, they now send instant messages. This shift has made stay in touch ___ easier.",
      blanks: 3,
      options: ["changed", "changing", "While", "Because", "much", "more"],
      answers: ["changed", "While", "much"],
    ),
  ];

  static Level getLevel(int id) {
    return levels.firstWhere((element) => element.id == id, orElse: () => levels.first);
  }
}
