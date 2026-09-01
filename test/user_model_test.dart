import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapps/modules/auth/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('UserModel toJson and fromJson serialization', () {
      final user = UserModel(
        id: 'u123',
        name: 'Alice Cooper',
        email: 'alice@example.com',
        phone: '+1234567890',
        createdAt: DateTime(2026, 1, 1),
      );

      final json = user.toJson();
      final fromJsonUser = UserModel.fromJson(json);

      expect(fromJsonUser.id, 'u123');
      expect(fromJsonUser.name, 'Alice Cooper');
      expect(fromJsonUser.email, 'alice@example.com');
      expect(fromJsonUser.phone, '+1234567890');
      expect(fromJsonUser, equals(user));
    });
  });
}
