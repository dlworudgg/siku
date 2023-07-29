import 'package:hive/hive.dart';

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

@HiveType(typeId: 0)
class Result {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final String? formattedAddress;
  @HiveField(2)
  final Geometry? geometry;
  @HiveField(3)
  final List<String>? weekdayText;
  @HiveField(4)
  final PhotosList? photosList;
  @HiveField(5)
  final double? rating;
  @HiveField(6)
  final EditorialSummary? editorialSummary;
  @HiveField(7)
  final int? priceLevel;
  @HiveField(8)
  final bool? reservable;
  @HiveField(9)
  final List<String>? types;
  @HiveField(10)
  final int? userRatingsTotal;
  @HiveField(11)
  final String? website;
  @HiveField(12)
  final List<Reviews>? reviews;
  @HiveField(13)
  final bool? delivery;
  @HiveField(14)
  final bool? servesBeer;
  @HiveField(15)
  final bool? servesBrunch;
  @HiveField(16)
  final bool? servesDinner;
  @HiveField(17)
  final bool? servesLunch;
  @HiveField(18)
  final bool? servesVegetarianFood;
  @HiveField(19)
  final bool? servesWine;
  @HiveField(20)
  final bool? takeout;
  @HiveField(21)
  final String? placeId;

  Result({
    this.name,
    this.formattedAddress,
    this.geometry,
    this.weekdayText,
    this.photosList,
    this.rating,
    this.editorialSummary,
    this.priceLevel,
    this.reservable,
    this.types,
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
    this.placeId,
  });


  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      name: json['name'] as String?,
      formattedAddress: json['formatted_address'] as String?,
      geometry: json['geometry'] != null ? Geometry.fromJson(json['geometry'] as Map<String, dynamic>) : null,
      weekdayText: (json['opening_hours']?['weekday_text'] as List<dynamic>?)?.cast<String>(),
      photosList: json['photos'] != null ? PhotosList.fromJson({'photo': json['photos']}) : null,
      rating: json['rating'] as double?,
      editorialSummary: json['editorial_summary'] != null ? EditorialSummary.fromJson(json['editorial_summary'] as Map<String, dynamic>) : null,
      priceLevel: json['price_level'] as int?,
      reservable: json['reservable'] as bool?,
      types: (json['types'] as List<dynamic>?)?.cast<String>(),
      userRatingsTotal: json['user_ratings_total'] as int?,
      website: json['website'] as String?,
      reviews: json['reviews'] != null ? (json['reviews'] as List<dynamic>).map((item) => Reviews.fromJson(item as Map<String, dynamic>)).toList() : null,
      delivery: json['delivery'] as bool?,
      servesBeer: json['serves_beer'] as bool?,
      servesBrunch: json['serves_brunch'] as bool?,
      servesDinner: json['serves_dinner'] as bool?,
      servesLunch: json['serves_lunch'] as bool?,
      servesVegetarianFood: json['serves_vegetarian_food'] as bool?,
      servesWine: json['serves_wine'] as bool?,
      takeout: json['takeout'] as bool?,
      placeId : json['place_id'] as String?,
    );
  }
  Map<String, dynamic> toFirestoreMap() {
    return {
      'Name': name,
      'delivery': delivery,
      'editorialSummary': editorialSummary?.overview,
      'formatted_address': formattedAddress,
      'geometry': {
        'lat': geometry?.location?.lat,
        'lng': geometry?.location?.lng
      },
      'photos': photosList?.photos?.map((photo) => {
        'height': photo.height,
        'html_attributions': photo.htmlAttributions,
        'photo_reference': photo.photoReference,
        'width': photo.width
      }).toList(),
      'placeId': placeId,
      'priceLevel': priceLevel,
      'rating': rating,
      'reservable': reservable,
      'reviews': reviews?.map((review) => {
        'author_url': review.authorUrl,
        'rating': review.rating,
        'review': review.text
      }).toList(),
      'servesBeer': servesBeer,
      'servesBrunch': servesBrunch,
      'servesDinner': servesDinner,
      'servesLunch':servesLunch,
      'servesVegetarianFood': servesVegetarianFood,
      'servesWine': servesWine,
      'takeout': takeout,
      'types': types,
      'user_ratings_total': userRatingsTotal,
      'website': website,
      'weekday_text': weekdayText
    };
  }


  /// Factory method to create Result from Firestore Map
  factory Result.fromFirestoreMap(Map<String, dynamic> firestoreMap) {
    return Result(
      name: firestoreMap['Name'] as String?,
      formattedAddress: firestoreMap['formatted_address'] as String?,
      geometry: firestoreMap['geometry'] != null
          ? Geometry(
          location: Location(
              lat: firestoreMap['geometry']['lat'] as double?,
              lng: firestoreMap['geometry']['lng'] as double?
          )
      )
          : null,
      weekdayText: (firestoreMap['weekday_text'] as List<dynamic>?)?.cast<String>(),
      photosList: firestoreMap['photos'] != null
          ? PhotosList(
          photos: (firestoreMap['photos'] as List<dynamic>).map((photoMap) => Photo(
              height: photoMap['height'] as int?,
              htmlAttributions: (photoMap['html_attributions'] as List<dynamic>?)?.cast<String>(),
              photoReference: photoMap['photo_reference'] as String?,
              width: photoMap['width'] as int?
          )).toList()
      )
          : null,
      rating: firestoreMap['rating']?.toDouble(),
      userRatingsTotal: firestoreMap['user_ratings_total'] as int?,
      website: firestoreMap['website'] as String?,
      reviews: (firestoreMap['reviews'] as List<dynamic>?)?.map((reviewMap) => Reviews(
          text: reviewMap['review'] as String?,
          rating: reviewMap['rating'] as int?,
          authorUrl: reviewMap['author_url'] as String?
      )).toList(),
      placeId: firestoreMap['placeId'] as String?,
      editorialSummary : firestoreMap['editorialSummary'] != null
          ? EditorialSummary(overview: firestoreMap['editorialSummary']  as String?)
          : null,
       priceLevel: firestoreMap['priceLevel'] is int ? firestoreMap['priceLevel'] as int : null,
        reservable : firestoreMap['reservable'] is bool?  firestoreMap['reservable'] as bool : null,
        servesBeer : firestoreMap['servesBeer'] is bool?  firestoreMap['servesBeer'] as bool : null,
        servesBrunch:  firestoreMap['servesBrunch'] is bool?  firestoreMap['servesBrunch'] as bool : null,
        servesDinner:  firestoreMap['servesDinner'] is bool?  firestoreMap['servesDinner'] as bool : null,
        servesLunch: firestoreMap['servesLunch'] is bool?  firestoreMap['servesLunch'] as bool : null,
        servesVegetarianFood:  firestoreMap['servesVegetarianFood'] is bool?  firestoreMap['servesVegetarianFood'] as bool : null,
        servesWine:  firestoreMap['servesWine'] is bool?  firestoreMap['servesWine'] as bool : null,
        takeout: firestoreMap['takeout'] is bool?  firestoreMap['takeout'] as bool : null,
    );
  }


  Result withReviews(List<Reviews> newReviews) {
    return Result(
      name: name,
      formattedAddress: formattedAddress,
      geometry: geometry,
      weekdayText: weekdayText,
      photosList: photosList,
      rating: rating,
      editorialSummary: editorialSummary,
      priceLevel: priceLevel,
      reservable: reservable,
      types: types,
      userRatingsTotal: userRatingsTotal,
      website: website,
      reviews: newReviews, // here we replace the old reviews with the new ones
      delivery: delivery,
      servesBeer: servesBeer,
      servesBrunch: servesBrunch,
      servesDinner: servesDinner,
      servesLunch: servesLunch,
      servesVegetarianFood: servesVegetarianFood,
      servesWine: servesWine,
      takeout: takeout,
      placeId: placeId,
    );
  }

}

