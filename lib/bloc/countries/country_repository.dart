class Country {
  final int id;
  final int currencyId;
  final String name;
  final String code;
  final int numCode;
  final int phoneCode;
  final String timezoneCode;
  final int phoneDigits;

  Country({
    this.id = 0,
    this.currencyId = 0,
    this.name = '',
    this.code = '',
    this.numCode = 0,
    this.phoneCode = 0,
    this.timezoneCode = '',
    this.phoneDigits = 0,
  });
  Country.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        currencyId = json['currencyId'],
        name = json['name'],
        code = json['code'],
        numCode = json['num_code'],
        phoneCode = json['phone_code'],
        timezoneCode = json['timezone_code'],
        phoneDigits = json['phone_digits'];
}
