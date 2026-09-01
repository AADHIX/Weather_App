import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Server unreachable message is understandable to users', () {
    const message =
        'Unable to reach weather server. Check your internet connection and try again.';

    expect(message, contains('Unable to reach weather server'));
    expect(message, contains('internet connection'));
  });
}
