import 'package:flutter/cupertino.dart';
import 'package:radio/enum/radio_status.dart';
import 'package:radio/interfaces/i_radio_player_service.dart';
import 'package:radio/models/radio_station.dart';
import 'package:radio/services/shared_preferences_service.dart';

class RadioManagerProvider extends ChangeNotifier {
  // Planning to add last played radio station in the future
  final StorageServiceSingleton _storageService;

  final IRadioPlayerService _radioPlayerService;

  RadioStatus _radioStatus = RadioStatus.unInitialized;
  RadioStation? currentRadioStation;
  RadioStatus get radioStatus => _radioStatus;

  RadioManagerProvider(this._radioPlayerService, this._storageService) {
    initialize();
  }

  void play() {
    if (radioStatus.needsInitialization) {
      initialize();
    }

    _radioPlayerService.play();
    modifyStatus(RadioStatus.playing);
  }

  void initialize() {
    modifyStatus(RadioStatus.initializing);
    _radioPlayerService.initialize();

    modifyStatus(RadioStatus.ready);
  }

  void stop() {
    _radioPlayerService.stop();
    modifyStatus(RadioStatus.stopped);
  }

  void pause() {
    _radioPlayerService.pause();
    modifyStatus(RadioStatus.paused);
  }

  void setCurrentRadioStation(RadioStation radioStation) {
    if (_isCurrentRadioStation(radioStation)) {
      return;
    }

    if (radioStatus == RadioStatus.playing) {
      stop();
    }

    _radioPlayerService.switchRadioStation(radioStation.streamUrl);

    currentRadioStation = radioStation;

    modifyStatus(RadioStatus.playing);
  }

  void modifyStatus(RadioStatus status) {
    _radioStatus = status;
    notifyListeners();
  }

  void playOrPause() {
    if (currentRadioStation == null) return;
    if (radioStatus.isPlaying) {
      pause();
    } else {
      play();
    }
  }

  bool _isCurrentRadioStation(RadioStation radioStation) {
    return currentRadioStation?.uuid == radioStation.uuid;
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
