import 'package:code_builder/code_builder.dart';

import 'fields.dart';

Method buildHashCode(Iterable<MessageField> fields) {
  final statements = <Code>[literal(0).assignVar('hash').statement];
  statements.addAll(fields.map((field) =>
      Code('hash = _hashCombine(hash, _deepHashCode(${field.name}));')));
  statements.add(Code('return _hashComplete(hash);'));
  return Method((b) => b
    ..annotations.add(refer('override'))
    ..returns = refer('int')
    ..type = MethodType.getter
    ..name = 'hashCode'
    ..body = Block.of(statements));
}
