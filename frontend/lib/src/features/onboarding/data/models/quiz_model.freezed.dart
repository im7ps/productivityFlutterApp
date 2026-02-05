// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuizOption _$QuizOptionFromJson(Map<String, dynamic> json) {
  return _QuizOption.fromJson(json);
}

/// @nodoc
mixin _$QuizOption {
  int get value => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this QuizOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizOptionCopyWith<QuizOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizOptionCopyWith<$Res> {
  factory $QuizOptionCopyWith(
    QuizOption value,
    $Res Function(QuizOption) then,
  ) = _$QuizOptionCopyWithImpl<$Res, QuizOption>;
  @useResult
  $Res call({int value, String label, String? description});
}

/// @nodoc
class _$QuizOptionCopyWithImpl<$Res, $Val extends QuizOption>
    implements $QuizOptionCopyWith<$Res> {
  _$QuizOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? label = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as int,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizOptionImplCopyWith<$Res>
    implements $QuizOptionCopyWith<$Res> {
  factory _$$QuizOptionImplCopyWith(
    _$QuizOptionImpl value,
    $Res Function(_$QuizOptionImpl) then,
  ) = __$$QuizOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int value, String label, String? description});
}

/// @nodoc
class __$$QuizOptionImplCopyWithImpl<$Res>
    extends _$QuizOptionCopyWithImpl<$Res, _$QuizOptionImpl>
    implements _$$QuizOptionImplCopyWith<$Res> {
  __$$QuizOptionImplCopyWithImpl(
    _$QuizOptionImpl _value,
    $Res Function(_$QuizOptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? label = null,
    Object? description = freezed,
  }) {
    return _then(
      _$QuizOptionImpl(
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as int,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizOptionImpl implements _QuizOption {
  const _$QuizOptionImpl({
    required this.value,
    required this.label,
    this.description,
  });

  factory _$QuizOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizOptionImplFromJson(json);

  @override
  final int value;
  @override
  final String label;
  @override
  final String? description;

  @override
  String toString() {
    return 'QuizOption(value: $value, label: $label, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizOptionImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value, label, description);

  /// Create a copy of QuizOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizOptionImplCopyWith<_$QuizOptionImpl> get copyWith =>
      __$$QuizOptionImplCopyWithImpl<_$QuizOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizOptionImplToJson(this);
  }
}

abstract class _QuizOption implements QuizOption {
  const factory _QuizOption({
    required final int value,
    required final String label,
    final String? description,
  }) = _$QuizOptionImpl;

  factory _QuizOption.fromJson(Map<String, dynamic> json) =
      _$QuizOptionImpl.fromJson;

  @override
  int get value;
  @override
  String get label;
  @override
  String? get description;

  /// Create a copy of QuizOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizOptionImplCopyWith<_$QuizOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) {
  return _QuizQuestion.fromJson(json);
}

/// @nodoc
mixin _$QuizQuestion {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  List<QuizOption> get options => throw _privateConstructorUsedError;

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizQuestionCopyWith<QuizQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizQuestionCopyWith<$Res> {
  factory $QuizQuestionCopyWith(
    QuizQuestion value,
    $Res Function(QuizQuestion) then,
  ) = _$QuizQuestionCopyWithImpl<$Res, QuizQuestion>;
  @useResult
  $Res call({String id, String text, List<QuizOption> options});
}

/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res, $Val extends QuizQuestion>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? text = null, Object? options = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            options: null == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<QuizOption>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$QuizQuestionImplCopyWith(
    _$QuizQuestionImpl value,
    $Res Function(_$QuizQuestionImpl) then,
  ) = __$$QuizQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String text, List<QuizOption> options});
}

/// @nodoc
class __$$QuizQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$QuizQuestionImpl>
    implements _$$QuizQuestionImplCopyWith<$Res> {
  __$$QuizQuestionImplCopyWithImpl(
    _$QuizQuestionImpl _value,
    $Res Function(_$QuizQuestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? text = null, Object? options = null}) {
    return _then(
      _$QuizQuestionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        options: null == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<QuizOption>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizQuestionImpl implements _QuizQuestion {
  const _$QuizQuestionImpl({
    required this.id,
    required this.text,
    required final List<QuizOption> options,
  }) : _options = options;

  factory _$QuizQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  final List<QuizOption> _options;
  @override
  List<QuizOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'QuizQuestion(id: $id, text: $text, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    text,
    const DeepCollectionEquality().hash(_options),
  );

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      __$$QuizQuestionImplCopyWithImpl<_$QuizQuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizQuestionImplToJson(this);
  }
}

abstract class _QuizQuestion implements QuizQuestion {
  const factory _QuizQuestion({
    required final String id,
    required final String text,
    required final List<QuizOption> options,
  }) = _$QuizQuestionImpl;

  factory _QuizQuestion.fromJson(Map<String, dynamic> json) =
      _$QuizQuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get text;
  @override
  List<QuizOption> get options;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizCategory _$QuizCategoryFromJson(Map<String, dynamic> json) {
  return _QuizCategory.fromJson(json);
}

/// @nodoc
mixin _$QuizCategory {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<QuizQuestion> get questions => throw _privateConstructorUsedError;

  /// Serializes this QuizCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizCategoryCopyWith<QuizCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizCategoryCopyWith<$Res> {
  factory $QuizCategoryCopyWith(
    QuizCategory value,
    $Res Function(QuizCategory) then,
  ) = _$QuizCategoryCopyWithImpl<$Res, QuizCategory>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    List<QuizQuestion> questions,
  });
}

/// @nodoc
class _$QuizCategoryCopyWithImpl<$Res, $Val extends QuizCategory>
    implements $QuizCategoryCopyWith<$Res> {
  _$QuizCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? questions = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            questions: null == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<QuizQuestion>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizCategoryImplCopyWith<$Res>
    implements $QuizCategoryCopyWith<$Res> {
  factory _$$QuizCategoryImplCopyWith(
    _$QuizCategoryImpl value,
    $Res Function(_$QuizCategoryImpl) then,
  ) = __$$QuizCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    List<QuizQuestion> questions,
  });
}

/// @nodoc
class __$$QuizCategoryImplCopyWithImpl<$Res>
    extends _$QuizCategoryCopyWithImpl<$Res, _$QuizCategoryImpl>
    implements _$$QuizCategoryImplCopyWith<$Res> {
  __$$QuizCategoryImplCopyWithImpl(
    _$QuizCategoryImpl _value,
    $Res Function(_$QuizCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? questions = null,
  }) {
    return _then(
      _$QuizCategoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        questions: null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<QuizQuestion>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizCategoryImpl implements _QuizCategory {
  const _$QuizCategoryImpl({
    required this.id,
    required this.title,
    required this.description,
    required final List<QuizQuestion> questions,
  }) : _questions = questions;

  factory _$QuizCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  final List<QuizQuestion> _questions;
  @override
  List<QuizQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  String toString() {
    return 'QuizCategory(id: $id, title: $title, description: $description, questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    const DeepCollectionEquality().hash(_questions),
  );

  /// Create a copy of QuizCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizCategoryImplCopyWith<_$QuizCategoryImpl> get copyWith =>
      __$$QuizCategoryImplCopyWithImpl<_$QuizCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizCategoryImplToJson(this);
  }
}

abstract class _QuizCategory implements QuizCategory {
  const factory _QuizCategory({
    required final String id,
    required final String title,
    required final String description,
    required final List<QuizQuestion> questions,
  }) = _$QuizCategoryImpl;

  factory _QuizCategory.fromJson(Map<String, dynamic> json) =
      _$QuizCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  List<QuizQuestion> get questions;

  /// Create a copy of QuizCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizCategoryImplCopyWith<_$QuizCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizManifest _$QuizManifestFromJson(Map<String, dynamic> json) {
  return _QuizManifest.fromJson(json);
}

/// @nodoc
mixin _$QuizManifest {
  List<QuizCategory> get categories => throw _privateConstructorUsedError;

  /// Serializes this QuizManifest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizManifest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizManifestCopyWith<QuizManifest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizManifestCopyWith<$Res> {
  factory $QuizManifestCopyWith(
    QuizManifest value,
    $Res Function(QuizManifest) then,
  ) = _$QuizManifestCopyWithImpl<$Res, QuizManifest>;
  @useResult
  $Res call({List<QuizCategory> categories});
}

/// @nodoc
class _$QuizManifestCopyWithImpl<$Res, $Val extends QuizManifest>
    implements $QuizManifestCopyWith<$Res> {
  _$QuizManifestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizManifest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categories = null}) {
    return _then(
      _value.copyWith(
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<QuizCategory>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizManifestImplCopyWith<$Res>
    implements $QuizManifestCopyWith<$Res> {
  factory _$$QuizManifestImplCopyWith(
    _$QuizManifestImpl value,
    $Res Function(_$QuizManifestImpl) then,
  ) = __$$QuizManifestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<QuizCategory> categories});
}

/// @nodoc
class __$$QuizManifestImplCopyWithImpl<$Res>
    extends _$QuizManifestCopyWithImpl<$Res, _$QuizManifestImpl>
    implements _$$QuizManifestImplCopyWith<$Res> {
  __$$QuizManifestImplCopyWithImpl(
    _$QuizManifestImpl _value,
    $Res Function(_$QuizManifestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizManifest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categories = null}) {
    return _then(
      _$QuizManifestImpl(
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<QuizCategory>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizManifestImpl implements _QuizManifest {
  const _$QuizManifestImpl({required final List<QuizCategory> categories})
    : _categories = categories;

  factory _$QuizManifestImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizManifestImplFromJson(json);

  final List<QuizCategory> _categories;
  @override
  List<QuizCategory> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  String toString() {
    return 'QuizManifest(categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizManifestImpl &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_categories),
  );

  /// Create a copy of QuizManifest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizManifestImplCopyWith<_$QuizManifestImpl> get copyWith =>
      __$$QuizManifestImplCopyWithImpl<_$QuizManifestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizManifestImplToJson(this);
  }
}

abstract class _QuizManifest implements QuizManifest {
  const factory _QuizManifest({required final List<QuizCategory> categories}) =
      _$QuizManifestImpl;

  factory _QuizManifest.fromJson(Map<String, dynamic> json) =
      _$QuizManifestImpl.fromJson;

  @override
  List<QuizCategory> get categories;

  /// Create a copy of QuizManifest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizManifestImplCopyWith<_$QuizManifestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizAnswer _$QuizAnswerFromJson(Map<String, dynamic> json) {
  return _QuizAnswer.fromJson(json);
}

/// @nodoc
mixin _$QuizAnswer {
  String get questionId => throw _privateConstructorUsedError;
  int get selectedValue => throw _privateConstructorUsedError;

  /// Serializes this QuizAnswer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizAnswerCopyWith<QuizAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizAnswerCopyWith<$Res> {
  factory $QuizAnswerCopyWith(
    QuizAnswer value,
    $Res Function(QuizAnswer) then,
  ) = _$QuizAnswerCopyWithImpl<$Res, QuizAnswer>;
  @useResult
  $Res call({String questionId, int selectedValue});
}

/// @nodoc
class _$QuizAnswerCopyWithImpl<$Res, $Val extends QuizAnswer>
    implements $QuizAnswerCopyWith<$Res> {
  _$QuizAnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? questionId = null, Object? selectedValue = null}) {
    return _then(
      _value.copyWith(
            questionId: null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedValue: null == selectedValue
                ? _value.selectedValue
                : selectedValue // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizAnswerImplCopyWith<$Res>
    implements $QuizAnswerCopyWith<$Res> {
  factory _$$QuizAnswerImplCopyWith(
    _$QuizAnswerImpl value,
    $Res Function(_$QuizAnswerImpl) then,
  ) = __$$QuizAnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String questionId, int selectedValue});
}

/// @nodoc
class __$$QuizAnswerImplCopyWithImpl<$Res>
    extends _$QuizAnswerCopyWithImpl<$Res, _$QuizAnswerImpl>
    implements _$$QuizAnswerImplCopyWith<$Res> {
  __$$QuizAnswerImplCopyWithImpl(
    _$QuizAnswerImpl _value,
    $Res Function(_$QuizAnswerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? questionId = null, Object? selectedValue = null}) {
    return _then(
      _$QuizAnswerImpl(
        questionId: null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedValue: null == selectedValue
            ? _value.selectedValue
            : selectedValue // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizAnswerImpl implements _QuizAnswer {
  const _$QuizAnswerImpl({
    required this.questionId,
    required this.selectedValue,
  });

  factory _$QuizAnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizAnswerImplFromJson(json);

  @override
  final String questionId;
  @override
  final int selectedValue;

  @override
  String toString() {
    return 'QuizAnswer(questionId: $questionId, selectedValue: $selectedValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizAnswerImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.selectedValue, selectedValue) ||
                other.selectedValue == selectedValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, questionId, selectedValue);

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizAnswerImplCopyWith<_$QuizAnswerImpl> get copyWith =>
      __$$QuizAnswerImplCopyWithImpl<_$QuizAnswerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizAnswerImplToJson(this);
  }
}

abstract class _QuizAnswer implements QuizAnswer {
  const factory _QuizAnswer({
    required final String questionId,
    required final int selectedValue,
  }) = _$QuizAnswerImpl;

  factory _QuizAnswer.fromJson(Map<String, dynamic> json) =
      _$QuizAnswerImpl.fromJson;

  @override
  String get questionId;
  @override
  int get selectedValue;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizAnswerImplCopyWith<_$QuizAnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizSubmission _$QuizSubmissionFromJson(Map<String, dynamic> json) {
  return _QuizSubmission.fromJson(json);
}

/// @nodoc
mixin _$QuizSubmission {
  List<QuizAnswer> get answers => throw _privateConstructorUsedError;

  /// Serializes this QuizSubmission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizSubmission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizSubmissionCopyWith<QuizSubmission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizSubmissionCopyWith<$Res> {
  factory $QuizSubmissionCopyWith(
    QuizSubmission value,
    $Res Function(QuizSubmission) then,
  ) = _$QuizSubmissionCopyWithImpl<$Res, QuizSubmission>;
  @useResult
  $Res call({List<QuizAnswer> answers});
}

/// @nodoc
class _$QuizSubmissionCopyWithImpl<$Res, $Val extends QuizSubmission>
    implements $QuizSubmissionCopyWith<$Res> {
  _$QuizSubmissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizSubmission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? answers = null}) {
    return _then(
      _value.copyWith(
            answers: null == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as List<QuizAnswer>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizSubmissionImplCopyWith<$Res>
    implements $QuizSubmissionCopyWith<$Res> {
  factory _$$QuizSubmissionImplCopyWith(
    _$QuizSubmissionImpl value,
    $Res Function(_$QuizSubmissionImpl) then,
  ) = __$$QuizSubmissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<QuizAnswer> answers});
}

/// @nodoc
class __$$QuizSubmissionImplCopyWithImpl<$Res>
    extends _$QuizSubmissionCopyWithImpl<$Res, _$QuizSubmissionImpl>
    implements _$$QuizSubmissionImplCopyWith<$Res> {
  __$$QuizSubmissionImplCopyWithImpl(
    _$QuizSubmissionImpl _value,
    $Res Function(_$QuizSubmissionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizSubmission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? answers = null}) {
    return _then(
      _$QuizSubmissionImpl(
        answers: null == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as List<QuizAnswer>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizSubmissionImpl implements _QuizSubmission {
  const _$QuizSubmissionImpl({required final List<QuizAnswer> answers})
    : _answers = answers;

  factory _$QuizSubmissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizSubmissionImplFromJson(json);

  final List<QuizAnswer> _answers;
  @override
  List<QuizAnswer> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @override
  String toString() {
    return 'QuizSubmission(answers: $answers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizSubmissionImpl &&
            const DeepCollectionEquality().equals(other._answers, _answers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_answers));

  /// Create a copy of QuizSubmission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizSubmissionImplCopyWith<_$QuizSubmissionImpl> get copyWith =>
      __$$QuizSubmissionImplCopyWithImpl<_$QuizSubmissionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizSubmissionImplToJson(this);
  }
}

abstract class _QuizSubmission implements QuizSubmission {
  const factory _QuizSubmission({required final List<QuizAnswer> answers}) =
      _$QuizSubmissionImpl;

  factory _QuizSubmission.fromJson(Map<String, dynamic> json) =
      _$QuizSubmissionImpl.fromJson;

  @override
  List<QuizAnswer> get answers;

  /// Create a copy of QuizSubmission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizSubmissionImplCopyWith<_$QuizSubmissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OnboardingResult _$OnboardingResultFromJson(Map<String, dynamic> json) {
  return _OnboardingResult.fromJson(json);
}

/// @nodoc
mixin _$OnboardingResult {
  UserPublic get user => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  Map<String, int> get statsGained => throw _privateConstructorUsedError;

  /// Serializes this OnboardingResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingResultCopyWith<OnboardingResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingResultCopyWith<$Res> {
  factory $OnboardingResultCopyWith(
    OnboardingResult value,
    $Res Function(OnboardingResult) then,
  ) = _$OnboardingResultCopyWithImpl<$Res, OnboardingResult>;
  @useResult
  $Res call({UserPublic user, String message, Map<String, int> statsGained});

  $UserPublicCopyWith<$Res> get user;
}

/// @nodoc
class _$OnboardingResultCopyWithImpl<$Res, $Val extends OnboardingResult>
    implements $OnboardingResultCopyWith<$Res> {
  _$OnboardingResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? message = null,
    Object? statsGained = null,
  }) {
    return _then(
      _value.copyWith(
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserPublic,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            statsGained: null == statsGained
                ? _value.statsGained
                : statsGained // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
          )
          as $Val,
    );
  }

  /// Create a copy of OnboardingResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserPublicCopyWith<$Res> get user {
    return $UserPublicCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OnboardingResultImplCopyWith<$Res>
    implements $OnboardingResultCopyWith<$Res> {
  factory _$$OnboardingResultImplCopyWith(
    _$OnboardingResultImpl value,
    $Res Function(_$OnboardingResultImpl) then,
  ) = __$$OnboardingResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserPublic user, String message, Map<String, int> statsGained});

  @override
  $UserPublicCopyWith<$Res> get user;
}

/// @nodoc
class __$$OnboardingResultImplCopyWithImpl<$Res>
    extends _$OnboardingResultCopyWithImpl<$Res, _$OnboardingResultImpl>
    implements _$$OnboardingResultImplCopyWith<$Res> {
  __$$OnboardingResultImplCopyWithImpl(
    _$OnboardingResultImpl _value,
    $Res Function(_$OnboardingResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? message = null,
    Object? statsGained = null,
  }) {
    return _then(
      _$OnboardingResultImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserPublic,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        statsGained: null == statsGained
            ? _value._statsGained
            : statsGained // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingResultImpl implements _OnboardingResult {
  const _$OnboardingResultImpl({
    required this.user,
    required this.message,
    required final Map<String, int> statsGained,
  }) : _statsGained = statsGained;

  factory _$OnboardingResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingResultImplFromJson(json);

  @override
  final UserPublic user;
  @override
  final String message;
  final Map<String, int> _statsGained;
  @override
  Map<String, int> get statsGained {
    if (_statsGained is EqualUnmodifiableMapView) return _statsGained;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_statsGained);
  }

  @override
  String toString() {
    return 'OnboardingResult(user: $user, message: $message, statsGained: $statsGained)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingResultImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other._statsGained,
              _statsGained,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    message,
    const DeepCollectionEquality().hash(_statsGained),
  );

  /// Create a copy of OnboardingResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingResultImplCopyWith<_$OnboardingResultImpl> get copyWith =>
      __$$OnboardingResultImplCopyWithImpl<_$OnboardingResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingResultImplToJson(this);
  }
}

abstract class _OnboardingResult implements OnboardingResult {
  const factory _OnboardingResult({
    required final UserPublic user,
    required final String message,
    required final Map<String, int> statsGained,
  }) = _$OnboardingResultImpl;

  factory _OnboardingResult.fromJson(Map<String, dynamic> json) =
      _$OnboardingResultImpl.fromJson;

  @override
  UserPublic get user;
  @override
  String get message;
  @override
  Map<String, int> get statsGained;

  /// Create a copy of OnboardingResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingResultImplCopyWith<_$OnboardingResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
