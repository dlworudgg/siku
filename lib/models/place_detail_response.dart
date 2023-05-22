// class PlaceDetailResponse {
//   final Result result;
//   final String status;
//
//   PlaceDetailResponse({required this.result, required this.status});
//
//   factory PlaceDetailResponse.fromJson(Map<String, dynamic> json) {
//     return PlaceDetailResponse(
//       result: Result.fromJson(json['result']),
//       status: json['status'],
//     );
//   }
// }
// //
// // class Result {
// //   final String name;
// //   final String formattedAddress;
// //   final Geometry geometry;
// //   final List<String> weekdayText;
// //   final List<String> photos;
// //   final double rating;
// //
// //   Result({
// //     required this.name,
// //     required this.formattedAddress,
// //     required this.geometry,
// //     required this.weekdayText,
// //     required this.photos,
// //     required this.rating
// //   });
// //
// //   factory Result.fromJson(Map<String, dynamic> json) {
// //     return Result(
// //       name: json['name'],
// //       formattedAddress: json['formatted_address'],
// //       geometry: Geometry.fromJson(json['geometry']),
// //       weekdayText: List<String>.from(json['opening_hours']['weekday_text']),
// //       photos: List<String>.from(json['photos'].map((item) => item['photo_reference'])),
// //       rating: json['rating'],
// //     );
// //   }
// // }
//
// class Result {
//   final String? name;
//   final String? formattedAddress;
//   final Geometry? geometry;
//   final List<String>? weekdayText;
//   final List<String>? photos;
//   final double? rating;
//   final EditorialSummary? editorialSummary;
//   final int? priceLevel;
//   final bool? reservable;
//   final List<String> types;
//   final int? userRatingsTotal;
//   final String? website;
//   final List<dynamic>? reviews;
//   final bool? delivery;
//   final bool? servesBeer;
//   final bool? servesBrunch;
//   final bool? servesDinner;
//   final bool? servesLunch;
//   final bool? servesVegetarianFood;
//   final bool? servesWine;
//   final bool? takeout;
//
//   Result({
//     this.name,
//     this.formattedAddress,
//     this.geometry,
//     this.weekdayText,
//     this.photos,
//     this.rating,
//     this.editorialSummary,
//     this.priceLevel,
//     this.reservable,
//     this.types,
//     this.userRatingsTotal,
//     this.website,
//     this.reviews,
//     this.delivery,
//     this.servesBeer,
//     this.servesBrunch,
//     this.servesDinner,
//     this.servesLunch,
//     this.servesVegetarianFood,
//     this.servesWine,
//     this.takeout,
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
//       editorialSummary: EditorialSummary.fromJson(json['editorial_summary']),
//       priceLevel: json['price_level'],
//       reservable: json['reservable'],
//       types: List<String>.from(json['types']),
//       userRatingsTotal: json['user_ratings_total'],
//       website: json['website'],
//       reviews: json['reviews']?.map((json) => Review.fromJson(json as Map<String, dynamic>)).toList(),
//       delivery: json['delivery'],
//       servesBeer: json['serves_beer'],
//       servesBrunch: json['serves_brunch'],
//       servesDinner: json['serves_dinner'],
//       servesLunch: json['serves_lunch'],
//       servesVegetarianFood: json['serves_vegetarian_food'],
//       servesWine: json['serves_wine'],
//       takeout: json['takeout'],
//     );
//   }
// }
//
//
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
//       lat: json['lat'],
//       lng: json['lng'],
//     );
//   }
// }
//
//
// class EditorialSummary{
//   final String overview;
//
//
//   EditorialSummary({required this.overview});
//
//   factory EditorialSummary .fromJson(Map<String, dynamic> json) {
//     return EditorialSummary (
//       overview: json['overview'],
//     );
//   }
// }
//
// class Review{
//   final String text;
//   final double rating;
//
//
//   Review({required this.text, required this.rating});
//
//   factory Review.fromJson(Map<String, dynamic> json) {
//     return Review(
//       text: json['text'],
//       rating: json['rating']
//     );
//   }
// }
class PlaceDetailResponse {
  final Result result;
  final String status;

  PlaceDetailResponse({required this.result, required this.status});

  factory PlaceDetailResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailResponse(
      result: Result.fromJson(json['result'] as Map<String, dynamic>),
      status: json['status'] as String,
    );
  }
}

