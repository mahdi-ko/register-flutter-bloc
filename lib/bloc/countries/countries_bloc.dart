import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register/bloc/countries/country_repository.dart';
import 'countries_events.dart';
import 'countries_state.dart';
import 'package:http/http.dart' as http;

class CountriesBloc extends Bloc<CountriesEvents, CountriesState> {
  void _onEvent(CountriesEvents event, Emitter<CountriesState> emit) async {
    if (event is InitCountriesEvent && !state.isFetched) {
      try {
        final countries = await _fetchCountries();
        emit(state.copyWith(countries: countries, isFetched: true));

        final userCountry = await _fetchUserCountry();
        if (userCountry != null) {
          emit(state.copyWith(userCountry: userCountry));
        }
      } on Exception catch (error) {
        log(error.toString());
        emit(state.copyWith(isFailed: true, countries: []));
      }
    }
  }

  CountriesBloc()
      : super(CountriesState(
          countries: [],
        )) {
    on<CountriesEvents>(_onEvent);
  }

  Future<List<Country>> _fetchCountries() async {
    final String countriesJson =
        await rootBundle.loadString('files/countries.json');
    final countriesData =
        await json.decode(countriesJson) as Map<String, dynamic>;
    final countriesObhjects = countriesData["countries"] as List<dynamic>;
    final List<Country> countries =
        countriesObhjects.map((c) => Country.fromJson(c)).toList();
    return countries;
  }

  Future<Country?> _fetchUserCountry() async {
    //fetching user country based on public ip using ipify api
    final response = await http.get(Uri(
        scheme: 'https',
        host: 'geo.ipify.org',
        path: 'api/v2/country',
        queryParameters: {"apiKey": "at_ZL3tscuchDKwwwbcacJCjZ0ZBmK1o"}));
    final data = json.decode(response.body) as Map<String, dynamic>;
    final countryCode = data["location"]["country"];

    //looking for the country code in the fetched countries
    final countryIndex = state.countries.indexWhere(
        (country) => country.code.toLowerCase() == countryCode.toLowerCase());
    if (countryIndex != -1) {
      return state.countries[countryIndex];
    }
    return null;
  }
}
