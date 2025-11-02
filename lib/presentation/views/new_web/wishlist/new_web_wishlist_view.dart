import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';

class NewWebWishlistView extends StatelessWidget {
  const NewWebWishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: QiratTheme.darkTheme,
      child: const Scaffold(
        backgroundColor: QiratTheme.darkBackground,
        appBar: QiratHeaderWidget(showShadow: true),
        body: Center(
            child: Text('Wishlist', style: TextStyle(fontFamily: 'Inter'))),
      ),
    );
  }
}
