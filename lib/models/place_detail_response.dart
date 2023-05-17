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

class Result {
  final String name;
  final String formattedAddress;
  final Geometry geometry;
  final List<String> weekdayText;
  final List<String> photos;
  final double rating;

  Result({
    required this.name,
    required this.formattedAddress,
    required this.geometry,
    required this.weekdayText,
    required this.photos,
    required this.rating
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      name: json['name'],
      formattedAddress: json['formatted_address'],
      geometry: Geometry.fromJson(json['geometry']),
      weekdayText: List<String>.from(json['opening_hours']['weekday_text']),
      photos: List<String>.from(json['photos'].map((item) => item['photo_reference'])),
      rating: json['rating'],
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
