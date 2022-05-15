import 'package:register/bloc/countries/country_repository.dart';

class CountriesState {
  final List<Country> countries;
  final Country? userCountry;
  final bool isFetched;
  final bool isFailed;

  CountriesState(
      {required this.countries,
      this.userCountry,
      this.isFetched = false,
      this.isFailed = false});

  CountriesState copyWith({
    List<Country>? countries,
    Country? userCountry,
    bool? isFetched,
    bool? isFailed,
  }) {
    return CountriesState(
      countries: countries ?? this.countries,
      isFetched: isFetched ?? this.isFetched,
      isFailed: isFailed ?? this.isFailed,
      userCountry: userCountry ?? this.userCountry,
    );
  }
}
