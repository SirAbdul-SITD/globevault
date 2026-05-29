import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/nation.dart';
import '../services/vault_service.dart';
import '../theme/gv_theme.dart';
import '../widgets/star_display.dart';

class DebriefView extends StatefulWidget {
  final Nation nation;
  final int score;
  final int total;
  const DebriefView({super.key, required this.nation, required this.score, required this.total});
  @override State<DebriefView> createState() => _DebriefViewState();
}

class _DebriefViewState extends State<DebriefView> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  int get _stars => widget.score >= widget.total ? 3 : widget.score >= (widget.total * 0.6).ceil() ? 2 : widget.score >= 1 ? 1 : 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final pct = (widget.score / widget.total * 100).round();
    final message = _stars == 3 ? 'Perfect Score! 🏆'
      : _stars == 2 ? 'Well done! 👏'
      : _stars == 1 ? 'Good effort! 💪'
      : 'Keep exploring! 🗺️';

    return Scaffold(
      body: Stack(children: [
        Positioned.fill(child: Image.asset('assets/backgrounds/bg_result.jpg', fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: GVTheme.bg))),
        Positioned.fill(child: Container(color: GVTheme.bg.withOpacity(0.85))),
        SafeArea(child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(children: [
            const Spacer(),
            ScaleTransition(
              scale: _scale,
              child: Text(widget.nation.emoji, style: const TextStyle(fontSize: 72)),
            ),
            const SizedBox(height: 16),
            Text(widget.nation.name, style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 6),
            Text(message, style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: GVTheme.textSecondary)),
            const SizedBox(height: 28),
            StarDisplay(stars: _stars, size: 42),
            const SizedBox(height: 28),
            // Score circle
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: GVTheme.card,
                border: Border.all(color: GVTheme.gold, width: 2.5),
                boxShadow: [BoxShadow(color: GVTheme.gold.withOpacity(0.2), blurRadius: 24)],
              ),
              alignment: Alignment.center,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('$pct%', style: Theme.of(context).textTheme.displayMedium
                  ?.copyWith(color: GVTheme.gold, fontSize: 32)),
                Text('${widget.score} / ${widget.total}',
                  style: Theme.of(context).textTheme.bodyMedium),
              ]),
            ),
            const Spacer(),
            // Stats row
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: GVTheme.card, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: GVTheme.border)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _stat(context, '✅', '${widget.score}', 'Correct'),
                Container(width: 1, height: 36, color: GVTheme.border),
                _stat(context, '❌', '${widget.total - widget.score}', 'Wrong'),
                Container(width: 1, height: 36, color: GVTheme.border),
                _stat(context, '⭐', '$_stars', 'Stars'),
              ]),
            ),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: GVTheme.gold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('HOME', style: TextStyle(color: GVTheme.gold, letterSpacing: 1)),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: const Text('BACK'),
              )),
            ]),
            const SizedBox(height: 8),
          ]),
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
