import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literki/screens/sylaby_screen.dart';


enum SyllableMode { uppercase, lowercase, matchCase }

class SylabyScreen extends StatefulWidget {
  const SylabyScreen({super.key});

  @override
  State<SylabyScreen> createState() => _SylabyScreenState();
}

class _SylabyScreenState extends State<SylabyScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _onSpellCheck(SyllableMode mode) async {
    final word = _controller.text.trim();
    if (word.isEmpty) return;

    try {
      final initResp = await http.get(Uri.parse('https://www.ushuaia.pl/hyphen'));
      final cookies = initResp.headers['set-cookie'];
      if (cookies == null) {
        _showError('Nie udało się pobrać ciastka.');
        return;
      }
      final hyphenCookie = _extractHyphenCookie(cookies);
      if (hyphenCookie == null) {
        _showError('Nie znaleziono ciastka hyphen.');
        return;
      }

      final encodedWord = Uri.encodeComponent(word);
      final url = 'https://www.ushuaia.pl/hyphen/hyphenate.php?word=$encodedWord&lang=pl_PL';
      final resp = await http.get(
        Uri.parse(url),
        headers: {'cookie': hyphenCookie},
      );
      if (resp.statusCode != 200) {
        _showError('Błąd pobierania sylab.');
        return;
      }

      final parts = _splitHyphenated(resp.body);
      if (parts.isEmpty) {
        _showError('Nie udało się podzielić słowa.');
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SyllableStepScreen(parts: parts, mode: mode),
        ),
      );
    } catch (e) {
      _showError('Wystąpił błąd: $e');
    }
  }

  String? _extractHyphenCookie(String cookies) {
    final reg = RegExp(r'hyphen=[^;]+');
    final match = reg.firstMatch(cookies);
    return match?.group(0);
  }

  List<String> _splitHyphenated(String html) {
    final replaced = html.replaceAll(RegExp(r'<span class="hyphen">.*?</span>'), '|');
    return replaced.split('|').map((e) => e.replaceAll(RegExp(r'<[^>]+>'), '')).toList();
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SelectableText(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
        title: const Text('Sylaby'),
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
                  labelText: 'Wpisz słowo do podziału na sylaby',
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
                    onPressed: () => _onSpellCheck(SyllableMode.uppercase),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward, size: 36),
                    tooltip: 'małe litery',
                    onPressed: () => _onSpellCheck(SyllableMode.lowercase),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.text_fields, size: 36),
                    tooltip: 'Match case',
                    onPressed: () => _onSpellCheck(SyllableMode.matchCase),
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