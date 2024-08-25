import 'package:flutter/material.dart';
import 'package:radio/models/radio_station.dart';
import 'package:radio/services/shared_preferences_service.dart';

class RadioStorageProvider extends ChangeNotifier {
  final StorageServiceSingleton _sharedPreferencesService;

  RadioStation? _lastRadioPlayed;
  List<RadioStation> _favourites = [];

  RadioStorageProvider(this._sharedPreferencesService);

  RadioStation? get lastRadioPlayed => _lastRadioPlayed;
  List<RadioStation> get favorites => _favourites;

  Future<void> initialize() async {
    _lastRadioPlayed = await _sharedPreferencesService.fetchLastRadio();

    _favourites = await _sharedPreferencesService.fetchFavorites();
    notifyListeners();
  }

  Future<void> addLastRadio(RadioStation radioStation) async {
    _lastRadioPlayed = radioStation;
    await _sharedPreferencesService.addLastRadio(radioStation);
    notifyListeners();
  }

  Future<void> toggleFavorite(RadioStation radioStation) async {
    if (checkFavourite(radioStation)) {
      await _removeFavourite(radioStation);
    } else {
      await _addFavourite(radioStation);
    }
  }

  Future<void> _addFavourite(RadioStation radioStation) async {
    _favourites.add(radioStation);
    await _sharedPreferencesService.addFavourite(radioStation);
    notifyListeners();
  }

  Future<void> _removeFavourite(RadioStation radioStation) async {
    _favourites.remove(radioStation);
    await _sharedPreferencesService.removeFavourite(radioStation);
    notifyListeners();
  }

  bool checkFavourite(RadioStation radioStation) {
    return _favourites.any((element) => element.uuid == radioStation.uuid);
  }
}
