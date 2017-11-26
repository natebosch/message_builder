import 'package:code_builder/code_builder.dart';

import 'equality.dart';
import 'fields.dart';
import 'hash_code.dart';

abstract class Description {
  Iterable<Spec> get implementation;
  bool get hasListField;
  factory Description.parse(String name, Map params) {
    if (params.containsKey('enumValues')) {
      return new EnumType(
          name, params['wireType'], _parseEnumValues(params['enumValues']));
    }
    if (params.containsKey('subclassBy')) {
      return _parseSubclassedMessage(name, params);
    }
    var fields = params.containsKey('fields')
        ? MessageField.parse(params['fields'])
        : MessageField.parse(params);
    return new Message(name, fields);
  }
}

Description _parseSubclassedMessage(String name, Map params) {
  var parentField = params['subclassBy'];
  var subclasses = <Message>[];
  var subclassSelections = <Expression, String>{};
  var descriptions = params['subclasses'];
  for (var subclass in descriptions.keys.toList()..sort()) {
    var description = descriptions[subclass];
    var fields = {};
    if (description.containsKey('fields')) {
      fields.addAll(description['fields']);
    }
    var parentFieldToken = literal(description['selectOn']);
    subclasses.add(new Message(subclass, MessageField.parse(fields), name,
        parentField.keys.single, parentFieldToken));
    subclassSelections[parentFieldToken] = subclass;
  }
  return new SubclassedMessage(
      name, subclasses, parentField.keys.single, subclassSelections);
}

Iterable<EnumValue> _parseEnumValues(Map values) {
  var names = values.keys.toList()..sort();
  return names.map((name) => new EnumValue(name, values[name]));
}

class EnumType implements Description {
  final String name;
  final Reference wireType;
  final Iterable<EnumValue> values;
  EnumType(this.name, String wireType, this.values)
      : wireType = refer(wireType);
  @override
  bool get hasListField => false;

  @override
  Iterable<Spec> get implementation {
    final constValues = values.map((v) => new Field((b) => b
      ..static = true
      ..modifier = FieldModifier.constant
      ..name = v.name
      ..assignment = refer(name).constInstanceNamed('_', [v.wireId]).code));
    final valueField = new Field((b) => b
      ..modifier = FieldModifier.final$
      ..type = wireType
      ..name = '_value');
    final valueMap = new Map<Expression, Expression>.fromIterable(values,
        key: (v) => v.wireId, value: (v) => refer(name).property(v.name));
    final fromJson = new Constructor((b) => b
      ..factory = true
      ..name = 'fromJson'
      ..requiredParameters.add(new Parameter((b) => b
        ..name = 'value'
        ..type = wireType))
      ..body = new Block.of([
        literalConstMap(valueMap).assignConst('values').statement,
        refer('values').index(refer('value')).returned.statement
      ]));
    final unnamed = new Constructor((b) => b
      ..constant = true
      ..name = '_'
      ..requiredParameters.add(new Parameter((b) => b..name = 'this._value')));
    final toJson = new Method((b) => b
      ..returns = wireType
      ..name = 'toJson'
      ..lambda = true
      ..body = refer('_value').code);
    return [
      new Class((b) => b
        ..name = name
        ..fields.addAll(constValues)
        ..fields.add(valueField)
        ..constructors.add(fromJson)
        ..constructors.add(unnamed)
        ..methods.add(toJson))
    ];
  }
}

class EnumValue {
  final String name;
  final Expression wireId;
  EnumValue(this.name, dynamic /*String|int*/ wireValue)
      : wireId = literal(wireValue);
}

class SubclassedMessage implements Description {
  final String name;
  final List<Message> subclasses;
  final String subclassBy;
  final Map<Expression, String> subclassSelections;
  SubclassedMessage(
      this.name, this.subclasses, this.subclassBy, this.subclassSelections);

  @override
  bool get hasListField => subclasses.any((m) => m.hasListField);

