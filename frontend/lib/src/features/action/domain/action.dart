import 'package:freezed_annotation/freezed_annotation.dart';
import '../../dimension/domain/dimension.dart';

part 'action.freezed.dart';
part 'action.g.dart';

@freezed
class Action with _$Action {
  const factory Action({
    required String id,
    required DateTime startTime,
    DateTime? endTime,
    String? description,
    @Default("Dovere") String category,
    @Default(3) int difficulty,
    required int fulfillmentScore,
    required String userId,
    required String dimensionId,
    Dimension? dimension,
  }) = _Action;

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);
}

@freezed
class ActionCreate with _$ActionCreate {
  const factory ActionCreate({
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    required String dimensionId,
    required int fulfillmentScore,
    @Default("Dovere") String category,
    @Default(3) int difficulty,
    @Default("COMPLETED") String status,
  }) = _ActionCreate;

  factory ActionCreate.fromJson(Map<String, dynamic> json) => _$ActionCreateFromJson(json);
}
