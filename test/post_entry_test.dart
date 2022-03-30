import 'package:flutter_test/flutter_test.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:project5/models/post_entry.dart';

void main() {
  test(
    'Post created from Map should have the appropriate values',
    () {
      final DateTime date = DateTime.parse('2022-03-10');
      const String url = 'FAKE';
      const int quantity = 1;
      const GeoPoint location = GeoPoint(1.0, 2.0);

      final postEntry = PostEntry.fromMap({
        'date': Timestamp.fromDate(date),
        'imageURL': url,
        'quantity': quantity,
        'location': location,
      });

      expect(postEntry.date, date);
      expect(postEntry.imageURL, url);
      expect(postEntry.quantity, quantity);
      expect(postEntry.location, location);
    },
  );

  test(
    'PostEntry object\'s dateStringLong function should return the date as '
    '\'WEEKDAY, MONTH DAY, YEAR\'',
    () {
      Intl.defaultLocale = 'en-US';

      final weekdayStrings = [
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
      ];
      for (int day = 6; day <= 12; ++day) {
        final postEntry = PostEntry(
            date: DateTime.parse('2022-03-${day.toString().padLeft(2, '0')}'));
        final expectedString = '${weekdayStrings[day - 6]}, March $day, 2022';
        expect(postEntry.dateStringLong, expectedString);
      }
    },
  );

  test(
    'PostEntry object\'s dateStringShort function should return the date as '
    '\'ABBR_WEEKDAY, ABBR_MONTH DAY, YEAR\'',
    () {
      Intl.defaultLocale = 'en-US';

      final abbrWeekdayStrings = [
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
      ];
      for (int day = 6; day <= 12; ++day) {
        final postEntry = PostEntry(
            date: DateTime.parse('2022-03-${day.toString().padLeft(2, '0')}'));
        final expectedString = '${abbrWeekdayStrings[day - 6]}, Mar $day, 2022';
        expect(postEntry.dateStringShort, expectedString);
      }
    },
  );
}
