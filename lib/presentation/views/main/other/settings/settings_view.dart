import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_router.dart';

class PrivacyPolicyView extends StatelessWidget {
  final bool? showAppBar;

  const PrivacyPolicyView({Key? key, this.showAppBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showAppBar ?? false ? IconButton(onPressed: (){
          context.goNamed(AppRouter.home);
          html.window.history.pushState(null, 'title', '/home}');
        }, icon: Icon(Icons.arrow_back_ios)) : null,
        automaticallyImplyLeading: true,
        title: const Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            const Text('Last updated: September 25, 2024'),
            const SizedBox(height: 20),
            const Text(
              'This Privacy Policy describes Our policies and procedures on the collection, use, and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You. We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Interpretation and Definitions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            _buildRichText('Account', 'A unique account created for You to access our Service or parts of our Service.'),
            _buildRichText('Personal Data', 'Any information that relates to an identified or identifiable individual.'),
            _buildRichText(
              'Service Provider',
              'A natural or legal person who processes data on behalf of the Company, providing services related to the application.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Collecting and Using Your Personal Data',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            _buildRichText('Personal Data', 'We may collect your name, email, phone number, and other identifiable information.'),
            _buildRichText('Usage Data', 'Includes IP address, browser type, version, and pages you visit in the application.'),

            const SizedBox(height: 20),

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
