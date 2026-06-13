import 'package:flutter/foundation.dart';
import '../models/flashcard.dart';
import '../models/database_helper.dart';

class FlashcardProvider extends ChangeNotifier {
  List<Flashcard> _flashcards = [];
  int _currentIndex = 0;
  bool _isAnswerVisible = false;
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];
  bool _isLoading = true;

  List<Flashcard> get flashcards => _flashcards;
  int get currentIndex => _currentIndex;
  bool get isAnswerVisible => _isAnswerVisible;
  String get selectedCategory => _selectedCategory;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;

  Flashcard? get currentCard =>
      _flashcards.isEmpty ? null : _flashcards[_currentIndex];

  int get totalCards => _flashcards.length;
  bool get hasPrevious => _currentIndex > 0;
  bool get hasNext => _currentIndex < _flashcards.length - 1;

  FlashcardProvider() {
    loadFlashcards();
  }

  Future<void> loadFlashcards() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_selectedCategory == 'All') {
        _flashcards = await DatabaseHelper.instance.getAllFlashcards();
      } else {
        _flashcards = await DatabaseHelper.instance
            .getFlashcardsByCategory(_selectedCategory);
      }

      final cats = await DatabaseHelper.instance.getCategories();
      _categories = ['All', ...cats];

      if (_currentIndex >= _flashcards.length) {
        _currentIndex = _flashcards.isEmpty ? 0 : _flashcards.length - 1;
      }
      _isAnswerVisible = false;
    } catch (e) {
      debugPrint('Error loading flashcards: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void showAnswer() {
    _isAnswerVisible = true;
    notifyListeners();
  }

  void hideAnswer() {
    _isAnswerVisible = false;
    notifyListeners();
  }

  void toggleAnswer() {
    _isAnswerVisible = !_isAnswerVisible;
    notifyListeners();
  }

  void nextCard() {
    if (hasNext) {
      _currentIndex++;
      _isAnswerVisible = false;
      notifyListeners();
    }
  }

  void previousCard() {
    if (hasPrevious) {
      _currentIndex--;
      _isAnswerVisible = false;
      notifyListeners();
    }
  }

  void goToCard(int index) {
    if (index >= 0 && index < _flashcards.length) {
      _currentIndex = index;
      _isAnswerVisible = false;
      notifyListeners();
    }
  }

  void shuffleCards() {
    _flashcards.shuffle();
    _currentIndex = 0;
    _isAnswerVisible = false;
    notifyListeners();
  }

  Future<void> setCategory(String category) async {
    _selectedCategory = category;
    _currentIndex = 0;
    _isAnswerVisible = false;
    await loadFlashcards();
  }

  Future<void> addFlashcard(Flashcard card) async {
    await DatabaseHelper.instance.insertFlashcard(card);
    await loadFlashcards();
  }

  Future<void> updateFlashcard(Flashcard card) async {
    await DatabaseHelper.instance.updateFlashcard(card);
    await loadFlashcards();
  }

  Future<void> deleteFlashcard(int id) async {
    await DatabaseHelper.instance.deleteFlashcard(id);
    if (_currentIndex >= _flashcards.length - 1 && _currentIndex > 0) {
      _currentIndex--;
    }
    await loadFlashcards();
  }
}