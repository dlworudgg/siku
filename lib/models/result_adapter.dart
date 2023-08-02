// import 'package:hive/hive.dart';
//
// @HiveType(typeId: 0)
// class HiveMyList extends HiveObject {
//
//   @HiveField(0)
//   String name;
//
//   @HiveField(1)
//   int age;
// };
//







// import 'package:hive/hive.dart';
// import 'package:siku/models/place_detail_response.dart';
//
// class ResultAdapter extends TypeAdapter<Result> {
//   @override
//   final typeId = 0;  // Ensure this is unique among all your Hive types
//
//   @override
//   Result read(BinaryReader reader) {
//     return Result(
//       name: reader.read(),
//       formattedAddress: reader.read(),
//       geometry: reader.read() as  Geometry,
//       weekdayText: reader.read(),
//       photosList: reader.read() as PhotosList,
//       rating: reader.read(),
//       editorialSummary: reader.read() as EditorialSummary,
//       priceLevel: reader.read(),
//       reservable: reader.read(),
//       types: reader.read(),
//       userRatingsTotal: reader.read(),
//       website: reader.read(),
//       reviews: reader.read() as List<Reviews>,
//       delivery: reader.read(),
//       servesBeer: reader.read(),
//       servesBrunch: reader.read(),
//       servesDinner: reader.read(),
//       servesLunch: reader.read(),
//       servesVegetarianFood: reader.read(),
//       servesWine: reader.read(),
//       takeout: reader.read(),
//       placeId: reader.read(),
//     );
//   }
//   @override
//   void write(BinaryWriter writer, Result obj) {
//     writer.write(obj.name);
//     writer.write(obj.formattedAddress);
//     writer.write(obj.geometry);
//     writer.write(obj.weekdayText);
//     writer.write(obj.photosList);
//     writer.write(obj.rating);
//     writer.write(obj.editorialSummary);
//     writer.write(obj.priceLevel);
//     writer.write(obj.reservable);
//     writer.write(obj.types);
//     writer.write(obj.userRatingsTotal);
//     writer.write(obj.website);
//     writer.write(obj.reviews);
//     writer.write(obj.delivery);
//     writer.write(obj.servesBeer);
//     writer.write(obj.servesBrunch);
//     writer.write(obj.servesDinner);
//     writer.write(obj.servesLunch);
//     writer.write(obj.servesVegetarianFood);
//     writer.write(obj.servesWine);
//     writer.write(obj.takeout);
//     writer.write(obj.placeId);
//   }
// }
//
// class GeometryAdapter extends TypeAdapter<Geometry> {
//   @override
//   final typeId = 1;
//
//   @override
//   Geometry read(BinaryReader reader) {
//     return Geometry(
//       location: reader.read() as Location,
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, Geometry obj) {
//     writer.write(obj.location);
//   }
// }
//
//
// class LocationAdapter extends TypeAdapter<Location> {
//   @override
//   final typeId = 2;
//
//   @override
//   Location read(BinaryReader reader) {
//     return Location (
//       lat : reader.read(),
//       lng : reader.read(),
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, Location obj) {
//     writer.write(obj.lat);
//     writer.write(obj.lng);
//   }
// }
//
//
//
// class EditorialSummaryAdapter extends TypeAdapter<EditorialSummary> {
//   @override
//   final typeId = 3;
//
//   @override
//   EditorialSummary read(BinaryReader reader) {
//     return EditorialSummary (
//       overview : reader.read(),
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, EditorialSummary obj) {
//     writer.write(obj.overview);
//   }
// }
//
//
// class PhotoAdapter extends TypeAdapter<Photo> {
//   @override
//   final typeId = 4;
//
//   @override
//   Photo read(BinaryReader reader) {
//     return Photo (
//       height : reader.read(),
//       htmlAttributions : reader.read(),
//       photoReference : reader.read(),
//       width : reader.read(),
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, Photo obj) {
//     writer.write(obj.height);
//     writer.write(obj.htmlAttributions);
//     writer.write(obj.photoReference);
//     writer.write(obj.width);
//   }
// }
//
//
// class PhotosListAdapter extends TypeAdapter<PhotosList> {
//   @override
//   final typeId = 5;
//
//   @override
//   PhotosList read(BinaryReader reader) {
//     return PhotosList (
//       photos : reader.read() as List<Photo>,
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, PhotosList obj) {
//     writer.write(obj.photos);
//   }
// }
//
//
// class ReviewsAdapter extends TypeAdapter<Reviews> {
//   @override
//   final typeId = 6;
//
//   @override
//   Reviews read(BinaryReader reader) {
//     return Reviews(
//       text : reader.read(),
//       rating : reader.read(),
//       authorUrl : reader.read(),
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, Reviews obj) {
//     writer.write(obj.text );
//     writer.write(obj.rating);
//     writer.write(obj.authorUrl);
//   }
// }
//
import 'package:hive/hive.dart';
import 'package:siku/models/place_detail_response.dart';




class ResultAdapter extends TypeAdapter<Result> {
  @override
  final typeId = 0;  // Ensure this is unique among all your Hive types

  @override
  Result read(BinaryReader reader) {
    return Result(
      name: reader.read() as String?,
      formattedAddress: reader.read() as String?,
      geometry: reader.read(),
      photosList: reader.read(),
      rating: reader.read() as double?,
      editorialSummary: reader.read() ,
      priceLevel: reader.read() as int?,
      reservable: reader.read() as bool?,
      userRatingsTotal: reader.read() as int?,
      website: reader.read() as String?,
      delivery: reader.read() as bool?,
      servesBeer: reader.read() as bool?,
      servesBrunch: reader.read() as bool?,
      servesDinner: reader.read() as bool?,
      servesLunch: reader.read() as bool?,
      servesVegetarianFood: reader.read() as bool?,
      servesWine: reader.read() as bool?,
      takeout: reader.read() as bool?,
      placeId: reader.read() as String?,
    );
  }
  @override
  void write(BinaryWriter writer, Result obj) {
    writer.write(obj.name);
    writer.write(obj.formattedAddress);
    writer.write(obj.geometry);
    writer.write(obj.photosList);
    writer.write(obj.rating);
    writer.write(obj.editorialSummary);
    writer.write(obj.priceLevel);
    writer.write(obj.reservable);
    writer.write(obj.userRatingsTotal);
    writer.write(obj.website);
    writer.write(obj.delivery);
    writer.write(obj.servesBeer);
    writer.write(obj.servesBrunch);
    writer.write(obj.servesDinner);
    writer.write(obj.servesLunch);
    writer.write(obj.servesVegetarianFood);
    writer.write(obj.servesWine);
    writer.write(obj.takeout);
    writer.write(obj.placeId);
  }
}

class GeometryAdapter extends TypeAdapter<Geometry> {
  @override
  final typeId = 1;

  @override
  Geometry read(BinaryReader reader) {
    return Geometry(
      location: reader.read() as Location,
    );
  }

  @override
  void write(BinaryWriter writer, Geometry obj) {
    writer.write(obj.location);
  }
}


class LocationAdapter extends TypeAdapter<Location> {
  @override
  final typeId = 2;

  @override
  Location read(BinaryReader reader) {
    return Location (
      lat : reader.read(),
      lng : reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Location obj) {
    writer.write(obj.lat);
    writer.write(obj.lng);
  }
}



class EditorialSummaryAdapter extends TypeAdapter<EditorialSummary> {
  @override
  final typeId = 3;

  @override
  EditorialSummary read(BinaryReader reader) {
    return EditorialSummary (
      overview : reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, EditorialSummary obj) {
    writer.write(obj.overview);
  }
}

class PhotosListAdapter extends TypeAdapter<PhotosList> {
  @override
  final typeId = 4;

  @override
  PhotosList read(BinaryReader reader) {
    final photoAdapter = PhotoAdapter();
    final List<Photo>? photosList = reader.read() as List<Photo>?;

    final List<Photo> photos = photosList != null
        ? photosList.map((photoBinary) => photoAdapter.read(photoBinary as BinaryReader)).toList()
        : [];

    return PhotosList(photos: photos);
  }

  @override
  void write(BinaryWriter writer, PhotosList obj) {
    final photoAdapter = PhotoAdapter();
    final photosBinary = obj.photos?.map((photo) => photoAdapter.write(writer, photo)).toList();
    writer.write(photosBinary);
  }
}
class PhotoAdapter extends TypeAdapter<Photo> {
  @override
  final typeId = 5;

  @override
  Photo read(BinaryReader reader) {
    return Photo (
      height : reader.read(),
      htmlAttributions : reader.read(),
      photoReference : reader.read(),
      width : reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Photo obj) {
    writer.write(obj.height);
    writer.write(obj.htmlAttributions);
    writer.write(obj.photoReference);
    writer.write(obj.width);
  }
}



class ReviewsAdapter extends TypeAdapter<Reviews> {
  @override
  final typeId = 6;

  @override
  Reviews read(BinaryReader reader) {
    return Reviews(
      text : reader.read(),
      rating : reader.read(),
      authorUrl : reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Reviews obj) {
    writer.write(obj.text );
    writer.write(obj.rating);
    writer.write(obj.authorUrl);
  }
}