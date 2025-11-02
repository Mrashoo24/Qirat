import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';

class NewWebDeleteAccountView extends StatelessWidget {
  const NewWebDeleteAccountView({Key? key}) : super(key: key);

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
                'Delete Your Personal Data',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'You have the right to delete or request that We assist in deleting the Personal Data that We have collected about You. Our Service may give You the ability to delete certain information from within the Service. '
                'You may also contact Us directly to request access, correction, or deletion of any personal information that You have provided.',
                style: TextStyle(
                  color: QiratTheme.darkOnBackground,
                  fontFamily: 'Inter',
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              _buildContactDetails(),
              const SizedBox(height: 20),
            ],
          ),
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
          style: TextStyle(
            color: QiratTheme.textSecondary,
            fontFamily: 'Inter',
          ),
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
