import 'package:code_builder/code_builder.dart';

import 'fields.dart';

Method buildHashCode(Iterable<MessageField> fields) {
  final statements = <Code>[literal(0).assignVar('hash').statement];
  statements.addAll(fields.expand(_hashField));
  statements.addAll([
    'hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));',
    'hash = hash ^ (hash >> 11);',
    'return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));',
  ].map((s) => new Code(s)));
  return new Method((b) => b
    ..annotations.add(refer('override'))
    ..returns = refer('int')
    ..type = MethodType.getter
    ..name = 'hashCode'
    ..body = new Block.of(statements));
}

Iterable<Code> _hashField(MessageField field) => [
      'hash = 0x1fffffff & (hash + ${field.name}.hashCode);',
      'hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));',
      'hash ^= hash >> 6;',
    ].map((s) => new Code(s));
