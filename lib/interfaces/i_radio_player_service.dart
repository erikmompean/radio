abstract class IRadioPlayerService {
  void initialize();

  void play();

  void stop();

  void pause();

  void switchRadioStation(String url);

  Future<void> setVolume(double volume);

  Stream<double> getVolumeStream();

  Future<double> getVolume();
}
