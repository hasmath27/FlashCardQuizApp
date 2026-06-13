import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flashcard.dart';
import '../providers/flashcard_provider.dart';

class AddEditScreen extends StatefulWidget {
  final Flashcard? flashcard;

  const AddEditScreen({super.key, this.flashcard});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isSaving = false;

  bool get isEditing => widget.flashcard != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _questionController.text = widget.flashcard!.question;
      _answerController.text = widget.flashcard!.answer;
      _categoryController.text = widget.flashcard!.category;
    } else {
      _categoryController.text = 'General';
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final provider = context.read<FlashcardProvider>();

    try {
      if (isEditing) {
        await provider.updateFlashcard(
          widget.flashcard!.copyWith(
            question: _questionController.text.trim(),
            answer: _answerController.text.trim(),
            category: _categoryController.text.trim().isEmpty
                ? 'General'
                : _categoryController.text.trim(),
          ),
        );
      } else {
        await provider.addFlashcard(
          Flashcard(
            question: _questionController.text.trim(),
            answer: _answerController.text.trim(),
            category: _categoryController.text.trim().isEmpty
                ? 'General'
                : _categoryController.text.trim(),
          ),
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing
                ? '✅ Flashcard updated successfully!'
                : '✅ Flashcard added successfully!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FF),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Flashcard' : 'Add New Card'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.check_rounded, color: Colors.white),
            label: Text(
              'Save',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.preview_rounded,
                            color: Colors.white70, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Preview',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ValueListenableBuilder(
                      valueListenable: _questionController,
                      builder: (_, __, ___) => Text(
                        _questionController.text.isEmpty
                            ? 'Your question will appear here...'
                            : _questionController.text,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _SectionLabel(label: 'Question *', icon: Icons.help_outline_rounded),
              const SizedBox(height: 8),
              TextFormField(
                controller: _questionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Enter your question here...',
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Question is required' : null,
              ),

              const SizedBox(height: 20),

              _SectionLabel(label: 'Answer *', icon: Icons.lightbulb_rounded),
              const SizedBox(height: 8),
              TextFormField(
                controller: _answerController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter the answer here...',
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Answer is required' : null,
              ),

              const SizedBox(height: 20),

              _SectionLabel(label: 'Category', icon: Icons.category_rounded),
              const SizedBox(height: 8),
              Consumer<FlashcardProvider>(
                builder: (context, provider, _) {
                  final existingCats = provider.categories
                      .where((c) => c != 'All')
                      .toList();

                  return Column(
                    children: [
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Math, Science, Flutter...',
                        ),
                      ),
                      if (existingCats.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: existingCats.map((cat) {
                            return GestureDetector(
                              onTap: () {
                                _categoryController.text = cat;
                              },
                              child: Chip(
                                label: Text(cat,
                                    style: GoogleFonts.poppins(fontSize: 12)),
                                backgroundColor: const Color(0xFF4F46E5)
                                    .withOpacity(0.1),
                                side: const BorderSide(
                                    color: Color(0xFF4F46E5), width: 1),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(isEditing
                          ? Icons.save_rounded
                          : Icons.add_circle_rounded),
                  label: Text(
                    isEditing ? 'Update Flashcard' : 'Add Flashcard',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF4F46E5)),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E1B4B),
          ),
        ),
      ],
    );
  }
}