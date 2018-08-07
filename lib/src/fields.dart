import 'package:code_builder/code_builder.dart';

class MessageField {
  final String name;
  final FieldType type;
  MessageField(this.name, this.type);

  Expression get fromParams {
    final paramValue = refer('params').index(literalString(name));
    final toType = type.fromParams(paramValue);
    return refer('params')
        .property('containsKey')
        .call([literalString(name)])
        .and(refer('params').index(literalString(name)).notEqualTo(literalNull))
        .conditional(toType, literalNull);
  }

  Field get declaration => Field((b) => b
    ..type = type.type
    ..name = name);

  String equalityCheck(String other) =>
      type.equalityCheck(name, '$other.$name');

  static List<MessageField> parse(Map fields) {
    var names = fields.keys.toList()..sort();
    return names
        .map((name) => MessageField(name, FieldType.parse(fields[name])))
        .toList();
  }
}

const _primitives = ['String', 'int', 'bool', 'dynamic'];

abstract class FieldType {
  Expression toJson(Expression e);
  Expression fromParams(Expression fieldValue);
  Reference get type;
  bool get isPrimitive;
  bool get canCastInCollection;
  String equalityCheck(String leftToken, String rightToken);

  factory FieldType.parse(dynamic /*String|Map*/ field) {
    if (field is String) {
      if (_primitives.contains(field)) return PrimitiveFieldType(field);
      return MessageFieldType(field);
    }
    if (field is Map) {
      if (field.containsKey('listType')) {
        return ListFieldType(FieldType.parse(field['listType']));
      }
      if (field.containsKey('mapType')) {
        return MapFieldType(FieldType.parse(field['mapType']));
      }
    }
    throw 'Unhandled field type [$field]';
  }
}

class PrimitiveFieldType implements FieldType {
  final String name;
  PrimitiveFieldType(this.name);

  @override
  Expression toJson(Expression e) => e;

  @override
  Expression fromParams(Expression fieldValue) => fieldValue;

  @override
  Reference get type => refer(name);

  @override
  final isPrimitive = true;

  @override
  final canCastInCollection = true;

  @override
  String equalityCheck(String leftToken, String rightToken) =>
      '$leftToken != $rightToken';
}

class MessageFieldType implements FieldType {
  final String name;
  MessageFieldType(this.name);

  @override
  Expression toJson(Expression e) => e.nullSafeProperty('toJson').call([]);

  @override
  Expression fromParams(Expression fieldValue) =>
      refer(name).newInstanceNamed('fromJson', [fieldValue]);

  @override
  Reference get type => refer(name);

  @override
  final isPrimitive = false;

  @override
  final canCastInCollection = false;

  @override
  String equalityCheck(String leftToken, String rightToken) =>
      '$leftToken != $rightToken';
}

class ListFieldType implements FieldType {
  final FieldType typeArgument;
  ListFieldType(this.typeArgument);

  @override
  Expression toJson(Expression e) {
    if (typeArgument.isPrimitive) return e;
    final toJsonClosure = Method((b) => b
      ..lambda = true
      ..requiredParameters.add((Parameter((b) => b..name = 'v')))
      ..body = typeArgument.toJson((refer('v'))).code).closure;
    return e
        .nullSafeProperty('map')
        .call([toJsonClosure])
        .nullSafeProperty('toList')
        .call([]);
  }

  @override
  Expression fromParams(Expression fieldValue) {
    if (typeArgument.canCastInCollection)
      return fieldValue
          .asA(refer('List'))
          .property('cast')
          .call([], {}, [typeArgument.type]);
    final fromJsonClosure = Method((b) => b
      ..lambda = true
      ..requiredParameters.add(Parameter((b) => b..name = 'v'))
      ..body = typeArgument.fromParams(refer('v')).code).closure;
    return fieldValue
        .asA(refer('List'))
        .property('map')
        .call([fromJsonClosure])
        .property('toList')
        .call([]);
  }

  @override
  Reference get type => TypeReference((b) => b
    ..symbol = 'List'
    ..types.add(typeArgument.type));

  @override
  bool get isPrimitive => typeArgument.isPrimitive;

  @override
  final canCastInCollection = false;

  @override
  String equalityCheck(String leftToken, String rightToken) =>
      '!_deepEquals($leftToken, $rightToken)';
}

class MapFieldType implements FieldType {
  final FieldType typeArgument;
  MapFieldType(this.typeArgument);

  @override
  Expression toJson(Expression e) {
    if (typeArgument.isPrimitive) return e;
    final toMapEntryClosure = Method((b) => b
      ..lambda = true
      ..requiredParameters.add(Parameter((b) => b..name = 'k'))
      ..requiredParameters.add(Parameter((b) => b..name = 'v'))
      ..body = refer('MapEntry').newInstance(
          [refer('k'), typeArgument.toJson(refer('v'))],
          {},
          [refer('String'), refer('dynamic')]).code).closure;
    return e.nullSafeProperty('map').call([toMapEntryClosure]);
  }

  @override
  Expression fromParams(Expression fieldValue) {
    if (typeArgument.canCastInCollection)
      return fieldValue
          .asA(refer('Map'))
          .property('cast')
          .call([], {}, [refer('String'), typeArgument.type]);
    final toMapEntryClosure = Method((b) => b
      ..lambda = true
      ..requiredParameters.add(Parameter((b) => b..name = 'k'))
      ..requiredParameters.add(Parameter((b) => b..name = 'v'))
      ..body = refer('MapEntry').newInstance(
          [refer('k'), typeArgument.fromParams(refer('v'))],
          {},
          [refer('String'), typeArgument.type]).code).closure;
    return fieldValue
        .asA(refer('Map'))
        .property('map')
        .call([toMapEntryClosure]);
  }

  @override
  Reference get type => TypeReference((b) => b
    ..symbol = 'Map'
    ..types.addAll([refer('String'), typeArgument.type]));

  @override
  bool get isPrimitive => typeArgument.isPrimitive;

  @override
  final canCastInCollection = false;

  @override
  String equalityCheck(String leftToken, String rightToken) =>
      '!_deepEquals($leftToken, $rightToken)';
}
