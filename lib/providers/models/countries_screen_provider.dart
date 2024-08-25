import 'package:flutter/widgets.dart';
import 'package:radio/enum/data_state.dart';
import 'package:radio/interfaces/i_radio_station_browser_api.dart';
import 'package:radio/models/country.dart';

class CountriesScreenProvider extends ChangeNotifier {
  final IRadioStationBrowserApi _radioStationBrowserService;
  List<Country> countries = [];

  DataState _dataState = DataState.unInitialized;
  DataState get dataState => _dataState;

  CountriesScreenProvider(this._radioStationBrowserService);

  Future<void> initialize() async {
    try {
      countries = await _radioStationBrowserService.getCountries();

      countries.removeWhere((element) => element.code.isEmpty || element.name.isEmpty);
      _dataState = DataState.loaded;
      notifyListeners();
    } catch (e) {
      _dataState = DataState.error;
      notifyListeners();
    }
  }
}
