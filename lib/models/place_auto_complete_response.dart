import 'dart:convert';
import 'autocomplete_prediction.dart';


class PlaceAutocompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;

  PlaceAutocompleteResponse({this.status, this.predictions});

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    var allPredictions = (json['predictions'] as List)
        .map((json) => AutocompletePrediction.fromJson(json))
        .toList();

    var filteredPredictions = allPredictions.where((prediction) {
      if (prediction.types != null) {
        var typesSet = prediction.types!.toSet();
        return typesSet.contains('bakery') ||
            typesSet.contains('bar') ||
            typesSet.contains('cafe') ||
            typesSet.contains('meal_delivery') ||
            typesSet.contains('meal_takeaway') ||
            typesSet.contains('restaurant');
      }
      return false;
    }).toList();

    return PlaceAutocompleteResponse(
      status: json['status'] as String?,
      predictions: filteredPredictions,
    );
  }

  static PlaceAutocompleteResponse parseAutocompleteResult(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();

    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}