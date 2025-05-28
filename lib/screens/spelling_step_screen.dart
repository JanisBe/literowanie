import 'package:flutter/material.dart';
import 'package:literki/screens/spelling_step.dart';

class SpellingStepScreen extends StatefulWidget {
  final String word;
  final SpellingMode mode;
  const SpellingStepScreen({super.key, required this.word, required this.mode});

  @override
  State<SpellingStepScreen> createState() => _SpellingStepScreenState();
}

class _SpellingStepScreenState extends State<SpellingStepScreen> {
  int _currentIndex = 0;

  void _nextLetter() {
    setState(() {
      _currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.word.length) {
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
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Brawo! 👍',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '⏪',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final letter = widget.word[_currentIndex];
    Widget letterWidget;

    switch (widget.mode) {
      case SpellingMode.uppercase:
        letterWidget = Text(
          letter.toUpperCase(),
          style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
        );
        break;
      case SpellingMode.lowercase:
        letterWidget = Text(
          letter.toLowerCase(),
          style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
        );
        break;
      case SpellingMode.matchCase:
        letterWidget = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              letter.toUpperCase(),
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            Text(
              letter.toLowerCase(),
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ],
        );
        break;
    }

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
        child: GestureDetector(
          onTap: _nextLetter,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: letterWidget,
          ),
        ),
      ),
    );
  }
}