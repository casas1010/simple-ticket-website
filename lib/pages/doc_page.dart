import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../util/docs_loader.dart';

class DocsPage extends StatefulWidget {
  @override
  _DocsPageState createState() => _DocsPageState();
}

class _DocsPageState extends State<DocsPage> {
  late DocsUtil _docs_util;
  late List<Map<String, dynamic>>? _documentationData = [];
  late bool _is_loading = true;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _docs_util = DocsUtil();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    if (_is_loading) {
      return Center(
        child: CircularProgressIndicator(), 
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Sidebar(
              documentationData: _documentationData!,
              onItemSelected: (index) {
                _itemScrollController.scrollTo(
                  index: index,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: DocumentationContent(
              documentationData: _documentationData!,
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _init() async {
    await _docs_util.load_data_per_context();

    _documentationData = _docs_util.documentationData;
    _is_loading = false;
    setState(() {});
  }
}

class Sidebar extends StatelessWidget {
  final List<Map<String, dynamic>> documentationData;
  final Function(int) onItemSelected;

  Sidebar({required this.documentationData, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    // Group data by Mode > Theme
    Map<String, Map<String, List<Map<String, dynamic>>>> groupedData = {};
    for (var item in documentationData) {
      String mode = item['Mode'] ?? 'Uncategorized';
      String theme = item['Theme'] ?? 'Uncategorized';

      if (!groupedData.containsKey(mode)) {
        groupedData[mode] = {};
      }
      if (!groupedData[mode]!.containsKey(theme)) {
        groupedData[mode]![theme] = [];
      }
      groupedData[mode]![theme]!.add(item);
    }

    return ListView.builder(
      itemCount: groupedData.length,
      itemBuilder: (context, index) {
        String mode = groupedData.keys.elementAt(index);
        return ExpansionTile(
          title: Text(mode, style: TextStyle(fontWeight: FontWeight.bold)),
          children: groupedData[mode]!.entries.map((themeEntry) {
            String theme = themeEntry.key;
            return ExpansionTile(
              title: Text(theme, style: TextStyle(fontWeight: FontWeight.bold)),
              children: themeEntry.value.map((item) {
                return ListTile(
                  
                  title: Text("Aaa"),
                  // title: Text('${item['Class'] ?? item['Object'] ?? item['Table'] ?? item['Method name'] ?? item['Properties']}'),
                  onTap: () => onItemSelected(documentationData.indexOf(item)),
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }
}

class DocumentationContent extends StatelessWidget {
  final List<Map<String, dynamic>> documentationData;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  DocumentationContent({
    required this.documentationData,
    required this.itemScrollController,
    required this.itemPositionsListener,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      itemCount: documentationData.length,
      itemBuilder: (context, index) {
        var item = documentationData[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['Mode'] != null) Text('Mode: ${item['Mode']}'),
                if (item['Theme'] != null) Text('Theme: ${item['Theme']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (item['Sub theme'] != null) Text('Sub theme: ${item['Sub theme']}'),
                if (item['Table'] != null) Text('Table: ${item['Table']}'),
                if (item['Class'] != null) Text('Class: ${item['Class']}'),
                if (item['Object'] != null) Text('Object: ${item['Object']}'),
                if (item['Method name'] != null) Text('Method: ${item['Method name']}'),
                if (item['Properties'] != null) Text('Properties: ${item['Properties']}'),
                if (item['Description'] != null) Text('Description: ${item['Description']}'),
                if (item['Inputs'] != null) Text('Inputs: ${item['Inputs']}'),
                if (item['Output'] != null) Text('Output: ${item['Output']}'),
                if (item['Type'] != null) Text('Type: ${item['Type']}'),
                if (item['Examples'] != null) Text('Examples: ${item['Examples']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
