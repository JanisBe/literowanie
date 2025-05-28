import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:literki/screens/sylaby.dart';


class SyllableStepScreen extends StatefulWidget {
  final List<String> parts;
  final SyllableMode mode;
  const SyllableStepScreen({super.key, required this.parts, required this.mode});

  @override
  State<SyllableStepScreen> createState() => _SyllableStepScreenState();
}

class _SyllableStepScreenState extends State<SyllableStepScreen> {
  int _current = 0;

  void _next() {
    setState(() {
      _current++;
      if (_current >= widget.parts.length) {
        Navigator.of(context).pop();
      }
    });
  }

  String _formatSyllable(String part) {
    switch (widget.mode) {
      case SyllableMode.uppercase:
        return part.toUpperCase();
      case SyllableMode.lowercase:
        return part.toLowerCase();
      case SyllableMode.matchCase:
        // Zwraca tekst z dużą i małą literą pod spodem
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_current >= widget.parts.length) {
      return const SizedBox.shrink();
    }

    final part = widget.parts[_current];
    Widget partWidget;

    if (widget.mode == SyllableMode.matchCase) {
      partWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            part.toUpperCase(),
            style: const TextStyle(fontSize: 68, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            part.toLowerCase(),
            style: const TextStyle(fontSize: 68, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      partWidget = Text(
        _formatSyllable(part),
        style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );
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
        title: const Text('Sylaby'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Wyświetl całe słowo z podziałem na sylaby, obecna sylaba na niebiesko
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    for (int i = 0; i < widget.parts.length; i++) ...[
                      TextSpan(
                        text: widget.parts[i],
                        style: GoogleFonts.marckScript(
                          color: i == _current ? Colors.blue[900] : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 40 + (i == _current ? 10 : 0),
                          decoration: i == _current ? TextDecoration.underline : null,
                        ),
                      ),
                      if (i < widget.parts.length - 1)
                        TextSpan(
                          text: '-',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                    ]
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: _next,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: partWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}