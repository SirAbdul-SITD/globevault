import 'package:audioplayers/audioplayers.dart';
import '../models/nation.dart';

class MusicService {
  final AudioPlayer _player = AudioPlayer();
  bool _muted = false;
  String? _currentTrack;

  bool get muted => _muted;

  Future<void> playForRegion(GlobeRegion region) async {
    final track = _trackFor(region);
    if (track == _currentTrack && _player.state == PlayerState.playing) return;
    _currentTrack = track;
    if (_muted) return;
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.28);
      await _player.play(AssetSource('music/$track'));
    } catch (_) {}
  }

  Future<void> playMenu() async {
    const track = 'ambient_menu.wav';
    if (_currentTrack == track && _player.state == PlayerState.playing) return;
    _currentTrack = track;
    if (_muted) return;
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.22);
      await _player.play(AssetSource('music/$track'));
    } catch (_) {}
  }

  Future<void> stop() async {
    try { await _player.stop(); } catch (_) {}
    _currentTrack = null;
  }

  Future<void> toggleMute() async {
    _muted = !_muted;
    if (_muted) {
      try { await _player.setVolume(0); } catch (_) {}
    } else {
      try { await _player.setVolume(0.28); } catch (_) {}
    }
  }

  String _trackFor(GlobeRegion region) {
    switch (region) {
      case GlobeRegion.africa:   return 'ambient_africa.wav';
      case GlobeRegion.americas: return 'ambient_americas.wav';
      case GlobeRegion.asia:     return 'ambient_asia.wav';
      case GlobeRegion.europe:   return 'ambient_europe.wav';
      case GlobeRegion.oceania:  return 'ambient_oceania.wav';
    }
  }

  void dispose() => _player.dispose();
}
