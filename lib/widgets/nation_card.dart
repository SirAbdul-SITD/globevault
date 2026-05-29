import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/nation.dart';
import '../services/vault_service.dart';
import '../theme/gv_theme.dart';
import 'star_display.dart';

class NationCard extends StatelessWidget {
  final Nation nation;
  final VoidCallback? onTap;
  const NationCard({super.key, required this.nation, this.onTap});

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultService>();
    final unlocked = vault.isUnlocked(nation);
    final stars = vault.starsFor(nation.id);
    final score = vault.scoreFor(nation.id);

    return GestureDetector(
      onTap: unlocked ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: unlocked ? GVTheme.card : GVTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: stars > 0
                ? GVTheme.gold.withOpacity(0.5)
                : unlocked
                    ? GVTheme.border
                    : GVTheme.border.withOpacity(0.4),
            width: stars > 0 ? 1.5 : 1,
          ),
          boxShadow: stars > 0
              ? [BoxShadow(color: GVTheme.gold.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: unlocked
                      ? (stars > 0 ? GVTheme.gold.withOpacity(0.12) : GVTheme.border.withOpacity(0.5))
                      : GVTheme.bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  unlocked ? nation.emoji : '🔒',
                  style: TextStyle(fontSize: unlocked ? 28 : 22),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unlocked ? nation.name : 'Locked',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: unlocked ? GVTheme.textPrimary : GVTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (unlocked && stars > 0) ...[
                      StarDisplay(stars: stars, size: 16),
                      const SizedBox(height: 2),
                      Text('Best: $score/5', style: Theme.of(context).textTheme.bodyMedium),
                    ] else if (unlocked) ...[
                      Text('5 challenges', style: Theme.of(context).textTheme.bodyMedium),
                    ] else ...[
                      Text('Complete previous nation', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ],
                ),
              ),
              if (unlocked)
                Icon(
                  stars > 0 ? Icons.replay_rounded : Icons.play_arrow_rounded,
                  color: stars > 0 ? GVTheme.gold : GVTheme.teal,
                  size: 26,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
