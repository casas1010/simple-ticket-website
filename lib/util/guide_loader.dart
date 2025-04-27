import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../main.dart';

class GuideLoader {
  String? documentationData;

  Future<void> load_data() async {
    // Using the GitHub API instead of raw content URL
    var url = Uri.parse('https://api.github.com/repos/casas1010/simple-ticket-documentation/contents/README.md');

    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/vnd.github.v3+json',
        'Authorization': 'token ${GITHUB_TOKEN}',
      },
    );

    if (response.statusCode == 200) {
      // GitHub API returns content as base64 encoded
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['content'] != null) {
        // Decode the base64 content
        final String content = jsonResponse['content'];
        // GitHub API typically includes newlines in the base64 content, remove them
        final String cleanContent = content.replaceAll('\n', '');
        // Decode base64
        documentationData = utf8.decode(base64.decode(cleanContent));
        print("Loaded Documentation successfully");
      } else {
        print("Content not found in response");
        documentationData = "No content available";
      }
    } else {
      print("Failed to load documentation. Status: ${response.statusCode}");
      print("Response body: ${response.body}");
      documentationData = "Failed to load: HTTP ${response.statusCode}";
    }
  }
}