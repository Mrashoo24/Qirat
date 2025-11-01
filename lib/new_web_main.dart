import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'core/router/new_web_router.dart';
import 'core/theme/qirat_theme.dart';

/// Entry point for testing the new web UI
/// Use this temporarily to preview the new design
void main() {
  setUrlStrategy(HashUrlStrategy());
  runApp(const NewWebTestApp());
}

class NewWebTestApp extends StatelessWidget {
  const NewWebTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Qirat Attars - New Web UI',
      debugShowCheckedModeBanner: false,
      theme: QiratTheme.darkTheme,
      routerConfig: newWebRouter,
    );
  }
}
