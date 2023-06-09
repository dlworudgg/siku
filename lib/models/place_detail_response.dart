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
  final List<Reviews>? reviews;
  // final ReviewsList? reviewList;
  final bool? delivery;
  final bool? servesBeer;
  final bool? servesBrunch;
  final bool? servesDinner;
  final bool? servesLunch;
  final bool? servesVegetarianFood;
  final bool? servesWine;
  final bool? takeout;
  final String? placeId;

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
    this.reviews,
    // this.reviewList,
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
      // reviews: json['reviews'] != null ? Reviews.fromJson(json['reviews']): null,
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


  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      name: map['name'],
      formattedAddress: map['formattedAddress'],
      geometry: map['geometry'] != null
          ? Geometry.fromJson(map['geometry'] as Map<String, dynamic>)
          : null,
      weekdayText: (map['weekdayText'] as List<dynamic>?)?.cast<String>(),
      // photos: (json['photos']?.map((item) => item['photo_reference'] as String)?.toList()),
      photosList: map['photoslist'] != null ? PhotosList.fromJson2({'photo' :map['photoslist']}) : null,
      rating: map['rating'] as double?,
      editorialSummary: map['editorial_summary'] != null ? EditorialSummary.fromJson(map['editorial_summary'] as Map<String, dynamic>) : null,
      priceLevel: map['price_level'] as int?,
      reservable: map['reservable'] as bool?,
      types: (map['types'] as List<dynamic>?)?.cast<String>(),
      userRatingsTotal: map['user_ratings_total'] as int?,
      website: map['website'] as String?,
      // reviews: (map['reviews']?.map((json) => Review.fromJson(json as Map<String, dynamic>))?.toList()),
      // reviews: map['reviews'] != null ? Reviews.fromJson(map['reviews']) : null,
        reviews: map['reviews'] != null ? (map['reviews'] as List<dynamic>).map((item) => Reviews.fromJson(item as Map<String, dynamic>)).toList() : null,
        delivery: map['delivery'] as bool?,
      servesBeer: map['serves_beer'] as bool?,
      servesBrunch: map['serves_brunch'] as bool?,
      servesDinner: map['serves_dinner'] as bool?,
      servesLunch: map['serves_lunch'] as bool?,
      servesVegetarianFood: map['serves_vegetarian_food'] as bool?,
      servesWine: map['serves_wine'] as bool?,
      takeout: map['takeout'] as bool?,
      placeId : map['place_id'] as String?,
// ... continue with other properties
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> photos = [];
    photosList?.photos?.forEach((photo) {
      photos.add({
        'height': photo.height,
        'photoReference': photo.photoReference,
        'width': photo.width,
      });
    });

    // List<Map<String, dynamic>> reviews = [];
    // reviewList?.review?.forEach((review) {
    //   reviews.add({
    //     'rating': review.rating,
    //     'text': review.text,
    //   });
    // });

    List<Map<String, dynamic>> reviews = [];
    this.reviews?.forEach((review) {
      reviews.add({
        'rating': review.rating,
        'text': review.text,
        'author_url': review.authorUrl,
      });
    });

    return {
      'name': name,
      'formatted_address': formattedAddress,
      'geometry': {'location': {'lat': geometry?.location?.lat, 'lng': geometry?.location?.lng}},
      'weekdayText': weekdayText,
      'photoslist': photos,
      'rating': rating,
      'editorial_summary': {'overview': editorialSummary?.overview},
      'price_level': priceLevel,
      'reservable': reservable,
      'types': types,
      'user_ratings_total': userRatingsTotal,
      'website': website,
      'reviews': reviews,
      'delivery': delivery,
      'serves_beer': servesBeer,
      'serves_brunch': servesBrunch,
      'serves_dinner': servesDinner,
      'serves_lunch': servesLunch,
      'serves_vegetarian_food': servesVegetarianFood,
      'serves_wine': servesWine,
      'takeout': takeout,
      'place_id': placeId,
    };
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

  factory PhotosList.fromJson2(Map<String, dynamic> json) {
    return PhotosList(
      photos: json['photo'] != null
          ? List<Photo>.from(json['photo'].map((x) => Photo.fromJson2(x)))
          : null,
    );
  }
}




class Reviews{
  final String? text;
  final int? rating;
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

