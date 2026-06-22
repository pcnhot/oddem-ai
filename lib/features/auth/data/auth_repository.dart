import '../../../shared/models/app_user.dart';

/// Authentication abstraction. Mock implementation accepts any credentials.
abstract class AuthRepository {
  Future<AppUser> login({required String email, required String password});
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
}

class MockAuthRepository implements AuthRepository {
  const MockAuthRepository();

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return AppUser(
      id: 'u_local',
      name: email.split('@').first,
      email: email,
      city: 'الرياض',
    );
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return AppUser(id: 'u_local', name: name, email: email, city: 'الرياض');
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