@HiveType(typeId: 1)
class Geometry {
  @HiveField(0)
  final Location? location;

  Geometry({this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: json['location'] != null ? Location.fromJson(json['location'] as Map<String, dynamic>) : null,
    );
  }
}
@HiveType(typeId: 2)
class Location {
  @HiveField(0)
  final double? lat;
  @HiveField(1)
  final double? lng;

  Location({this.lat, this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'] as double?,
      lng: json['lng'] as double?,
    );
  }
}
@HiveType(typeId: 3)
class EditorialSummary{
  @HiveField(0)
  final String? overview;

  EditorialSummary({this.overview});

  factory EditorialSummary.fromJson(Map<String, dynamic> json) {
    return EditorialSummary(
      overview: json['overview'] as String?,
    );
  }
}
@HiveType(typeId: 4)
class Photo {
  @HiveField(0)
  final int? height;
  @HiveField(1)
  final List<String>? htmlAttributions;
  @HiveField(2)
  final String? photoReference;
  @HiveField(3)
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
  factory Photo.fromJson2(Map<String, dynamic> json) {
    return Photo(
      height: json['height'] as int?,
      htmlAttributions: json['html_attributions'] != null
          ? List<String>.from(json['html_attributions'].map((x) => x as String))
          : null,
      photoReference: json['photoReference'] as String?,
      width: json['width'] as int?,
    );
  }
}

@HiveType(typeId: 5)
class PhotosList {
  @HiveField(0)
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

  // factory PhotosList.fromJson2(Map<String, dynamic> json) {
  //   return PhotosList(
  //     photos: json['photo'] != null
  //         ? List<Photo>.from(json['photo'].map((x) => Photo.fromJson2(x)))
  //         : null,
  //   );
  // }
}



@HiveType(typeId: 6)
class Reviews{
  @HiveField(0)
  final String? text;
  @HiveField(1)
  final int? rating;
  @HiveField(2)
  final String? authorUrl;

  Reviews({this.text, this.rating, this.authorUrl});

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      text: json['text'] as String?,
      rating: json['rating'] as int?,
      authorUrl: json['author_url'] as String?,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'rating': rating,
      'author_url': authorUrl,
    };
  }
}


