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
        .call([literalString(name)]).conditional(toType, literalNull);
  }

  Field get declaration => new Field((b) => b
    ..type = type.type
    ..name = name);

  String equalityCheck(String other) =>
      type.equalityCheck(name, '$other.$name');

  static List<MessageField> parse(Map fields) {
    var names = fields.keys.toList()..sort();
    return names
        .map(
            (name) => new MessageField(name, new FieldType.parse(fields[name])))
        .toList();
  }
}

const _primitives = const ['String', 'int', 'bool', 'dynamic'];

abstract class FieldType {
  Expression toJson(Expression e);
  Expression fromParams(Expression fieldValue);
  Reference get type;
  bool get isPrimitive;
  String equalityCheck(String leftToken, String rightToken);

  factory FieldType.parse(dynamic /*String|Map*/ field) {
    if (field is String) {
      if (_primitives.contains(field)) return new PrimitiveFieldType(field);
      return new MessageFieldType(field);
    }
    if (field is Map) {
      if (field.containsKey('listType')) {
        return new ListFieldType(new FieldType.parse(field['listType']));
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
  bool get isPrimitive => true;

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
  bool get isPrimitive => false;

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
    final toJsonClosure = new Method((b) => b
      ..lambda = true
      ..requiredParameters.add((new Parameter((b) => b..name = 'v')))
      ..body = typeArgument.toJson((refer('v'))).code).closure;
    return e
        .nullSafeProperty('map')
        .call([toJsonClosure])
        .nullSafeProperty('toList')
        .call([]);
  }

  @override
  Expression fromParams(Expression fieldValue) {
    if (typeArgument.isPrimitive) return fieldValue;
    final fromJsonClosure = new Method((b) => b
      ..lambda = true
      ..requiredParameters.add(new Parameter((b) => b..name = 'v'))
      ..body = typeArgument.fromParams(refer('v')).code).closure;
    return fieldValue
        .property('map')
        .call([fromJsonClosure])
        .property('toList')
        .call([]);
  }

  @override
  Reference get type => new TypeReference((b) => b
    ..symbol = 'List'
    ..types.add(typeArgument.type));

  @override
  bool get isPrimitive => typeArgument.isPrimitive;

  @override
  String equalityCheck(String leftToken, String rightToken) =>
      '!_deepEquals($leftToken, $rightToken)';
}
