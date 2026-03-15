import 'package:eshop/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'dart:html' as html;

class TermsView extends StatelessWidget {
  final bool? showAppBar;

  const TermsView( {Key? key,  this.showAppBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showAppBar ?? false ? IconButton(onPressed: (){
          context.goNamed(AppRouter.home);
          // html.window.history.pushState(null, 'title', '/home}');
        }, icon: Icon(Icons.arrow_back_ios)) : null,
        title: const Text("Terms and Conditions"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Conditions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            const Text('Last updated: October 15, 2025'),
            const SizedBox(height: 20),

            const Text(
              'Interpretation and Definitions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            _buildRichText('Affiliate',
                'Means an entity that controls, is controlled by, or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest, or other securities entitled to vote for election of directors or other managing authority.'),
            _buildRichText('Company',
                'Referred to as either "the Company", "We", "Us" or "Our" in this Agreement, refers to Qirat.'),
            _buildRichText('Device',
                'Means any device that can access the Service, such as a computer, cellphone, or digital tablet.'),
            _buildRichText('Service', 'Refers to the Website.'),
            _buildRichText('Terms and Conditions',
                'Mean these Terms and Conditions that form the entire agreement between You and the Company regarding the use of the Service.'),
            _buildRichText('Third-party Social Media Service',
                'Means any services or content (including data, information, products or services) provided by a third party that may be displayed, included or made available by the Service.'),
            _buildRichText('You',
                'Means the individual accessing or using the Service, or the company or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.'),

            const SizedBox(height: 20),
            const Text(
              'Acknowledgment',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'These are the Terms and Conditions governing the use of this Service and the agreement that operates between You and the Company. These Terms and Conditions set out the rights and obligations of all users regarding the use of the Service.\n\n'
                  'Your access to and use of the Service is conditioned on Your acceptance of and compliance with these Terms and Conditions. These apply to all visitors, users, and others who access or use the Service.\n\n'
                  'By accessing or using the Service, You agree to be bound by these Terms and Conditions. If You disagree with any part, You may not access the Service.\n\n'
                  'You represent that you are over the age of 18. The Company does not permit those under 18 to use the Service.\n\n'
                  'Your access to and use of the Service is also conditioned on Your acceptance of and compliance with the Privacy Policy of the Company, which describes how we collect, use, and disclose your personal information. Please read it carefully before using our Service.',
            ),

            const SizedBox(height: 20),
            const Text(
              'Links to Other Websites',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Our Service may contain links to third-party websites or services not owned or controlled by the Company.\n\n'
                  'The Company has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third-party websites or services. '
                  'You agree that the Company shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused in connection with your use of or reliance on any such content, goods, or services.\n\n'
                  'We strongly advise you to review the Terms and Privacy Policies of any third-party websites you visit.',
            ),

            const SizedBox(height: 20),
            const Text(
              'Termination',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'We may terminate or suspend your access immediately, without prior notice or liability, for any reason whatsoever, including if you breach these Terms and Conditions.\n\n'
                  'Upon termination, your right to use the Service will cease immediately.',
            ),

            const SizedBox(height: 20),
            const Text(
              'Limitation of Liability',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Notwithstanding any damages that You might incur, the entire liability of the Company and any of its suppliers under any provision of these Terms shall be limited to the amount actually paid by You through the Service or ₹100 INR if You haven’t purchased anything through the Service.\n\n'
                  'To the maximum extent permitted by law, in no event shall the Company or its suppliers be liable for any special, incidental, indirect, or consequential damages whatsoever (including, but not limited to, loss of profits, loss of data, business interruption, or personal injury), even if advised of the possibility of such damages.\n\n'
                  'Some jurisdictions do not allow limitations of liability, so these may not apply to you.',
            ),

            const SizedBox(height: 20),
            const Text(
              '"AS IS" and "AS AVAILABLE" Disclaimer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'The Service is provided to You "AS IS" and "AS AVAILABLE" and with all faults and defects without warranty of any kind. '
                  'To the maximum extent permitted under applicable law, the Company disclaims all warranties, express or implied, including those of merchantability, fitness for a particular purpose, and non-infringement. '
                  'We make no representation that the Service will be uninterrupted, error-free, or free of viruses or harmful components.',
            ),

            const SizedBox(height: 20),
            const Text(
              'Governing Law',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'These Terms shall be governed by and construed in accordance with the laws of India, excluding its conflict of law rules.\n\n'
                  'Owner: Arsalan Ikramullah Khan',
            ),
            const SizedBox(height: 30),

            const Text(
              'Shipping Policy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            _buildRichText('Processing & Shipping Time', '''
  \n\n Orders are processed within 5 business days.

  Delivery times vary based on location and shipping method.

  All the orders will be delivered within 5-7 business days .
'''),

            _buildRichText('Shipping Costs', '''
  \n\n Shipping fees are calculated at checkout based on weight and destination..

   Free shipping is available.

  We are not liable for delays due to customs, weather, or carrier issues. .
'''),

            const SizedBox(height: 20),

            const Text(
              'Return, Refund & Exchange Policy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            const Text(
              'At Qirat, we ensure every product reaches you in perfect condition. If for any reason you are not satisfied with your purchase, please review our return, refund, and exchange policy below.',
            ),
            const SizedBox(height: 20),
            _buildRichText('Returns & Refunds',
                'Returns are accepted only if the delivered item is damaged or defective. '
                    'You must notify us within 48 hours of delivery by emailing us at care@qiratshop.in with clear photos of the damaged/defective item. '
                    'Once approved, we will arrange a return pickup or provide instructions for returning the item. Refunds will be processed and credited within 5–7 business days after inspection.'),
            const SizedBox(height: 10),
            _buildRichText('Exchanges',
                'If you would like to exchange a product (for reasons other than damage/defect), you may courier the item to us at:\n\n'
                    'Room no 102/B-wing, Khushnuma Apartment, Kadar Palace, Kausa, Mumbra 400612.\n\n'
                    'Once received in original condition, we will ship the replacement item of your choice. Customers are responsible for shipping charges for exchanges. Your order will be replaced and exchange and will be delivered within 4–5 days.'),
            const SizedBox(height: 10),
            _buildRichText('Conditions for Return & Exchange',
                'Items must be unused, and returned in original condition.\n\n'
                    'We do not accept returns or exchanges on:\n• Customized products\n• Clearance or sale items\n\nIn case the desired replacement is unavailable, we will issue a refund.'),

            const SizedBox(height: 30),

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

            const SizedBox(height: 30),
            const Divider(thickness: 1),
            const SizedBox(height: 20),


            _buildContactDetails(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper for rich text sections
  static Widget _buildRichText(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 15),
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
  static Widget _buildContactDetails() {
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
        Text('If you have any questions about these Terms, please contact us:'),
        SizedBox(height: 10),
        Text('• Email: care@qiratshop.in'),
        Text('• Phone: +91 9137029393'),
        Text('• Website: qiratshop.in'),
      ],
    );
  }
}
