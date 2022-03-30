import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PostEntry {
  DateTime? date;
  String? imageURL;
  int? quantity;
  GeoPoint? location;

  String get dateStringShort => (date != null)
      ? DateFormat('yMMMEd', 'en-US').format(date!)
      : 'No Timestamp';

  String get dateStringLong =>
      (date != null) ? DateFormat('yMMMMEEEEd').format(date!) : 'No Timestamp';

  String get quantityString => (quantity != null) ? quantity!.toString() : '0';

  String get locationString =>
      'Location: ' +
      ((location != null)
          ? '(${location!.latitude}, ${location!.longitude})'
          : 'Unspecified');

  PostEntry({this.date, this.imageURL, this.quantity, this.location});

  PostEntry.fromMap(Map<String, dynamic> map)
      : date = map['date'].toDate(),
        imageURL = map['imageURL'],
        quantity = map['quantity'],
        location = map['location'];

  Map<String, Object?> toMap() {
    return {
      'date': date as DateTime,
      'imageURL': imageURL as String,
      'quantity': quantity as int,
      'location': location as GeoPoint,
    };
  }
}
