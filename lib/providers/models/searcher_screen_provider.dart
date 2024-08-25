import 'package:flutter/material.dart';
import 'package:radio/enum/data_state.dart';
import 'package:radio/interfaces/i_radio_station_browser_api.dart';
import 'package:radio/models/radio_station.dart';

class SearcherScreenProvider extends ChangeNotifier {
  final IRadioStationBrowserApi _radioStationBrowserService;
  final String? country;
  DataState _dataState = DataState.unInitialized;
  DataState get dataState => _dataState;
  List<RadioStation> countryRadioStations = [];
  List<RadioStation> filteredRadioStations = [];
  TextEditingController searchController = TextEditingController();

  SearcherScreenProvider(
    this._radioStationBrowserService, {
    required this.country,
  });

  Future<void> initialize() async {
    if (country != null) {
      _dataState = DataState.loading;
      notifyListeners();

      countryRadioStations = await _getRadiosByCountries();
      filteredRadioStations = countryRadioStations;
      _dataState = DataState.loaded;
    }

    notifyListeners();
  }

  Future<void> search(String value) async {
    try {
      if (value.isEmpty) {
        filteredRadioStations = [];
        _dataState = DataState.loaded;
        notifyListeners();

        return;
      }

      _dataState = DataState.loading;
      notifyListeners();
      if (country == null) {
        filteredRadioStations = await _getSearchAllScreenListByName(value);
      } else {
        filteredRadioStations = countryRadioStations
            .where((element) =>
                element.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
      _dataState = DataState.loaded;
      notifyListeners();
    } catch (e) {
      _dataState = DataState.error;
      notifyListeners();
    }
  }

  Future<List<RadioStation>> _getSearchAllScreenListByName(String name) async {
    return await _radioStationBrowserService.getRadioStationsByName(name);
  }

  Future<List<RadioStation>> _getRadiosByCountries() async {
    return await _radioStationBrowserService
        .getTopVotedRadioStationsByCountry(country!);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
