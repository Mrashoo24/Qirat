import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';

class NewWebPrivacyView extends StatelessWidget {
  const NewWebPrivacyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: QiratTheme.darkTheme,
      child: Scaffold(
        backgroundColor: QiratTheme.darkBackground,
        appBar: const QiratHeaderWidget(showShadow: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Privacy Policy',
                style: TextStyle(
                  color: QiratTheme.qiratGold,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Last updated: September 25, 2024',
                style: TextStyle(
                  color: QiratTheme.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'This Privacy Policy describes Our policies and procedures on the collection, use, and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You. We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.',
                style: TextStyle(
                  color: QiratTheme.darkOnBackground,
                  fontFamily: 'Inter',
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Interpretation and Definitions',
                style: TextStyle(
                  color: QiratTheme.darkOnBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 10),
              _buildRichText('Account',
                  'A unique account created for You to access our Service or parts of our Service.'),
              _buildRichText('Personal Data',
                  'Any information that relates to an identified or identifiable individual.'),
              _buildRichText('Service Provider',
                  'A natural or legal person who processes data on behalf of the Company, providing services related to the application.'),
              const SizedBox(height: 20),
              const Text(
                'Collecting and Using Your Personal Data',
                style: TextStyle(
                  color: QiratTheme.darkOnBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 10),
              _buildRichText('Personal Data',
                  'We may collect your name, email, phone number, and other identifiable information.'),
              _buildRichText('Usage Data',
                  'Includes IP address, browser type, version, and pages you visit in the application.'),
              const SizedBox(height: 20),
              _buildContactDetails(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildRichText(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
              color: QiratTheme.darkOnBackground,
              fontFamily: 'Inter',
              height: 1.5),
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

  static Widget _buildContactDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Contact Us',
          style: TextStyle(
            color: QiratTheme.darkOnBackground,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: 10),
        Text(
          'If you have any questions about this Privacy Policy, You can contact us:',
          style:
              TextStyle(color: QiratTheme.textSecondary, fontFamily: 'Inter'),
        ),
        SizedBox(height: 10),
        Text('• By email: care@qiratshop.in',
            style: TextStyle(
                color: QiratTheme.darkOnBackground, fontFamily: 'Inter')),
        Text('• By phone: 919137029393',
            style: TextStyle(
                color: QiratTheme.darkOnBackground, fontFamily: 'Inter')),
        Text('• Website: qiratshop.in',
            style: TextStyle(
                color: QiratTheme.darkOnBackground, fontFamily: 'Inter')),
      ],
    );
  }
}
