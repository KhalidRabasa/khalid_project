import 'dart:convert';

import 'package:convertplus/model/currency.dart';
import 'package:http/http.dart';

Future<Response> getAllCurrencies(String base){
  return get('http://data.fixer.io/api/latest?access_key=8f694f1c5cae5c06626c07cbd30c5b07');
}

Future<CustomCurrency> getTheCurrencies(String base) async {
  final response = await getAllCurrencies(base);

  if(response.statusCode == 200){
    var c = CustomCurrency.fromJson(json.decode(response.body));

    if(c.success){
      return c;
    } else {
      return null;
    }
  } else {
    return null;
  }
}