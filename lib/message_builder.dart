import 'dart:async';

import 'package:build/build.dart';
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
    var descriptions =
        loadYaml(await buildStep.readAsString(buildStep.inputId));
    var result = new StringBuffer();
    var hasList = false;
    for (var name in descriptions.keys.toList()..sort()) {
      var description = parseDescription(name, descriptions[name]);
      if (description.hasListField) hasList = true;
      result.write(description.implementation);
    }
    if (hasList) {
      result.write(_deepEquals);
    }
    var formatter = new DartFormatter();
    buildStep.writeAsString(buildStep.inputId.changeExtension('.dart'),
        formatter.format(result.toString()));
  }
}

const _deepEquals = '''
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
''';
