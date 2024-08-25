import 'dart:convert';

import 'package:http/http.dart';
import 'package:radio/interfaces/i_radio_station_browser_api.dart';
import 'package:radio/models/country.dart';
import 'package:radio/models/radio_station.dart';
import 'package:radio/utils/enviroment.dart';

class ApiRadioBrowser implements IRadioStationBrowserApi {
  static final ApiRadioBrowser instance = ApiRadioBrowser._internal();

  ApiRadioBrowser._internal();

  String baseUrl = Enviroment.apiRadioBrowser;

  @override
  Future<List<RadioStation>> getTopVotedRadioStationsByCountry(
      String country) async {
    var uri = Uri.parse('$baseUrl/json/stations/bycountry/$country')
        .replace(queryParameters: {
      'limit': '300',
      'order': 'votes',
      'reverse': 'true',
    });
    var response = await get(
      uri,
    );

    if (response.statusCode == 200) {
      List<RadioStation> radioStations = [];
      var utf8Response = utf8.decode(response.bodyBytes);
      List<dynamic> body = json.decode(utf8Response) as List<dynamic>;

      radioStations = body
          .map((e) => RadioStation.fromJson(e as Map<String, dynamic>))
          .toList();
      return radioStations;
    } else {
      throw Exception('Failed to load radio stations');
    }
  }

  @override
  Future<List<RadioStation>> getRadioStationsByName(String name) async {
    var uri = Uri.parse('$baseUrl/json/stations/byname/$name')
        .replace(queryParameters: {
      'limit': '20',
      'order': 'votes',
      'reverse': 'true',
    });
    var response = await get(
      uri,
    );

    if (response.statusCode == 200) {
      List<RadioStation> radioStations = [];
      var utf8Response = utf8.decode(response.bodyBytes);
      List<dynamic> body = json.decode(utf8Response) as List<dynamic>;

      radioStations = body
          .map((e) => RadioStation.fromJson(e as Map<String, dynamic>))
          .toList();
      return radioStations;
    } else {
      throw Exception('Failed to load radio stations');
    }
  }

  @override
  Future<List<Country>> getCountries() async {
    var uri = Uri.parse('$baseUrl/json/countries');
    var response = await get(
      uri,
    );

    if (response.statusCode == 200) {
      List<Country> countries = [];
      var utf8Response = utf8.decode(response.bodyBytes);

      List<dynamic> body = json.decode(utf8Response) as List<dynamic>;

      countries =
          body.map((e) => Country.fromJson(e as Map<String, dynamic>)).toList();
      return countries;
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