class Result {
  final String? name;
  final String? formattedAddress;
  final Geometry? geometry;
  final List<String>? weekdayText;
  // final List<String>? photos;
  final PhotosList? photosList;
  final double? rating;
  final EditorialSummary? editorialSummary;
  final int? priceLevel;
  final bool? reservable;
  final List<String>? types;
  final int? userRatingsTotal;
  final String? website;
  // final List<Review>? reviews;
  final ReviewsList? reviewList;
  final bool? delivery;
  final bool? servesBeer;
  final bool? servesBrunch;
  final bool? servesDinner;
  final bool? servesLunch;
  final bool? servesVegetarianFood;
  final bool? servesWine;
  final bool? takeout;

  Result({
    this.name,
    this.formattedAddress,
    this.geometry,
    this.weekdayText,
    // this.photos,
    this.photosList,
    this.rating,
    this.editorialSummary,
    this.priceLevel,
    this.reservable,
    this.types,
    this.userRatingsTotal,
    this.website,
    // this.reviews,
    this.reviewList,
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
      name: json['name'] as String?,
      formattedAddress: json['formatted_address'] as String?,
      geometry: json['geometry'] != null ? Geometry.fromJson(json['geometry'] as Map<String, dynamic>) : null,
      weekdayText: (json['opening_hours']?['weekday_text'] as List<dynamic>?)?.cast<String>(),
      // photos: (json['photos']?.map((item) => item['photo_reference'] as String)?.toList()),
      photosList: json['photos'] != null ? PhotosList.fromJson({'photo': json['photos']}) : null,
      rating: json['rating'] as double?,
      editorialSummary: json['editorial_summary'] != null ? EditorialSummary.fromJson(json['editorial_summary'] as Map<String, dynamic>) : null,
      priceLevel: json['price_level'] as int?,
      reservable: json['reservable'] as bool?,
      types: (json['types'] as List<dynamic>?)?.cast<String>(),
      userRatingsTotal: json['user_ratings_total'] as int?,
      website: json['website'] as String?,
      // reviews: (json['reviews']?.map((json) => Review.fromJson(json as Map<String, dynamic>))?.toList()),
      reviewList: json['reviews'] != null ? ReviewsList.fromJson({'review': json['reviews']}) : null,
      delivery: json['delivery'] as bool?,
      servesBeer: json['serves_beer'] as bool?,
      servesBrunch: json['serves_brunch'] as bool?,
      servesDinner: json['serves_dinner'] as bool?,
      servesLunch: json['serves_lunch'] as bool?,
      servesVegetarianFood: json['serves_vegetarian_food'] as bool?,
      servesWine: json['serves_wine'] as bool?,
      takeout: json['takeout'] as bool?,
    );
  }
}

class Geometry {
  final Location? location;

  Geometry({this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: json['location'] != null ? Location.fromJson(json['location'] as Map<String, dynamic>) : null,
    );
  }
}

class Location {
  final double? lat;
  final double? lng;

  Location({this.lat, this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'] as double?,
      lng: json['lng'] as double?,
    );
  }
}

class EditorialSummary{
  final String? overview;

  EditorialSummary({this.overview});

  factory EditorialSummary.fromJson(Map<String, dynamic> json) {
    return EditorialSummary(
      overview: json['overview'] as String?,
    );
  }
}
class Photo {
  final int? height;
  final List<String>? htmlAttributions;
  final String? photoReference;
  final int? width;

  Photo({
    required this.height,
    required this.htmlAttributions,
    required this.photoReference,
    required this.width,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      height: json['height'] as int?,
      htmlAttributions: json['html_attributions'] != null
          ? List<String>.from(json['html_attributions'].map((x) => x as String))
          : null,
      photoReference: json['photo_reference'] as String?,
      width: json['width'] as int?,
    );
  }
}

class PhotosList {
  final List<Photo>? photos;

  PhotosList({
    required this.photos,
  });

  factory PhotosList.fromJson(Map<String, dynamic> json) {
    return PhotosList(
      photos: json['photo'] != null
          ? List<Photo>.from(json['photo'].map((x) => Photo.fromJson(x)))
          : null,
    );
  }
}




class Review{
  final String? text;
  final double? rating;

  Review({this.text, this.rating});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      text: json['text'] as String?,
      rating: json['rating'] as double?,
    );
  }
}


class ReviewsList {
  final List<Review>? review;

  ReviewsList({
    required this.review,
  });

  factory ReviewsList.fromJson(Map<String, dynamic> json) {
    return ReviewsList(
      review: json['reviews'] != null
          ? List<Review>.from(json['reviews'].map((x) => Review.fromJson(x)))
          : null,
    );
  }
}