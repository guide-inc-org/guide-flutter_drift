import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' show url;

import 'column.dart';

part '../../generated/analysis/results/element.g.dart';

@sealed
@JsonSerializable()
class DriftElementId {
  final Uri libraryUri;
  final String name;

  DriftElementId(this.libraryUri, this.name);

  factory DriftElementId.fromJson(Map json) => _$DriftElementIdFromJson(json);

  bool get isDefinedInDart => url.extension(libraryUri.path) == '.dart';
  bool get isDefinedInDrift => url.extension(libraryUri.path) == '.drift';

  bool sameName(String name) => this.name.toLowerCase() == name.toLowerCase();

  Map<String, Object?> toJson() => _$DriftElementIdToJson(this);

  @override
  int get hashCode => Object.hash(DriftElementId, libraryUri, name);

  @override
  bool operator ==(Object other) {
    return other is DriftElementId &&
        other.libraryUri == libraryUri &&
        other.name == name;
  }

  @override
  String toString() {
    return 'DriftElementId($libraryUri, $name)';
  }
}

@JsonSerializable()
class DriftDeclaration {
  final Uri sourceUri;
  final int offset;

  DriftDeclaration(this.sourceUri, this.offset);

  factory DriftDeclaration.fromJson(Map json) =>
      _$DriftDeclarationFromJson(json);

  Map<String, Object?> toJson() => _$DriftDeclarationToJson(this);

  bool get isDartDeclaration => url.extension(sourceUri.path) == '.dart';
  bool get isDriftDeclaration => url.extension(sourceUri.path) == '.drift';
}

abstract class DriftElement {
  final DriftElementId id;
  final DriftDeclaration declaration;

  Iterable<DriftElement> get references => const Iterable.empty();

  DriftElement(this.id, this.declaration);
}

abstract class DriftSchemaElement extends DriftElement {
  DriftSchemaElement(super.id, super.declaration);

  /// The exact, unaliased name of this element in the database's schema.
  String get schemaName => id.name;
}

abstract class DriftElementWithResultSet extends DriftSchemaElement {
  List<DriftColumn> get columns;

  DriftElementWithResultSet(super.id, super.declaration);
}
