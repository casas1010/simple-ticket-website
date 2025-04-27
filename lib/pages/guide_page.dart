import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../util/guide_loader.dart';

// Import your updated GuideLoader

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  final GuideLoader _guideLoader = GuideLoader();
  bool _isLoading = true;
  String _documentationContent = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadDocumentation();
  }

  Future<void> _loadDocumentation() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      await _guideLoader.load_data();

      setState(() {
        _documentationContent = _guideLoader.documentationData ?? 'No content available';
        _isLoading = false;
      });
      print("_documentationContent:\n${_documentationContent}");
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load documentation: $e';
        _isLoading = false;
      });
      print("Error in _loadDocumentation: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentation Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDocumentation,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDocumentation,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Markdown(
                    data: _documentationContent,
                    selectable: true,
                  ),
                ),
    );
  }
}
