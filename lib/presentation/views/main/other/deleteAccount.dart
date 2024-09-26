import 'package:flutter/material.dart';

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Policy"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delete Your Personal Data',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You have the right to delete or request that We assist in deleting the Personal Data that We have collected about You. Our Service may give You the ability to delete certain information from within the Service. '
                  'You may also contact Us directly to request access, correction, or deletion of any personal information that You have provided.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildContactDetails(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper for rich text sections
  Widget _buildRichText(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: description),
          ],
        ),
      ),
    );
  }

  // Contact Details Section
  Widget _buildContactDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Contact Us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10),
        Text('If you have any questions about this Privacy Policy, You can contact us:'),
        SizedBox(height: 10),
        Text('• By email: care@qiratshop.in'),
        Text('• By phone: 919137029393'),
        Text('• Website: qiratshop.in'),
      ],
    );
  }
}
