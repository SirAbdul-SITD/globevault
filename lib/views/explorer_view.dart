import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/nation.dart';
import '../services/vault_service.dart';
import '../services/music_service.dart';
import '../theme/gv_theme.dart';
import '../widgets/nation_card.dart';
import '../content/globe_content.dart';
import 'challenge_view.dart';

class ExplorerView extends StatefulWidget {
  const ExplorerView({super.key});
  @override State<ExplorerView> createState() => _ExplorerViewState();
}

class _ExplorerViewState extends State<ExplorerView> with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _regions = GlobeRegion.values;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _regions.length, vsync: this);
    _tab.addListener(_onTabChange);
  }

  void _onTabChange() {
    if (!_tab.indexIsChanging) {
      context.read<MusicService>().playForRegion(_regions[_tab.index]);
    }
  }

  @override void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VAULT EXPLORER'),
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          indicatorColor: GVTheme.gold,
          labelColor: GVTheme.gold,
          unselectedLabelColor: GVTheme.textSecondary,
          tabAlignment: TabAlignment.start,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          tabs: _regions.map((r) => Tab(text: '${r.emoji} ${r.label}')).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: _regions.map((region) => _RegionTab(region: region)).toList(),
      ),
    );
  }
}

class _RegionTab extends StatelessWidget {
  final GlobeRegion region;
  const _RegionTab({required this.region});

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultService>();
    final nations = GlobeContent.nationsFor(region);
    final progress = vault.regionProgress(region);
    final bgAsset = 'assets/backgrounds/bg_${region.name}.jpg';

    return Stack(children: [
      Positioned.fill(child: Image.asset(bgAsset, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: GVTheme.bg))),
      Positioned.fill(child: Container(color: GVTheme.bg.withOpacity(0.82))),
      Column(children: [
        // Region header
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: GVTheme.card, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GVTheme.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(region.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(region.label, style: Theme.of(context).textTheme.titleLarge),
                Text(region.description, style: Theme.of(context).textTheme.bodyMedium),
              ])),
              Text('${(progress * 100).round()}%',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: GVTheme.gold)),
            ]),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: GVTheme.border,
                valueColor: const AlwaysStoppedAnimation(GVTheme.gold),
                minHeight: 6,
              ),
            ),
          ]),
        ),
        Expanded(child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: nations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            final nation = nations[i];
            return NationCard(
              nation: nation,
              onTap: () async {
                await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ChallengeView(nation: nation)));
                if (context.mounted) setState(() {});
              },
            );
          },
        )),
      ]),
    ]);
  }
  
  void setState(Null Function() param0) {}
}
