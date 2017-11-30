import 'package:code_builder/code_builder.dart';

import 'fields.dart';

Method buildHashCode(Iterable<MessageField> fields) {
  final statements = <Code>[literal(0).assignVar('hash').statement];
  statements.addAll(fields.map((field) =>
      new Code('hash = _hashCombine(hash, _deepHashCode(${field.name}));')));
  statements.add(new Code('return _hashComplete(hash);'));
  return new Method((b) => b
    ..annotations.add(refer('override'))
    ..returns = refer('int')
    ..type = MethodType.getter
    ..name = 'hashCode'
    ..body = new Block.of(statements));
}
