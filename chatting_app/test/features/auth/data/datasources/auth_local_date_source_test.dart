import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSheredPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthLocalDataSourceImpl authLocalDataSource;
  late MockSheredPreferences mockSheredPreferences;

  setUp(() {
    mockSheredPreferences = MockSheredPreferences();
    authLocalDataSource = AuthLocalDataSourceImpl(
      sharedPreferences: mockSheredPreferences,
    );
  });

  group('testing IsLoggedin', () {
    test('should return true when token is cached', () async {
      when(
        () => mockSheredPreferences.getString(cachedTokenKey),
      ).thenReturn('token');

      final result = await authLocalDataSource.isLoggedIn();

      expect(result, true);
      verify(() => mockSheredPreferences.getString(cachedTokenKey)).called(1);
    });

    test('should return false when token is not cached', () async {
      when(
        () => mockSheredPreferences.getString(cachedTokenKey),
      ).thenReturn(null);

      final result = await authLocalDataSource.isLoggedIn();

      expect(result, false);
      verify(() => mockSheredPreferences.getString(cachedTokenKey)).called(1);
    });
  });

  group('cachetoken testing', () {
    test('should cache token successfully', () async {
      when(
        () => mockSheredPreferences.setString(cachedTokenKey, 'token'),
      ).thenAnswer((_) async => true);

      await authLocalDataSource.cachetoken('token');
      verify(
        () => mockSheredPreferences.setString(cachedTokenKey, 'token'),
      ).called(1);
    });

    test('should throw CacheException when caching fails', () async {
      when(
        () => mockSheredPreferences.setString(cachedTokenKey, 'token'),
      ).thenThrow(Exception());

      expect(
        () => authLocalDataSource.cachetoken('token'),
        throwsA(isA<CacheException>()),
      );
      verify(
        () => mockSheredPreferences.setString(cachedTokenKey, 'token'),
      ).called(1);
    });
  });

  group('clearcache testing', () {
    test('should clear cached token successfully', () async {
      when(
        () => mockSheredPreferences.remove(cachedTokenKey),
      ).thenAnswer((_) async => true);

      await authLocalDataSource.logout();
      verify(() => mockSheredPreferences.remove(cachedTokenKey)).called(1);
    });

    test('should throw CacheException when clearing fails', () async {
      when(
        () => mockSheredPreferences.remove(cachedTokenKey),
      ).thenThrow(CacheException());

      expect(
        () => authLocalDataSource.logout(),
        throwsA(isA<CacheException>()),
      );
      verify(() => mockSheredPreferences.remove(cachedTokenKey)).called(1);
    });
  });
}
