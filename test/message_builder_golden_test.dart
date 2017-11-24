import 'package:test/test.dart';
import 'package:build_test/build_test.dart';

import 'package:message_builder/message_builder.dart';

void main() {
  const builder = const MessageBuilder();

  group('enum', () {
    test('creates an enum-like class', () async {
      await testBuilder(builder, {
        'a|messages.yaml': '''
SomeEnum:
  wireType: int
  enumValues:
    someValue: 1
    anotherValue: 2
'''
      }, outputs: {
        'a|messages.dart': decodedMatches('''
class SomeEnum {
  static const anotherValue = const SomeEnum._(2);
  static const someValue = const SomeEnum._(1);
  final int _value;
  const SomeEnum._(this._value);
  factory SomeEnum.fromJson(int value) {
    const values = const {2: SomeEnum.anotherValue, 1: SomeEnum.someValue};
    return values[value];
  }
  int toJson() => _value;
}
''')
      });
    });
  });
}
