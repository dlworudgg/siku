class PlaceDetailResponse {
  final Result result;
  final String status;

  PlaceDetailResponse({required this.result, required this.status});

  factory PlaceDetailResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailResponse(
      result: Result.fromJson(json['result']),
      status: json['status'],
    );
  }
}
//
// class Result {
//   final String name;
//   final String formattedAddress;
//   final Geometry geometry;
//   final List<String> weekdayText;
//   final List<String> photos;
//   final double rating;
//
//   Result({
//     required this.name,
//     required this.formattedAddress,
//     required this.geometry,
//     required this.weekdayText,
//     required this.photos,
//     required this.rating
//   });
//
//   factory Result.fromJson(Map<String, dynamic> json) {
//     return Result(
//       name: json['name'],
//       formattedAddress: json['formatted_address'],
//       geometry: Geometry.fromJson(json['geometry']),
//       weekdayText: List<String>.from(json['opening_hours']['weekday_text']),
//       photos: List<String>.from(json['photos'].map((item) => item['photo_reference'])),
//       rating: json['rating'],
//     );
//   }
// }

class Result {
  final String name;
  final String formattedAddress;
  final Geometry geometry;
  final List<String> weekdayText;
  final List<String> photos;
  final double rating;
  final String? editorialSummary;
  final int? priceLevel;
  final bool? reservable;
  final List<String> types;
  final int? userRatingsTotal;
  final String? website;
  final List<dynamic>? reviews;
  final bool? delivery;
  final bool? servesBeer;
  final bool? servesBrunch;
  final bool? servesDinner;
  final bool? servesLunch;
  final bool? servesVegetarianFood;
  final bool? servesWine;
  final bool? takeout;

  Result({
    required this.name,
    required this.formattedAddress,
    required this.geometry,
    required this.weekdayText,
    required this.photos,
    required this.rating,
    this.editorialSummary,
    this.priceLevel,
    this.reservable,
    required this.types,
    this.userRatingsTotal,
    this.website,
    this.reviews,
    this.delivery,
    this.servesBeer,
    this.servesBrunch,
    this.servesDinner,
    this.servesLunch,
    this.servesVegetarianFood,
    this.servesWine,
    this.takeout,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      name: json['name'],
      formattedAddress: json['formatted_address'],
      geometry: Geometry.fromJson(json['geometry']),
      weekdayText: List<String>.from(json['opening_hours']['weekday_text']),
      photos: List<String>.from(json['photos'].map((item) => item['photo_reference'])),
      rating: json['rating'],
      editorialSummary: json['editorial_summary'],
      priceLevel: json['price_level'],
      reservable: json['reservable'],
      types: List<String>.from(json['types']),
      userRatingsTotal: json['user_ratings_total'],
      website: json['website'],
      reviews: json['reviews'],
      delivery: json['delivery'],
      servesBeer: json['serves_beer'],
      servesBrunch: json['serves_brunch'],
      servesDinner: json['serves_dinner'],
      servesLunch: json['serves_lunch'],
      servesVegetarianFood: json['serves_vegetarian_food'],
      servesWine: json['serves_wine'],
      takeout: json['takeout'],
    );
  }
}



class Geometry {
  final Location location;

  Geometry({required this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: Location.fromJson(json['location']),
    );
  }
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
