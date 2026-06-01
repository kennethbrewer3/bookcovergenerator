// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cover_size_preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoverSizePreset {

 String get label; double get width; double get height;
/// Create a copy of CoverSizePreset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoverSizePresetCopyWith<CoverSizePreset> get copyWith => _$CoverSizePresetCopyWithImpl<CoverSizePreset>(this as CoverSizePreset, _$identity);

  /// Serializes this CoverSizePreset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoverSizePreset&&(identical(other.label, label) || other.label == label)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,width,height);

@override
String toString() {
  return 'CoverSizePreset(label: $label, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $CoverSizePresetCopyWith<$Res>  {
  factory $CoverSizePresetCopyWith(CoverSizePreset value, $Res Function(CoverSizePreset) _then) = _$CoverSizePresetCopyWithImpl;
@useResult
$Res call({
 String label, double width, double height
});




}
/// @nodoc
class _$CoverSizePresetCopyWithImpl<$Res>
    implements $CoverSizePresetCopyWith<$Res> {
  _$CoverSizePresetCopyWithImpl(this._self, this._then);

  final CoverSizePreset _self;
  final $Res Function(CoverSizePreset) _then;

/// Create a copy of CoverSizePreset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? width = null,Object? height = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CoverSizePreset].
extension CoverSizePresetPatterns on CoverSizePreset {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoverSizePreset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoverSizePreset() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoverSizePreset value)  $default,){
final _that = this;
switch (_that) {
case _CoverSizePreset():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoverSizePreset value)?  $default,){
final _that = this;
switch (_that) {
case _CoverSizePreset() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  double width,  double height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoverSizePreset() when $default != null:
return $default(_that.label,_that.width,_that.height);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  double width,  double height)  $default,) {final _that = this;
switch (_that) {
case _CoverSizePreset():
return $default(_that.label,_that.width,_that.height);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  double width,  double height)?  $default,) {final _that = this;
switch (_that) {
case _CoverSizePreset() when $default != null:
return $default(_that.label,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoverSizePreset extends CoverSizePreset {
  const _CoverSizePreset({required this.label, required this.width, required this.height}): super._();
  factory _CoverSizePreset.fromJson(Map<String, dynamic> json) => _$CoverSizePresetFromJson(json);

@override final  String label;
@override final  double width;
@override final  double height;

/// Create a copy of CoverSizePreset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoverSizePresetCopyWith<_CoverSizePreset> get copyWith => __$CoverSizePresetCopyWithImpl<_CoverSizePreset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoverSizePresetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoverSizePreset&&(identical(other.label, label) || other.label == label)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,width,height);

@override
String toString() {
  return 'CoverSizePreset(label: $label, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$CoverSizePresetCopyWith<$Res> implements $CoverSizePresetCopyWith<$Res> {
  factory _$CoverSizePresetCopyWith(_CoverSizePreset value, $Res Function(_CoverSizePreset) _then) = __$CoverSizePresetCopyWithImpl;
@override @useResult
$Res call({
 String label, double width, double height
});




}
/// @nodoc
class __$CoverSizePresetCopyWithImpl<$Res>
    implements _$CoverSizePresetCopyWith<$Res> {
  __$CoverSizePresetCopyWithImpl(this._self, this._then);

  final _CoverSizePreset _self;
  final $Res Function(_CoverSizePreset) _then;

/// Create a copy of CoverSizePreset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? width = null,Object? height = null,}) {
  return _then(_CoverSizePreset(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
