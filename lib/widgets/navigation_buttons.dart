import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/flashcard_provider.dart';

class NavigationButtons extends StatelessWidget {
  const NavigationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardProvider>(
      builder: (context, provider, _) {
        return Row(
          children: [
            // Previous Button
            Expanded(
              child: _NavButton(
                icon: Icons.arrow_back_ios_rounded,
                label: 'Previous',
                onPressed: provider.hasPrevious ? provider.previousCard : null,
                isEnabled: provider.hasPrevious,
              ),
            ),

            const SizedBox(width: 16),

            // Card counter indicator dots (max 5 visible)
            if (provider.totalCards <= 10)
              Expanded(
                child: _DotIndicator(
                  total: provider.totalCards,
                  current: provider.currentIndex,
                  onDotTap: provider.goToCard,
                ),
              )
            else
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    '${provider.currentIndex + 1} / ${provider.totalCards}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4F46E5),
                    ),
                  ),
                ),
              ),

            const SizedBox(width: 16),

            // Next Button
            Expanded(
              child: _NavButton(
                icon: Icons.arrow_forward_ios_rounded,
                label: 'Next',
                onPressed: provider.hasNext ? provider.nextCard : null,
                isEnabled: provider.hasNext,
                isReversed: true,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isReversed;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.isEnabled,
    this.isReversed = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isEnabled ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isEnabled ? const Color(0xFF4F46E5) : Colors.grey.shade300,
          foregroundColor: isEnabled ? Colors.white : Colors.grey.shade600,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isEnabled ? 4 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: isReversed
              ? [
                  Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  Icon(icon, size: 14),
                ]
              : [
                  Icon(icon, size: 14),
                  const SizedBox(width: 4),
                  Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ],
        ),
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int total;
  final int current;
  final Function(int) onDotTap;

  const _DotIndicator({
    required this.total,
    required this.current,
    required this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(total, (index) {
            final isActive = index == current;
            return GestureDetector(
              onTap: () => onDotTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF4F46E5)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}