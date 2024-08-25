import 'dart:convert';

import 'package:radio/interfaces/i_radio_db.dart';
import 'package:radio/models/radio_station.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository implements IRadioDb {
  SharedPreferences? prefs;
  @override
  Future<void> initialize() async {
    prefs ??= await SharedPreferences.getInstance();

    
  }

  @override
  Future<void> addLastRadio(RadioStation radioStation) async {
    await initialize();

    prefs!.setString('last', json.encode(radioStation.toJson()));
  }

  @override
  Future<RadioStation?> getLastRadio() async {
    await initialize();

    var jsonString = prefs!.getString('last');

    if (jsonString == null) {
      return null;
    }

    return RadioStation.fromJson(
        json.decode(jsonString) as Map<String, dynamic>);
  }

  @override
  Future<void> addFavourite(RadioStation radioStation) async {
    await initialize();

    var radioStations = await getFavorites();

    radioStations.add(radioStation);

    await saveFavorites(radioStations);
  }

  @override
  Future<List<RadioStation>> getFavorites() async {
    await initialize();

    var jsonString = prefs!.getString('favorites');

    if (jsonString == null) {
      return [];
    }
    List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

    return jsonList
        .map((e) => RadioStation.fromJson(e as Map<String, dynamic>))
        .toList();
  }



  @override
  Future<void> removeFavorite(RadioStation radioStation) async {
    await initialize();

    var radioStations = await getFavorites();

    radioStations.removeWhere((element) => element.uuid == radioStation.uuid);

    await saveFavorites(radioStations);
  }

  Future<void> saveFavorites(List<RadioStation> radioStations) async {
    await initialize();

    var jsonList = radioStations.map((e) => e.toJson()).toList();

    prefs!.setString('favorites', json.encode(jsonList));
  }
}
