import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  Widget buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
    VoidCallback? onTap,context
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: GestureDetector(
        onTap: isLink ? onTap : null,
        onLongPress: !isLink
            ? () {
          Clipboard.setData(ClipboardData(text: value));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to clipboard')),
          );
        }
            : null,
        child: Text(
          value,
          style: TextStyle(
            color: isLink ? Colors.blue : Colors.black,
            decoration: isLink ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We'd love to hear from you! Feel free to reach out using any of the methods below.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            buildContactItem(
              icon: Icons.email,
              label: "Email",
              value: "care@qiratshop.in",
              onTap: () => _launchUrl('mailto:care@qiratshop.in'),context:context
            ),
            buildContactItem(
              icon: Icons.phone,
              label: "Phone",
              value: "9137029393",
              onTap: () => _launchUrl('tel:+919137029393'),context:context
            ),
            buildContactItem(
              icon: Icons.camera_alt,
              label: "Instagram",
              value: "qirat_attar",
              isLink: true,
              onTap: () => _launchUrl('https://instagram.com/qirat_attar'),context:context
            ),
            buildContactItem(
              icon: Icons.web,
              label: "Website",
              value: "qiratshop.in",
              isLink: true,
              onTap: () => _launchUrl('https://qiratshop.in'),context:context
            ),
          ],
        ),
      ),
    );
  }
}
