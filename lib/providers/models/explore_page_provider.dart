import 'package:flutter/widgets.dart';
import 'package:radio/models/radio_station.dart';
import 'package:radio/services/shared_preferences_service.dart';

class ExplorePageProvider extends ChangeNotifier {
  final StorageServiceSingleton _storageService = StorageServiceSingleton.instance;
  List<RadioStation> recommendedStations = [];

  Future<void> getRecommended() async {
    recommendedStations = await _storageService.fetchFavorites();
    notifyListeners();
  }
}
