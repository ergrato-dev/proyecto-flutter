import 'package:cosmos_flutter/modules/forms/models/date_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateRange', () {
    group('isValid', () {
      test('rango de 0 días (mismo día) es válido', () {
        final date = DateTime(2025, 4, 20);
        final range = DateRange(startDate: date, endDate: date);
        expect(range.isValid, isTrue);
      });

      test('rango de 7 días exactos es válido', () {
        final start = DateTime(2025, 4, 13);
        final end = DateTime(2025, 4, 20);
        final range = DateRange(startDate: start, endDate: end);
        expect(range.isValid, isTrue);
      });

      test('rango de 6 días es válido', () {
        final start = DateTime(2025, 4, 14);
        final end = DateTime(2025, 4, 20);
        final range = DateRange(startDate: start, endDate: end);
        expect(range.isValid, isTrue);
      });

      test('rango de 8 días es inválido', () {
        final start = DateTime(2025, 4, 12);
        final end = DateTime(2025, 4, 20);
        final range = DateRange(startDate: start, endDate: end);
        expect(range.isValid, isFalse);
      });

      test('endDate antes que startDate es inválido', () {
        final start = DateTime(2025, 4, 20);
        final end = DateTime(2025, 4, 15);
        final range = DateRange(startDate: start, endDate: end);
        expect(range.isValid, isFalse);
      });

      test('rango de 1 día es válido', () {
        final start = DateTime(2025, 4, 19);
        final end = DateTime(2025, 4, 20);
        final range = DateRange(startDate: start, endDate: end);
        expect(range.isValid, isTrue);
      });
    });
  });
}
