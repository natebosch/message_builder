import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:yaml/yaml.dart';

import 'src/description.dart';

class MessageBuilder implements Builder {
  const MessageBuilder();

  @override
  final buildExtensions = const {
    '.yaml': const ['.dart']
  };

  @override
  Future build(BuildStep buildStep) async {
    final descriptions =
        loadYaml(await buildStep.readAsString(buildStep.inputId));
    final result = <Code>[];
    var hasList = false;
    for (final name in descriptions.keys.toList()..sort()) {
      final description = new Description.parse(name, descriptions[name]);
      if (description.hasListField) hasList = true;
      result.addAll(description.implementation);
    }
    if (hasList) {
      result.add(_deepEquals);
    }
    final library = new Library((b) => b.body.addAll(result));
    final emitter = new DartEmitter(new Allocator.simplePrefixing());
    buildStep.writeAsString(buildStep.inputId.changeExtension('.dart'),
        new DartFormatter().format('${library.accept(emitter)}'));
  }
}

const _deepEquals = const Code('''
_deepEquals(dynamic left, dynamic right) {
  if (left is List && right is List) {
    var leftLength = left.length;
    var rightLength = right.length;
    if (leftLength != rightLength) return false;
    for(int i = 0; i < leftLength; i++) {
      if(!_deepEquals(left[i], right[i])) return false;
    }
    return true;
  }
  return left == right;
}
''');
