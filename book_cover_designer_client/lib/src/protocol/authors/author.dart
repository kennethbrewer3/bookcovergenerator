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

abstract class Author implements _i1.SerializableModel {
  Author._({
    this.id,
    required this.name,
    required this.sortName,
    required this.createdAt,
    required this.isActive,
  });

  factory Author({
    int? id,
    required String name,
    required String sortName,
    required DateTime createdAt,
    required bool isActive,
  }) = _AuthorImpl;

  factory Author.fromJson(Map<String, dynamic> jsonSerialization) {
    return Author(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      sortName: jsonSerialization['sortName'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String sortName;

  DateTime createdAt;

  bool isActive;

  /// Returns a shallow copy of this [Author]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Author copyWith({
    int? id,
    String? name,
    String? sortName,
    DateTime? createdAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Author',
      if (id != null) 'id': id,
      'name': name,
      'sortName': sortName,
      'createdAt': createdAt.toJson(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthorImpl extends Author {
  _AuthorImpl({
    int? id,
    required String name,
    required String sortName,
    required DateTime createdAt,
    required bool isActive,
  }) : super._(
         id: id,
         name: name,
         sortName: sortName,
         createdAt: createdAt,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [Author]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Author copyWith({
    Object? id = _Undefined,
    String? name,
    String? sortName,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Author(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      sortName: sortName ?? this.sortName,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
