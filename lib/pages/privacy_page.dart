import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'We respect your privacy and are committed to protecting your personal data. This Privacy Policy outlines how we collect, use, and safeguard your information when you use our app.',
            ),
            SizedBox(height: 12),
            Text(
              'Information We Collect:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '- Personal Information: We may collect information such as name, email address, and phone number if provided voluntarily.\n'
              '- Usage Data: We may collect data on how the app is accessed and used.',
            ),
            SizedBox(height: 12),
            Text(
              'How We Use Information:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '- To provide and maintain the app.\n'
              '- To improve our app and user experience.\n'
              '- To communicate with you if needed.',
            ),
            SizedBox(height: 12),
            Text(
              'Data Security:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'We use reasonable measures to protect your information from unauthorized access or disclosure.',
            ),
            SizedBox(height: 12),
            Text(
              'Contact Us:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'If you have any questions about this Privacy Policy, please contact us at support@example.com.',
            ),
          ],
        ),
      );
  }
}