import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/flashcard_provider.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/navigation_buttons.dart';
import '../widgets/category_filter.dart';
import 'add_edit_screen.dart';
import 'all_cards_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FF),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.style_rounded, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('FlashCard Quiz'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_list_rounded),
            tooltip: 'View All Cards',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AllCardsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shuffle_rounded),
            tooltip: 'Shuffle Cards',
            onPressed: () {
              context.read<FlashcardProvider>().shuffleCards();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cards shuffled! 🔀'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
            );
          }

          return Column(
            children: [
              // Header Stats Bar
              Container(
                color: const Color(0xFF4F46E5),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: _StatChip(
                        icon: Icons.library_books_rounded,
                        label: '${provider.totalCards} Cards',
                      ),
                    ),
                    if (provider.totalCards > 0) ...[
                      const SizedBox(width: 4),
                      Flexible(
                        child: _StatChip(
                          icon: Icons.location_on_rounded,
                          label:
                              '${provider.currentIndex + 1} / ${provider.totalCards}',
                        ),
                      ),
                    ],
                    const SizedBox(width: 4),
                    Flexible(
                      child: _StatChip(
                        icon: Icons.category_rounded,
                        label: provider.selectedCategory,
                      ),
                    ),
                  ],
                ),
              ),

              // Category Filter
              const CategoryFilter(),

              // Main Content
              Expanded(
                child: provider.flashcards.isEmpty
                    ? _EmptyState(
                        onAddCard: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddEditScreen()),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Column(
                          children: [
                            // Progress Indicator
                            LinearProgressIndicator(
                              value: provider.totalCards > 0
                                  ? (provider.currentIndex + 1) /
                                      provider.totalCards
                                  : 0,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4F46E5)),
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            const SizedBox(height: 10),

                            // Flashcard
                            Flexible(
                              child: FlashcardWidget(
                                flashcard: provider.currentCard!,
                                isAnswerVisible: provider.isAnswerVisible,
                                onTap: provider.toggleAnswer,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Show Answer Button
                            if (!provider.isAnswerVisible)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: provider.showAnswer,
                                  icon: const Icon(Icons.visibility_rounded),
                                  label: Text(
                                    'Show Answer',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 11),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              )
                            else
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: provider.hideAnswer,
                                  icon: const Icon(Icons.visibility_off_rounded,
                                      color: Color(0xFF4F46E5)),
                                  label: Text(
                                    'Hide Answer',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF4F46E5),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 11),
                                    side: const BorderSide(
                                        color: Color(0xFF4F46E5), width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 8),

                            // Navigation Buttons
                            const NavigationButtons(),

                            const SizedBox(height: 70),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditScreen()),
        ),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Add Card',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddCard;

  const _EmptyState({required this.onAddCard});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.style_rounded,
              size: 60,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Flashcards Yet!',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E1B4B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first flashcard\nto begin studying.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onAddCard,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add First Card'),
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}