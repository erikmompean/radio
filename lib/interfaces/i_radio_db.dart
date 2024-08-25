import 'package:radio/models/radio_station.dart';

abstract class IRadioDb {
  Future<void> initialize();

  Future<void> addLastRadio(RadioStation radioStation);

  Future<RadioStation?> getLastRadio();

  Future<List<RadioStation>> getFavorites();

  Future<void> addFavourite(RadioStation radioStation);

  Future<void> removeFavorite(RadioStation radioStation);
}
