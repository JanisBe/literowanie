import 'package:flutter/material.dart';
import 'spelling_step_screen.dart';

enum SpellingMode { uppercase, lowercase, matchCase }

class LiterowanieScreen extends StatefulWidget {
  const LiterowanieScreen({super.key});

  @override
  State<LiterowanieScreen> createState() => _LiterowanieScreenState();
}

class _LiterowanieScreenState extends State<LiterowanieScreen> {
  final TextEditingController _controller = TextEditingController();

  void _startSpelling(SpellingMode mode) {
    final word = _controller.text.trim();
    if (word.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SpellingStepScreen(word: word, mode: mode),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 32),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Zamknij',
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Literowanie'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Wpisz słowo do literowania',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward, size: 36),
                    tooltip: 'DUŻE LITERY',
                    onPressed: () => _startSpelling(SpellingMode.uppercase),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward, size: 36),
                    tooltip: 'małe litery',
                    onPressed: () => _startSpelling(SpellingMode.lowercase),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.text_fields, size: 36),
                    tooltip: 'Duże i małe litery',
                    onPressed: () => _startSpelling(SpellingMode.matchCase),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}