import 'package:radio/models/country.dart';
import 'package:radio/models/radio_station.dart';

abstract class IRadioStationBrowserApi {
  Future<List<Country>> getCountries();
  
  Future<List<RadioStation>> getTopVotedRadioStationsByCountry(String country);

  Future<List<RadioStation>> getRadioStationsByName(String name);

}