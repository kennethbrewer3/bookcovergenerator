/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class CoverSize implements _i1.SerializableModel {
  CoverSize._({
    this.id,
    required this.label,
    required this.width,
    required this.height,
    required this.sortOrder,
    required this.isActive,
  });

  factory CoverSize({
    int? id,
    required String label,
    required int width,
    required int height,
    required int sortOrder,
    required bool isActive,
  }) = _CoverSizeImpl;

  factory CoverSize.fromJson(Map<String, dynamic> jsonSerialization) {
    return CoverSize(
      id: jsonSerialization['id'] as int?,
      label: jsonSerialization['label'] as String,
      width: jsonSerialization['width'] as int,
      height: jsonSerialization['height'] as int,
      sortOrder: jsonSerialization['sortOrder'] as int,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String label;

  int width;

  int height;

  int sortOrder;

  bool isActive;

  /// Returns a shallow copy of this [CoverSize]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CoverSize copyWith({
    int? id,
    String? label,
    int? width,
    int? height,
    int? sortOrder,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CoverSize',
      if (id != null) 'id': id,
      'label': label,
      'width': width,
      'height': height,
      'sortOrder': sortOrder,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CoverSizeImpl extends CoverSize {
  _CoverSizeImpl({
    int? id,
    required String label,
    required int width,
    required int height,
    required int sortOrder,
    required bool isActive,
  }) : super._(
         id: id,
         label: label,
         width: width,
         height: height,
         sortOrder: sortOrder,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [CoverSize]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CoverSize copyWith({
    Object? id = _Undefined,
    String? label,
    int? width,
    int? height,
    int? sortOrder,
    bool? isActive,
  }) {
    return CoverSize(
      id: id is int? ? id : this.id,
      label: label ?? this.label,
      width: width ?? this.width,
      height: height ?? this.height,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }
}
