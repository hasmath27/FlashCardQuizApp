import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/flashcard.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('flashcards.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        category TEXT NOT NULL DEFAULT 'General',
        createdAt TEXT NOT NULL
      )
    ''');

    // Insert sample flashcards
    final samples = [
      Flashcard(question: 'What is Flutter?', answer: 'Flutter is Google\'s open-source UI toolkit for building natively compiled apps from a single codebase.', category: 'Flutter'),
      Flashcard(question: 'What is Dart?', answer: 'Dart is an object-oriented, class-based programming language used to build Flutter apps.', category: 'Flutter'),
      Flashcard(question: 'What is a Widget in Flutter?', answer: 'Everything in Flutter is a Widget. It is the basic building block of a Flutter app\'s UI.', category: 'Flutter'),
      Flashcard(question: 'What is SQLite?', answer: 'SQLite is a lightweight, self-contained relational database engine used for local data storage in mobile apps.', category: 'Database'),
      Flashcard(question: 'What does CRUD stand for?', answer: 'CRUD stands for Create, Read, Update, and Delete — the four basic operations of persistent storage.', category: 'Database'),
    ];

    for (final card in samples) {
      await db.insert('flashcards', card.toMap());
    }
  }

  Future<int> insertFlashcard(Flashcard card) async {
    final db = await database;
    return await db.insert('flashcards', card.toMap());
  }

  Future<List<Flashcard>> getAllFlashcards() async {
    final db = await database;
    final result = await db.query('flashcards', orderBy: 'createdAt DESC');
    return result.map((map) => Flashcard.fromMap(map)).toList();
  }

  Future<List<Flashcard>> getFlashcardsByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'flashcards',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Flashcard.fromMap(map)).toList();
  }

  Future<List<String>> getCategories() async {
    final db = await database;
    final result = await db.rawQuery('SELECT DISTINCT category FROM flashcards ORDER BY category');
    return result.map((map) => map['category'] as String).toList();
  }

  Future<int> updateFlashcard(Flashcard card) async {
    final db = await database;
    return await db.update(
      'flashcards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<int> deleteFlashcard(int id) async {
    final db = await database;
    return await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getFlashcardCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM flashcards');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}