  @override
  Iterable<Spec> get implementation {
    final selection = <Code>[
      refer('params')
          .index(literalString(subclassBy))
          .assignFinal('selectBy')
          .statement
    ];
    for (final key in subclassSelections.keys) {
      final ctor = 'new ${subclassSelections[key]}.fromJson(params)';
      selection.add(new Code('if (selectBy == $key) return $ctor;'));
    }
    selection.add(new Code(
        "throw new ArgumentError('Could not match $name for \$selectBy');"));
    final fromJson = new Constructor((b) => b
      ..factory = true
      ..name = 'fromJson'
      ..requiredParameters.add((new Parameter((b) => b
        ..type = refer('Map')
        ..name = 'params')))
      ..body = new Block.of(selection));
    final toJson = new Method((b) => b
      ..returns = refer('Map')
      ..name = 'toJson');
    return [
      new Class((b) => b
        ..abstract = true
        ..name = name
        ..constructors.add(fromJson)
        ..methods.add(toJson))
    ]..addAll(subclasses.expand((c) => c.implementation));
  }
}

class Message implements Description {
  final String name;
  final List<MessageField> fields;
  final String parent;
  final String parentField;
  final Expression parentFieldToken;
  Message(this.name, this.fields,
      [this.parent, this.parentField, this.parentFieldToken]);

  String get _builderName => '$name\$Builder';

  @override
  bool get hasListField => fields.any((f) => f.type is ListFieldType);

  @override
  Iterable<Spec> get implementation {
    final fieldDeclarations = fields
        .map((f) => f.declaration)
        .map((d) => d.rebuild((b) => b.modifier = FieldModifier.final$))
        .toList();
    if (parentField != null) {
      fieldDeclarations.add(new Field((b) => b
        ..modifier = FieldModifier.final$
        ..name = parentField
        ..assignment = parentFieldToken.code));
    }
    final toJsonMap = new Map<Expression, Expression>.fromIterable(fields,
        key: (field) => literalString(field.name),
        value: (field) => field.type.toJson(refer(field.name)));
    if (parentField != null) {
      toJsonMap[literalString(parentField)] = parentFieldToken;
    }
    final toJson = new Method((b) => b
      ..returns = refer('Map')
      ..name = 'toJson'
      ..lambda = true
      ..body = literalMap(toJsonMap).code);
    final implements = parent == null ? <Reference>[] : [refer(parent)];
    var clazz = new Class((b) => b
      ..name = name
      ..implements.addAll(implements)
      ..fields.addAll(fieldDeclarations)
      ..constructors.addAll(_ctors)
      ..methods.add(toJson)
      ..methods.add(buildHashCode(fields))
      ..methods.add(buildEquals(name, fields)));
    var builder = new Class((b) => b
      ..name = _builderName
      ..fields.addAll(fields.map((f) => f.declaration))
      ..constructors.add(new Constructor((b) => b..name = '_')));
    return [
      clazz,
      builder,
    ];
  }

  Iterable<Constructor> get _ctors => fields.isNotEmpty
      ? [
          new Constructor((b) => b
            ..name = '_'
            ..requiredParameters.addAll(fields
                .map((f) => new Parameter((b) => b..name = 'this.${f.name}')))),
          new Constructor((b) => b
            ..factory = true
            ..requiredParameters.add(new Parameter((b) => b
              ..type = new FunctionType((b) => b
                ..returnType = refer('void')
                ..requiredParameters.add(refer(_builderName)))
              ..name = 'init'))
            ..body = new Block.of([
              refer(_builderName)
                  .newInstanceNamed('_', [])
                  .assignFinal('b')
                  .statement,
              refer('init').call([refer('b')]).statement,
              refer(name)
                  .newInstanceNamed(
                      '_', fields.map((f) => refer('b').property(f.name)))
                  .returned
                  .statement,
            ])),
          new Constructor((b) => b
            ..factory = true
            ..name = 'fromJson'
            ..lambda = true
            ..requiredParameters.add(new Parameter((b) => b
              ..type = refer('Map')
              ..name = 'params'))
            ..body = refer(name)
                .newInstanceNamed('_', fields.map((f) => f.fromParams))
                .code),
        ]
      : [
          new Constructor((b) => b..constant = true),
          new Constructor((b) => b
            ..constant = true
            ..name = 'fromJson'
            ..optionalParameters.add(new Parameter((b) => b..name = '_')))
        ];
}
