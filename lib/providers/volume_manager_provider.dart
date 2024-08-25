import 'dart:async';

import 'package:flutter/material.dart';
import 'package:radio/interfaces/i_radio_player_service.dart';

class VolumeManagerProvider extends ChangeNotifier {
  final IRadioPlayerService _radioPlayerService;

  double _volume = 0.0;
  StreamSubscription<double>? _volumeSubscription;

  double get volume => _volume;

  VolumeManagerProvider(this._radioPlayerService);

  Future<void> initialize() async {
    _volume = await getVolume();

    notifyListeners();
    _volumeSubscription =
        _radioPlayerService.getVolumeStream().listen((volume) {
      _volume = volume;
      notifyListeners();
    });
  }

  Future<void> setVolume(double newVolume) async {
    await _radioPlayerService.setVolume(newVolume);
    _volume = newVolume;
    notifyListeners();
  }

  Future<double> getVolume() {
    return _radioPlayerService.getVolume();
  }

  @override
  void dispose() {
    super.dispose();
    _volumeSubscription?.cancel();
  }
}
