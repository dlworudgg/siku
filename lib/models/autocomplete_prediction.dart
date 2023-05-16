class AutocompletePrediction {
  final String? description;
  final StructuredFormatting? structuredFormatting;
  final String? placeId;
  final String? reference;
  final List<String>? types;
  // final Geometry? geometry;


  AutocompletePrediction({this.description,
    this.structuredFormatting, this.placeId,
    this.reference,
    this.types,
    // this.geometry,
  });

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['description'] as String?,
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
      types: json['types'] != null
          ? List<String>.from(json['types'].map((x) => x as String))
          : null,
      // geometry: json['geometry'] != null
      //     ? Geometry.fromJson(json['geometry'])
      //     : null,
    );
  }
}

class StructuredFormatting {
  final String? mainText;
  final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic>json){
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }
}

//
// class Geometry {
//   final Location location;
//
//   Geometry({required this.location});
//
//   factory Geometry.fromJson(Map<String, dynamic> json) {
//     return Geometry(
//       location: Location.fromJson(json['location']),
//     );
//   }
// }
//
// class Location {
//   final double lat;
//   final double lng;
//
//   Location({required this.lat, required this.lng});
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       lat: json['lat'] as double,
//       lng: json['lng'] as double,
//     );
//   }
// }


