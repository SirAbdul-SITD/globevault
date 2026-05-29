import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/nation.dart';
import '../services/vault_service.dart';
import '../services/music_service.dart';
import '../theme/gv_theme.dart';
import 'explorer_view.dart';

class LaunchView extends StatefulWidget {
  const LaunchView({super.key});
  @override State<LaunchView> createState() => _LaunchViewState();
}

class _LaunchViewState extends State<LaunchView> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<MusicService>().playMenu());
  }

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultService>();
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(child: Image.asset('assets/backgrounds/bg_home.jpg', fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: GVTheme.bg.withOpacity(0.80))),
        SafeArea(child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(children: [
                const Spacer(flex: 2),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: GVTheme.gold.withOpacity(0.5), width: 1.5),
                    color: GVTheme.card,
                    boxShadow: [BoxShadow(color: GVTheme.gold.withOpacity(0.18), blurRadius: 32)],
                  ),
                  child: const Text('🌐', style: TextStyle(fontSize: 58)),
                ),
                const SizedBox(height: 24),
                Text('GLOBEVAULT', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 8),
                Text('UNLOCK THE WORLD', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 6),
                Text('100 nations · 500 challenges',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 1)),
                const Spacer(flex: 2),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(color: GVTheme.card, borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: GVTheme.border)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    _stat(context, '⭐', '${vault.totalStars()}', 'Stars'),
                    Container(width: 1, height: 36, color: GVTheme.border),
                    _stat(context, '🌍', '${vault.completedCount()}', 'Completed'),
                    Container(width: 1, height: 36, color: GVTheme.border),
                    _stat(context, '🔓', '${vault.unlockedCount()}', 'Unlocked'),
                  ]),
                ),
                const SizedBox(height: 30),
                SizedBox(width: double.infinity, child: ElevatedButton(
                  onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ExplorerView())),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: GVTheme.gold, foregroundColor: GVTheme.bg),
                  child: Text('EXPLORE THE VAULT', style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: GVTheme.bg, fontSize: 16, letterSpacing: 1.5)),
                )),
                const SizedBox(height: 14),
                TextButton.icon(
                  onPressed: () => setState(() => context.read<MusicService>().toggleMute()),
                  icon: Icon(
                    context.watch<MusicService>().muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                    color: GVTheme.textSecondary, size: 20),
                  label: Text(context.watch<MusicService>().muted ? 'Music Off' : 'Music On',
                    style: Theme.of(context).textTheme.bodyMedium),
                ),
                const Spacer(),
              ]),
            ),
          ),
        )),
      ]),
    );
  }

  Widget _stat(BuildContext ctx, String icon, String val, String lbl) =>
    Column(mainAxisSize: MainAxisSize.min, children: [
      Text(icon, style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 4),
      Text(val, style: Theme.of(ctx).textTheme.titleLarge?.copyWith(color: GVTheme.gold, fontSize: 22)),
      Text(lbl, style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(fontSize: 11)),
    ]);
}
