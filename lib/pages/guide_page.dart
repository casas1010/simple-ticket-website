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
  final GuideLoader _guide_loader = GuideLoader();
  bool _is_loading = true;
  String _documentation_content = '';
  String _error_message = '';
  late AutoScrollController _scroll_controller;
  final Map<String, int> _section_indices = {};
  final List<String> _toc_items = [];
  List<String> _content_lines = [];

  @override
  Widget build(BuildContext context) {
    if (_is_loading) {
      return const Center(child: CircularProgressIndicator());
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
              itemCount: _toc_items.length,
              itemBuilder: (context, index) {
                final item = _toc_items[index];
                final isSubsection = item.startsWith('  ');

                return InkWell(
                  onTap: () => _scroll_to_section(item.trim()),
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
              controller: _scroll_controller,
              itemCount: _content_lines.length,
              itemBuilder: (context, index) {
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: _scroll_controller,
                  index: index,
                  child: MarkdownBody(
                    data: _content_lines[index],
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

  @override
  void initState() {
    super.initState();
    _scroll_controller = AutoScrollController();
    _load_documentation();
  }

  @override
  void dispose() {
    _scroll_controller.dispose();
    super.dispose();
  }

  Future<void> _load_documentation() async {
    try {
      setState(() {
        _is_loading = true;
        _error_message = '';
        _toc_items.clear();
        _section_indices.clear();
      });

      await _guide_loader.load_data();

      if (_guide_loader.documentationData != null) {
        _process_documentation(_guide_loader.documentationData!);
      }

      setState(() {
        _documentation_content = _guide_loader.documentationData ?? 'No content available';
        _is_loading = false;
      });
    } catch (e) {
      setState(() {
        _error_message = 'Failed to load documentation: $e';
        _is_loading = false;
      });
      print("Error in _load_documentation: $e");
    }
  }

  void _process_documentation(String content) {
    final lines = content.split('\n');
    
    // Find where the TOC ends
    int tocEndIndex = 0;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim() == '---' && i > 5) { // Making sure we find the --- after the TOC
        tocEndIndex = i + 1;
        break;
      }
    }
    
    // Store only the content part (without TOC)
    _content_lines = lines.sublist(tocEndIndex);
    
    // Parse headings for TOC
    _parse_toc_items(content);
  }

  void _parse_toc_items(String content) {
    final lines = content.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.startsWith('## ')) {
        final title = line.substring(3).trim();
        _toc_items.add(title);
        
        // Find this heading in the content (excluding TOC)
        final contentIndex = _find_heading_index(title, 2);
        if (contentIndex != -1) {
          _section_indices[title] = contentIndex;
        }
      } else if (line.startsWith('### ')) {
        final title = '  ${line.substring(4).trim()}';
        _toc_items.add(title);
        
        // Find this heading in the content (excluding TOC)
        final contentIndex = _find_heading_index(title.trim(), 3);
        if (contentIndex != -1) {
          _section_indices[title.trim()] = contentIndex;
        }
      }
    }
  }
  
  int _find_heading_index(String title, int headingLevel) {
    final prefix = '#' * headingLevel;
    for (int i = 0; i < _content_lines.length; i++) {
      if (_content_lines[i].trim().startsWith('$prefix $title')) {
        return i;
      }
    }
    return -1;
  }

  Future<void> _scroll_to_section(String sectionTitle) async {
    if (_section_indices.containsKey(sectionTitle)) {
      await _scroll_controller.scrollToIndex(
        _section_indices[sectionTitle]!,
        preferPosition: AutoScrollPosition.begin,
        duration: const Duration(milliseconds: 300),
      );
    }
  }
}