import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/vault_service.dart';
import 'services/sound_service.dart';
import 'services/music_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
  ));

  final vault = VaultService();
  await vault.init();

  final sfx   = await SoundService.create();
  final music = MusicService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => vault),
        Provider<SoundService>(create: (_) => sfx),
        Provider<MusicService>(create: (_) => music, dispose: (_, m) => m.dispose()),
      ],
      child: const GlobeVaultApp(),
    ),
  );
}
