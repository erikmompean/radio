import 'package:radio/interfaces/i_radio_db.dart';
import 'package:radio/models/radio_station.dart';
import 'package:radio/repositories/shared_preferences_repository.dart';

class StorageServiceSingleton {

  static final StorageServiceSingleton instance = StorageServiceSingleton._internal();
  
  StorageServiceSingleton._internal();

  final IRadioDb radioDb = SharedPreferencesRepository();

  Future<void> addFavourite(RadioStation radioStation) async {
    await radioDb.addFavourite(radioStation);
  }

  Future<List<RadioStation>> fetchFavorites() async {
    return await radioDb.getFavorites();
  }

  Future<void> addLastRadio(RadioStation radioStation) async {
    await radioDb.addLastRadio(radioStation);
  }

  Future<void> removeFavourite(RadioStation radioStation) async {
    await radioDb.removeFavorite(radioStation);
  }

  Future<RadioStation?> fetchLastRadio() async {
    return await radioDb.getLastRadio();
  }
}
