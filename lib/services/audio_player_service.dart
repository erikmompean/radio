import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:radio/interfaces/i_radio_player_service.dart';
import 'package:real_volume/real_volume.dart';

class AudioPlayerService implements IRadioPlayerService {
  AssetsAudioPlayer? assetsAudioPlayer;

  @override
  void initialize() {
    // Using withId we ensure that we are using the same instance of the player
    assetsAudioPlayer ??= AssetsAudioPlayer.withId('radio_player');
  }

  @override
  void play() async {
    if (assetsAudioPlayer == null) {
      throw Exception('Audio Player is not initialized');
    }

    assetsAudioPlayer!.play();
  }

  @override
  void stop() async {
    if (assetsAudioPlayer == null) {
      throw Exception('Audio Player is not initialized');
    }
    assetsAudioPlayer!.stop();
  }

  @override
  void pause() async {
    if (assetsAudioPlayer == null) {
      throw Exception('Audio Player is not initialized');
    }
    await assetsAudioPlayer!.pause();
  }

  @override
  void switchRadioStation(String url) async {
    if (assetsAudioPlayer == null) {
      throw Exception('Audio Player is not initialized');
    }

    try {
      await assetsAudioPlayer!.open(
        Audio.liveStream(url),
      );
    } catch (_) {
      throw Exception('Failed to open audio stream');
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    await RealVolume.setVolume(volume,
        showUI: true, streamType: StreamType.MUSIC);
  }

  @override
  Stream<double> getVolumeStream() {
    return RealVolume.onVolumeChanged.map((event) => event.volumeLevel);
  }

  @override
  Future<double> getVolume() async {
    return (await RealVolume.getCurrentVol(StreamType.MUSIC)) ?? 0.0;
  }
}
