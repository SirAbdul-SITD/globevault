import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPool? _tapPool;
  final AudioPool? _correctPool;
  final AudioPool? _wrongPool;
  final AudioPool? _unlockPool;
  final AudioPool? _completePool;
  bool _muted = false;

  SoundService._({
    AudioPool? tap,
    AudioPool? correct,
    AudioPool? wrong,
    AudioPool? unlock,
    AudioPool? complete,
  })  : _tapPool = tap,
        _correctPool = correct,
        _wrongPool = wrong,
        _unlockPool = unlock,
        _completePool = complete;

  static Future<SoundService> create() async {
    try {
      final tap = await AudioPool.create(source: AssetSource('sounds/tap.wav'), maxPlayers: 3);
      final correct = await AudioPool.create(source: AssetSource('sounds/correct.wav'), maxPlayers: 2);
      final wrong = await AudioPool.create(source: AssetSource('sounds/wrong.wav'), maxPlayers: 2);
      final unlock = await AudioPool.create(source: AssetSource('sounds/unlock.wav'), maxPlayers: 1);
      final complete = await AudioPool.create(source: AssetSource('sounds/complete.wav'), maxPlayers: 1);
      return SoundService._(tap: tap, correct: correct, wrong: wrong, unlock: unlock, complete: complete);
    } catch (_) {
      return SoundService._();
    }
  }

  bool get muted => _muted;
  void toggleMute() => _muted = !_muted;

  void tap() { if (!_muted) _tapPool?.start(); }
  void correct() { if (!_muted) _correctPool?.start(); }
  void wrong() { if (!_muted) _wrongPool?.start(); }
  void unlock() { if (!_muted) _unlockPool?.start(); }
  void complete() { if (!_muted) _completePool?.start(); }
}
