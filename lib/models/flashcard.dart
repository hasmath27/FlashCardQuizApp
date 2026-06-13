class Flashcard {
  int? id;
  String question;
  String answer;
  String category;
  DateTime createdAt;

  Flashcard({
    this.id,
    required this.question,
    required this.answer,
    this.category = 'General',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      question: map['question'],
      answer: map['answer'],
      category: map['category'] ?? 'General',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Flashcard copyWith({
    int? id,
    String? question,
    String? answer,
    String? category,
  }) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      createdAt: createdAt,
    );
  }
}