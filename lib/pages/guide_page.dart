import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../util/guide_loader.dart';

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
  late AutoScrollController _scrollController;
  final Map<String, int> _sectionIndices = {};
  final List<String> _tocItems = [];

  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController();
    _loadDocumentation();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDocumentation() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
        _tocItems.clear();
        _sectionIndices.clear();
      });

      await _guideLoader.load_data();

      if (_guideLoader.documentationData != null) {
        _parseDocumentationContent(_guideLoader.documentationData!);
      }

      setState(() {
        _documentationContent = _guideLoader.documentationData ?? 'No content available';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load documentation: $e';
        _isLoading = false;
      });
      print("Error in _loadDocumentation: $e");
    }
  }

  void _parseDocumentationContent(String content) {
    final lines = content.split('\n');
    int index = 0;

    for (final line in lines) {
      if (line.startsWith('## ')) {
        final title = line.substring(3).trim();
        _tocItems.add(title);
        _sectionIndices[title] = index;
      } else if (line.startsWith('### ')) {
        final title = '  ${line.substring(4).trim()}';
        _tocItems.add(title);
        _sectionIndices[title.trim()] = index;
      }
      index++;
    }
  }

  Future<void> _scrollToSection(String sectionTitle) async {
    final trimmedTitle = sectionTitle.trim();
    if (_sectionIndices.containsKey(trimmedTitle)) {
      await _scrollController.scrollToIndex(
        _sectionIndices[trimmedTitle]!,
        preferPosition: AutoScrollPosition.begin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table of Contents - Fixed width container
        SizedBox(
          width: 250,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: ListView.builder(
              itemCount: _tocItems.length,
              itemBuilder: (context, index) {
                final item = _tocItems[index];
                final isSubsection = item.startsWith('  ');

                return InkWell(
                  onTap: () => _scrollToSection(item),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: isSubsection ? 16.0 : 8.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: isSubsection ? 14 : 16,
                        fontWeight: isSubsection ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Content - Expanded to fill remaining space
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _documentationContent.split('\n').length,
              itemBuilder: (context, index) {
                final line = _documentationContent.split('\n')[index];
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: _scrollController,
                  index: index,
                  child: MarkdownBody(
                    data: line,
                    selectable: true,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
