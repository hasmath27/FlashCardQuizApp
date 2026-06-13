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
1. Home screen (Question side)
   <img width="720" height="1456" alt="1" src="https://github.com/user-attachments/assets/f13700f8-18ec-47bd-8a90-f7d94efdeb20" />

2. Home screen (Answer side)
   <img width="720" height="1456" alt="2" src="https://github.com/user-attachments/assets/a6c23657-7ec8-4c6e-89e1-f9e712e35e41" />

3. Add/Edit screen
   <img width="716" height="1456" alt="3" src="https://github.com/user-attachments/assets/2a928190-2929-45dd-9984-9187982ebdce" />

4. All Cards screen
   <img width="716" height="1460" alt="4" src="https://github.com/user-attachments/assets/288b8168-980b-4f4e-bb89-c8bbe9740296" />

5. Empty state
   <img width="716" height="1456" alt="5" src="https://github.com/user-attachments/assets/5963f1fc-d9a1-4647-b272-c678d9964149" />


## 📝 How to Use

1. View the flashcard question on the front
2. Tap **"Show Answer"** to flip and reveal the answer
3. Use **Next** / **Previous** buttons to navigate between cards
4. Tap **"Add Card"** (floating button) to create a new flashcard
5. Tap the list icon to view all cards, edit, or delete them
6. Use category tabs to filter flashcards by topic
