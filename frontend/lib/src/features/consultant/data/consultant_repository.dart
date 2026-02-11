import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whativedone/src/core/networking/dio_provider.dart';
import 'package:whativedone/src/core/networking/network_exceptions.dart';
import 'package:whativedone/src/features/dashboard/presentation/dashboard_models.dart';

// This is a placeholder for actual API call, replace with generated client if available
class ConsultantClient {
  final Dio _dio;

  ConsultantClient(this._dio);

  Future<List<TaskUIModel>> getProposals() async {
    final response = await _dio.get('/api/v1/consultant/proposals');
    return (response.data as List).map((json) => TaskUIModel.fromActionJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<TaskUIModel>> consumeProposal(String proposalId) async {
    final response = await _dio.post('/api/v1/consultant/proposals/$proposalId/consume');
    return (response.data as List).map((json) => TaskUIModel.fromActionJson(json as Map<String, dynamic>)).toList();
  }
}

// ConsultantRepository for handling data operations
class ConsultantRepository {
  final ConsultantClient _client;

  ConsultantRepository(this._client);

  Future<Either<NetworkExceptions, List<TaskUIModel>>> fetchProposals() async {
    try {
      final proposals = await _client.getProposals();
      return right(proposals);
    } on DioException catch (e) {
      return left(NetworkExceptions.fromDioException(e));
    }
  }

  Future<Either<NetworkExceptions, List<TaskUIModel>>> consumeProposal(String proposalId) async {
    try {
      final newProposals = await _client.consumeProposal(proposalId);
      return right(newProposals);
    } on DioException catch (e) {
      return left(NetworkExceptions.fromDioException(e));
    }
  }
}

// Riverpod provider for ConsultantClient
final consultantClientProvider = Provider<ConsultantClient>(
  (ref) => ConsultantClient(ref.read(dioProvider)),
);

// Riverpod provider for ConsultantRepository
final consultantRepositoryProvider = Provider<ConsultantRepository>(
  (ref) => ConsultantRepository(ref.read(consultantClientProvider)),
);
