import 'package:flutter/material.dart';
import 'theme/gv_theme.dart';
import 'views/launch_view.dart';

class GlobeVaultApp extends StatelessWidget {
  const GlobeVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlobeVault',
      theme: GVTheme.build(),
      debugShowCheckedModeBanner: false,
      home: const LaunchView(),
    );
  }
}
