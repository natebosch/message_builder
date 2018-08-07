import 'package:test/test.dart';

import 'goldens/list_field.dart';
import 'goldens/map_field.dart';
import 'goldens/message.dart';
import 'goldens/nested_in_list.dart';
import 'goldens/nested_message.dart';
import 'goldens/subclassed_message.dart';

void main() {
  group('message', () {
    test('deserialize', () {
      var serialized = {'stringField': 'stringValue', 'intField': 1};
      expect(
          SomeMessage.fromJson(serialized),
          SomeMessage((b) => b
            ..stringField = 'stringValue'
            ..intField = 1));
    });

    test('serialize', () {
      var message = SomeMessage((b) => b
        ..stringField = 'value'
        ..intField = 2);
      expect(message.toJson(), {'stringField': 'value', 'intField': 2});
    });

    test('hashCode', () {
      var message = SomeMessage((b) => b
        ..stringField = 'value'
        ..intField = 2);
      var messageSame = SomeMessage((b) => b
        ..stringField = 'value'
        ..intField = 2);
      var messageDifferent = SomeMessage((b) => b
        ..stringField = 'value'
        ..intField = 3);
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
    });
  });

  group('with list field', () {
    test('deserialize', () {
      var serialized = {
        'stringList': ['first', 'second'],
        'intList': [1, 2]
      };
      expect(
          SomeListMessage.fromJson(serialized),
          SomeListMessage((b) => b
            ..stringList = ['first', 'second']
            ..intList = [1, 2]));
    });

    test('serialize', () {
      var message = SomeListMessage((b) => b
        ..stringList = ['a', 'b']
        ..intList = [3]);
      expect(message.toJson(), {
        'stringList': ['a', 'b'],
        'intList': [3]
      });
    });

    test('hashCode', () {
      var message = SomeListMessage((b) => b
        ..stringList = ['a', 'b']
        ..intList = [3, 4]);
      var messageSame = SomeListMessage((b) => b
        ..stringList = ['a', 'b']
        ..intList = [3, 4]);
      var messageDifferent = SomeListMessage((b) => b
        ..stringList = ['c', 'd']
        ..intList = [3, 4]);
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
    });
  });

  group('nested message', () {
    test('serialize', () {
      var serialized = {
        'innerField': {'anotherField': 'foo'},
        'stringField': 'value'
      };
      expect(
          OuterMessage.fromJson(serialized),
          OuterMessage((b) => b
            ..innerField = InnerMessage((b) => b..anotherField = 'foo')
            ..stringField = 'value'));
    });
    test('deserialize', () {
      var message = OuterMessage((b) => b
        ..innerField = InnerMessage((b) => b..anotherField = 'foo')
        ..stringField = 'value');
      expect(message.toJson(), {
        'innerField': {'anotherField': 'foo'},
        'stringField': 'value'
      });
    });
    test('hashcode', () {
      var message = OuterMessage((b) => b
        ..innerField = InnerMessage((b) => b..anotherField = 'foo')
        ..stringField = 'value');
      var messageSame = OuterMessage((b) => b
        ..innerField = InnerMessage((b) => b..anotherField = 'foo')
        ..stringField = 'value');
      var messageDifferent = OuterMessage((b) => b
        ..innerField = InnerMessage((b) => b..anotherField = 'different')
        ..stringField = 'value');
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
    });
    test('handles omitted keys', () {
      expect(OuterMessage.fromJson({}), OuterMessage((b) {}));
    });
    test('handles keys explicitly set to null', () {
      expect(OuterMessage.fromJson({'innerField': null, 'stringField': null}),
          OuterMessage((b) {}));
    });
  });

  group('nested message in list', () {
    test('serialize', () {
      var serialized = {
        'innerField': [
          {'anotherField': 'foo'},
          {'anotherField': 'bar'}
        ],
      };
      expect(
          OuterMessageWithList.fromJson(serialized),
          OuterMessageWithList((b) => b
            ..innerField = [
              InnerMessageInList((b) => b..anotherField = 'foo'),
              InnerMessageInList((b) => b..anotherField = 'bar'),
            ]));
    });
    test('deserialize', () {
      var message = OuterMessageWithList((b) => b
        ..innerField = [
          InnerMessageInList((b) => b..anotherField = 'foo'),
          InnerMessageInList((b) => b..anotherField = 'bar')
        ]);
      expect(message.toJson(), {
        'innerField': [
          {'anotherField': 'foo'},
          {'anotherField': 'bar'}
        ]
      });
    });
    test('hashcode', () {
      var message = OuterMessageWithList((b) =>
          b..innerField = [InnerMessageInList((b) => b..anotherField = 'foo')]);
      var messageSame = OuterMessageWithList((b) =>
          b..innerField = [InnerMessageInList((b) => b..anotherField = 'foo')]);
      var messageDifferent = OuterMessageWithList((b) => b
        ..innerField = [
          InnerMessageInList((b) => b..anotherField = 'different')
        ]);
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
    });
  });

  group('subclassed message', () {
    test('deserialize', () {
      var serialized = {'selectField': 'firstValue', 'firstField': 1};
      expect(ParentMessage.fromJson(serialized),
          isInstanceOf<FirstChildMessage>());
      expect(ParentMessage.fromJson(serialized),
          FirstChildMessage((b) => b..firstField = 1));
    });

    test('serialize', () {
      var message = ThirdChildMessage();
      expect(message.toJson(), {'selectField': 'thirdValue'});
    });
  });

  group('map fields', () {
    test('deserialize', () {
      var serialized = {
        'intMap': {'a': 1},
        'messageMap': {
          'b': {
            'innerMessageMap': {'foo': 'bar'}
          }
        },
        'listMap': {
          'c': [1, 2]
        },
        'mapMap': {
          'd': {'e': 'f'}
        }
      };
      expect(
          SomeMapMessage.fromJson(serialized),
          SomeMapMessage((b) => b
            ..intMap = {'a': 1}
            ..messageMap = {
              'b': AnotherMessage((b) => b..innerMessageMap = {'foo': 'bar'})
            }
            ..listMap = {
              'c': [1, 2]
            }
            ..mapMap = {
              'd': {'e': 'f'}
            }));
    });

    test('serialize', () {
      var message = SomeMapMessage((b) => b
        ..intMap = {'a': 1}
        ..messageMap = {
          'b': AnotherMessage((b) => b..innerMessageMap = {'foo': 'bar'})
        }
        ..listMap = {
          'c': [1, 2]
        }
        ..mapMap = {
          'd': {'e': 'f'}
        });
      expect(message.toJson(), {
        'intMap': {'a': 1},
        'messageMap': {
          'b': {
            'innerMessageMap': {'foo': 'bar'}
          }
        },
        'listMap': {
          'c': [1, 2]
        },
        'mapMap': {
          'd': {'e': 'f'}
        }
      });
    });

    test('hashCode', () {
      var message = SomeMapMessage((b) => b
        ..intMap = {'a': 1, 'z': 2}
        ..messageMap = {
          'b': AnotherMessage((b) => b..innerMessageMap = {'foo': 'bar'})
        }
        ..listMap = {
          'c': [1, 2]
        }
        ..mapMap = {
          'd': {'e': 'f'}
        });
      var messageSame = SomeMapMessage((b) => b
        ..intMap = {'z': 2, 'a': 1}
        ..messageMap = {
          'b': AnotherMessage((b) => b..innerMessageMap = {'foo': 'bar'})
        }
        ..listMap = {
          'c': [1, 2]
        }
        ..mapMap = {
          'd': {'e': 'f'}
        });
      var messageDifferent = SomeMapMessage((b) => b
        ..intMap = {'a': 1}
        ..messageMap = {
          'b': AnotherMessage((b) => b..innerMessageMap = {'foo': 'different'})
        }
        ..listMap = {
          'c': [1, 2]
        }
        ..mapMap = {
          'd': {'e': 'f'}
        });
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
    });
  });
}
