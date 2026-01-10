import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whativedone/src/features/auth/data/auth_repository.dart';
import 'package:whativedone/src/core/errors/failure.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late AuthRepository authRepository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    // In un test reale useremmo un provider container, 
    // qui facciamo un test isolato della classe.
    authRepository = AuthRepository(dio: mockDio, storage: null);
  });

  test('Login deve restituire ServerFailure se le credenziali sono errate (401)', () async {
    // Arrange: prepariamo il finto errore dal server
    when(() => mockDio.post(
      any(),
      data: any(named: 'data'),
      options: any(named: 'options'),
    )).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 401,
          data: {'detail': 'Invalid credentials'},
        ),
      ),
    );

    // Act
    final result = await authRepository.login(username: 'test', password: 'wrong');

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (success) => fail('Dovrebbe essere un fallimento'),
    );
  });
}
