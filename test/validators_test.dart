import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapps/core/utils/validators.dart';

void main() {
  group('Validators Test Group', () {
    test('validateEmail checks valid and invalid email addresses', () {
      expect(Validators.validateEmail(''), 'Please enter your email address');
      expect(Validators.validateEmail('invalid_email'), 'Please enter a valid email address');
      expect(Validators.validateEmail('user@domain.com'), isNull);
    });

    test('validatePassword checks minimum password length', () {
      expect(Validators.validatePassword(''), 'Please enter a password');
      expect(Validators.validatePassword('12345'), 'Password must be at least 6 characters');
      expect(Validators.validatePassword('password123'), isNull);
    });

    test('validateConfirmPassword checks matching passwords', () {
      expect(Validators.validateConfirmPassword('', 'pass123'), 'Please confirm your password');
      expect(Validators.validateConfirmPassword('pass456', 'pass123'), 'Passwords do not match');
      expect(Validators.validateConfirmPassword('pass123', 'pass123'), isNull);
    });

    test('validateName checks name length and presence', () {
      expect(Validators.validateName(''), 'Please enter your full name');
      expect(Validators.validateName('A'), 'Name must be at least 2 characters');
      expect(Validators.validateName('John Doe'), isNull);
    });

    test('validateCity checks city name presence', () {
      expect(Validators.validateCity(''), 'Please enter a city name');
      expect(Validators.validateCity('L'), 'City name is too short');
      expect(Validators.validateCity('London'), isNull);
    });
  });
}
