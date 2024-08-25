import 'package:flutter/material.dart';
import 'package:radio/enum/data_state.dart';
import 'package:radio/interfaces/i_radio_station_browser_api.dart';
import 'package:radio/models/radio_station.dart';

class MainListPageProvider extends ChangeNotifier {
  final IRadioStationBrowserApi _radioStationBrowserApi;

  DataState _dataStatus = DataState.unInitialized;

  DataState get dataStatus => _dataStatus;

  List<RadioStation> radioStations = [];

  MainListPageProvider(this._radioStationBrowserApi);

  Future<List<RadioStation>> getTopVotedRadioStations(String country) async {
    try {
      modifyDataStatus(DataState.loading);

      radioStations = await _radioStationBrowserApi.getTopVotedRadioStationsByCountry(country);

      // Sort radio stations by the ones that have a favicon first
      radioStations
          .sort((a, b) => a.favicon == null || a.favicon!.isEmpty ? 1 : 0);

      modifyDataStatus(DataState.loaded);
      return radioStations;
    } catch (e) {
      modifyDataStatus(DataState.error);
      return [];
    }
  }

  void modifyDataStatus(DataState status) {
    _dataStatus = status;
    notifyListeners();
  }
}
