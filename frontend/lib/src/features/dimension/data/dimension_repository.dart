import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/networking/dio_provider.dart';
import '../domain/dimension.dart';

part 'dimension_repository.g.dart';

@riverpod
DimensionRepository dimensionRepository(Ref ref) {
  return DimensionRepository(dio: ref.watch(dioProvider));
}

class DimensionRepository {
  final Dio _dio;

  DimensionRepository({required Dio dio}) : _dio = dio;

  Future<List<Dimension>> getDimensions() async {
    final response = await _dio.get('/api/v1/dimensions/');
    final List<dynamic> data = response.data;
    return data.map((json) => Dimension.fromJson(json)).toList();
  }
}
