import 'package:chatting_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkInfoImpl extends Mock implements NetworkInfoImpl {}

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test('should return false when there is no internet connection', () async {
      // Arrange

      final tHasConnection = Future.value(true);
      when(
        () => mockInternetConnectionChecker.hasConnection,
      ).thenAnswer((_) async => tHasConnection);

      // Act
      final result = networkInfo.isConnected;

      // Assert
      expect(await result, await tHasConnection);
      verify(() => mockInternetConnectionChecker.hasConnection);
    });
  });
}
