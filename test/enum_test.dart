import 'package:test/test.dart';

import 'goldens/enum.dart';

void main() {
  group('enum', () {
    test('deserialize', () {
      var serialized = {'enumField': 1};
      expect(new MessageUsingEnum.fromJson(serialized),
          new MessageUsingEnum((b) => b..enumField = SomeEnum.someValue));
    });

    test('serialize', () {
      var message =
          new MessageUsingEnum((b) => b..enumField = SomeEnum.anotherValue);
      expect(message.toJson(), {'enumField': 2});
    });
  });
}
