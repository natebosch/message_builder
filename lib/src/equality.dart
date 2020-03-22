import 'package:code_builder/code_builder.dart';

import 'fields.dart';

Method buildEquals(String clazz, Iterable<MessageField> fields) {
  final signature = Method((b) => b
    ..annotations.add(refer('override'))
    ..returns = refer('bool')
    ..name = 'operator=='
    ..requiredParameters.add((Parameter((b) => b
      ..type = refer('Object')
      ..name = 'other'))));
  if (fields.isEmpty) {
    return signature.rebuild((b) => b
      ..lambda = true
      ..body = refer('other').isA(refer(clazz)).code);
  }
  final statements = [
    'if(other is! $clazz) return false;',
    'final o = other as $clazz;',
  ].map((s) => Code(s)).toList();
  statements.addAll(
      fields.map((f) => Code('if(${f.equalityCheck('o')}) return false;')));
  statements.add(literalTrue.returned.statement);
  return signature.rebuild((b) => b..body = Block.of(statements));
}
