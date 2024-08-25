import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:radio/interfaces/i_radio_player_service.dart';

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
    } catch (t) {
      throw Exception('Failed to open audio stream');
    }
  }
}
