import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flashcard.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;
  final bool isAnswerVisible;
  final VoidCallback onTap;

  const FlashcardWidget({
    super.key,
    required this.flashcard,
    required this.isAnswerVisible,
    required this.onTap,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showingAnswer = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnswerVisible != _showingAnswer) {
      _showingAnswer = widget.isAnswerVisible;
      if (_showingAnswer) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    // Reset when card changes
    if (widget.flashcard.id != oldWidget.flashcard.id) {
      _controller.reset();
      _showingAnswer = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isFlipped = _animation.value > 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_animation.value * 3.14159),
            child: isFlipped
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159),
                    child: _buildCardFace(isAnswer: true),
                  )
                : _buildCardFace(isAnswer: false),
          );
        },
      ),
    );
  }

  Widget _buildCardFace({required bool isAnswer}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isAnswer
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFF8F7FF)],
              ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isAnswer
              ? Colors.transparent
              : const Color(0xFF4F46E5).withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          // Background decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isAnswer
                    ? Colors.white.withOpacity(0.08)
                    : const Color(0xFF4F46E5).withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isAnswer
                    ? Colors.white.withOpacity(0.06)
                    : const Color(0xFF4F46E5).withOpacity(0.04),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Label chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isAnswer
                        ? Colors.white.withOpacity(0.2)
                        : const Color(0xFF4F46E5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAnswer
                            ? Icons.lightbulb_rounded
                            : Icons.help_outline_rounded,
                        size: 14,
                        color: isAnswer
                            ? Colors.white
                            : const Color(0xFF4F46E5),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isAnswer ? 'ANSWER' : 'QUESTION',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isAnswer
                              ? Colors.white
                              : const Color(0xFF4F46E5),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Category badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAnswer
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.flashcard.category,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: isAnswer
                          ? Colors.white70
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Main text
                Text(
                  isAnswer
                      ? widget.flashcard.answer
                      : widget.flashcard.question,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: isAnswer ? 14 : 17,
                    fontWeight:
                        isAnswer ? FontWeight.w400 : FontWeight.w600,
                    color: isAnswer
                        ? Colors.white
                        : const Color(0xFF1E1B4B),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                // Tap hint
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      size: 14,
                      color: isAnswer
                          ? Colors.white.withOpacity(0.5)
                          : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tap to flip',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: isAnswer
                            ? Colors.white.withOpacity(0.5)
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}