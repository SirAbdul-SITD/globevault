enum ChallengeType { mcq, typeIn }

enum GlobeRegion {
  africa,
  americas,
  asia,
  europe,
  oceania;

  String get label {
    switch (this) {
      case GlobeRegion.africa: return 'Africa';
      case GlobeRegion.americas: return 'Americas';
      case GlobeRegion.asia: return 'Asia';
      case GlobeRegion.europe: return 'Europe';
      case GlobeRegion.oceania: return 'Oceania & M.E.';
    }
  }

  String get emoji {
    switch (this) {
      case GlobeRegion.africa: return '🌍';
      case GlobeRegion.americas: return '🌎';
      case GlobeRegion.asia: return '🌏';
      case GlobeRegion.europe: return '🏰';
      case GlobeRegion.oceania: return '🌊';
    }
  }

  String get description {
    switch (this) {
      case GlobeRegion.africa: return '20 Nations · 100 Challenges';
      case GlobeRegion.americas: return '20 Nations · 100 Challenges';
      case GlobeRegion.asia: return '30 Nations · 150 Challenges';
      case GlobeRegion.europe: return '20 Nations · 100 Challenges';
      case GlobeRegion.oceania: return '10 Nations · 50 Challenges';
    }
  }
}

class Challenge {
  final String text;
  final ChallengeType type;
  final String answer;
  final List<String> options; // MCQ only
  final String hint; // typeIn only

  const Challenge({
    required this.text,
    required this.type,
    required this.answer,
    this.options = const [],
    this.hint = '',
  });
}

class Nation {
  final String id;
  final String name;
  final String emoji;
  final GlobeRegion region;
  final List<Challenge> challenges;

  const Nation({
    required this.id,
    required this.name,
    required this.emoji,
    required this.region,
    required this.challenges,
  });
}
