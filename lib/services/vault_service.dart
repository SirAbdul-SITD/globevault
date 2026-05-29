import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../content/globe_content.dart';
import '../models/nation.dart';

class VaultService extends ChangeNotifier {
  late SharedPreferences _prefs;

  // nationId -> stars (0-3)
  final Map<String, int> _stars = {};
  // nationId -> best score (0-5)
  final Map<String, int> _scores = {};

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _load();
  }

  void _load() {
    for (final nation in GlobeContent.allNations) {
      _stars[nation.id] = _prefs.getInt('stars_${nation.id}') ?? 0;
      _scores[nation.id] = _prefs.getInt('score_${nation.id}') ?? 0;
    }
  }

  int starsFor(String id) => _stars[id] ?? 0;
  int scoreFor(String id) => _scores[id] ?? 0;

  bool isUnlocked(Nation nation) {
    final regionNations = GlobeContent.nationsFor(nation.region);
    final idx = regionNations.indexWhere((n) => n.id == nation.id);
    if (idx == 0) return true; // first always unlocked
    final prev = regionNations[idx - 1];
    return (_stars[prev.id] ?? 0) >= 1;
  }

  Future<void> saveResult(String id, int score) async {
    final stars = score >= 5 ? 3 : score >= 3 ? 2 : score >= 1 ? 1 : 0;
    final prevStars = _stars[id] ?? 0;
    final prevScore = _scores[id] ?? 0;

    if (stars > prevStars) {
      _stars[id] = stars;
      await _prefs.setInt('stars_${id}', stars);
    }
    if (score > prevScore) {
      _scores[id] = score;
      await _prefs.setInt('score_${id}', score);
    }
    notifyListeners();
  }

  int totalStars() => _stars.values.fold(0, (a, b) => a + b);

  int unlockedCount() =>
      GlobeContent.allNations.where((n) => isUnlocked(n)).length;

  int completedCount() =>
      _stars.values.where((s) => s > 0).length;

  double regionProgress(GlobeRegion region) {
    final nations = GlobeContent.nationsFor(region);
    if (nations.isEmpty) return 0;
    final done = nations.where((n) => (_stars[n.id] ?? 0) > 0).length;
    return done / nations.length;
  }
}
