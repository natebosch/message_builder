import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:yaml/yaml.dart';

import 'src/description.dart';

Builder messageBuilder(_) => const MessageBuilder();

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
    final result = <Spec>[];
    var hasCollection = false;
    for (final name in descriptions.keys.toList()..sort()) {
      final description = new Description.parse(name, descriptions[name]);
      if (description.hasCollectionField) hasCollection = true;
      result.addAll(description.implementation);
    }
    result.add(_hashMethods);
    if (hasCollection) {
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
  if (left is Map && right is Map) {
    var leftLength = left.length;
    var rightLength = right.length;
    if(leftLength != rightLength) return false;
    for(final key in left.keys) {
      if(!_deepEquals(left[key], right[key])) return false;
    }
    return true;
  }
  return left == right;
}
''');

const _hashMethods = const Code('''
int _hashCombine(int hash, int value) {
  hash = 0x1fffffff & (hash + value);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}
int _hashComplete(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}
int _deepHashCode(dynamic value) {
  if (value is List) {
    return value.map(_deepHashCode).reduce(_hashCombine);
  }
  if (value is Map) {
    return (value.keys
            .map((key) => _hashCombine(key.hashCode, _deepHashCode(value[key])))
            .toList(growable: false)
              ..sort())
      .reduce(_hashCombine);
  }
  return value.hashCode;
}
''');
