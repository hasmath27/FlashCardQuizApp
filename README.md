# 📚 FlashCard Quiz App

A clean and simple Flutter flashcard app for studying.

## ✨ Features

- 🃏 Flip card animation — Question on front, Answer on back
- 👁️ "Show Answer" / "Hide Answer" toggle button
- ⬅️➡️ Navigate between cards using **Next** and **Previous** buttons
- ➕ Add new flashcards
- ✏️ Edit existing flashcards
- 🗑️ Delete flashcards
- 🏷️ Category-based filtering (All, Flutter, Database, etc.)
- 🔀 Shuffle cards
- 📊 Progress indicator
- 💾 Local storage using SQLite (`sqflite`)
- 🎨 Clean, modern UI with Google Fonts

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **Local Database:** sqflite (SQLite)
- **Fonts:** Google Fonts (Poppins)

## 📂 Project Structure

```
lib/
├── main.dart
├── models/
│   ├── flashcard.dart
│   └── database_helper.dart
├── providers/
│   └── flashcard_provider.dart
├── screens/
│   ├── all_cards_screen.dart
│   ├── add_edit_screen.dart
│   └── home_screen.dart
└── widgets/
    ├── category_filter.dart
    ├── flashcard_widget.dart
    └── navigation_buttons.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed ([Install Guide](https://docs.flutter.dev/get-started/install))
- Android Studio / VS Code

### Installation

```bash
# Clone the repository
git clone https://github.com/hasmath27/FlashCardQuizApp.git
cd FlashcardQuizApp

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📱 Screenshots
1. Home screen(Question side)
   <img width="200" height="500" alt="1" src="https://github.com/user-attachments/assets/ece6e41b-e130-4c9b-8743-59004198a07f" />



## 📝 How to Use

1. View the flashcard question on the front
2. Tap **"Show Answer"** to flip and reveal the answer
3. Use **Next** / **Previous** buttons to navigate between cards
4. Tap **"Add Card"** (floating button) to create a new flashcard
5. Tap the list icon to view all cards, edit, or delete them
6. Use category tabs to filter flashcards by topic
