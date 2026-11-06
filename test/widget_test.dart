
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_nest/main.dart';

void main() {
  test('Travel Nest app can be created', () {
    const app = TravelNestApp();

    expect(app, isA<TravelNestApp>());
  });
}
