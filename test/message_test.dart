import 'package:test/test.dart';

import 'goldens/list_field.dart';
import 'goldens/message.dart';
import 'goldens/nested_in_list.dart';
import 'goldens/nested_message.dart';
import 'goldens/subclassed_message.dart';

void main() {
  group('message', () {
    test('deserialize', () {
      var serialized = {'stringField': 'stringValue', 'intField': 1};
      expect(
          new SomeMessage.fromJson(serialized),
          new SomeMessage((b) => b
            ..stringField = 'stringValue'
            ..intField = 1));
    });

    test('serialize', () {
      var message = new SomeMessage((b) => b
        ..stringField = 'value'
        ..intField = 2);
      expect(message.toJson(), {'stringField': 'value', 'intField': 2});
    });

    test('hashCode', () {
      var message = new SomeMessage((b) => b
        ..stringField = 'value'
        ..intField = 2);
      var messageSame = new SomeMessage((b) => b
        ..stringField = 'value'
        ..intField = 2);
      var messageDifferent = new SomeMessage((b) => b
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
          new SomeListMessage.fromJson(serialized),
          new SomeListMessage((b) => b
            ..stringList = ['first', 'second']
            ..intList = [1, 2]));
    });

    test('serialize', () {
      var message = new SomeListMessage((b) => b
        ..stringList = ['a', 'b']
        ..intList = [3]);
      expect(message.toJson(), {
        'stringList': ['a', 'b'],
        'intList': [3]
      });
    });

    test('hashCode', () {
      var message = new SomeListMessage((b) => b
        ..stringList = ['a', 'b']
        ..intList = [3, 4]);
      var messageSame = new SomeListMessage((b) => b
        ..stringList = ['a', 'b']
        ..intList = [3, 4]);
      var messageDifferent = new SomeListMessage((b) => b
        ..stringList = ['c', 'd']
        ..intList = [3, 4]);
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
    }, skip: 'Hashcode is broken for collections');
  });

  group('nested message', () {
    test('serialize', () {
      var serialized = {
        'innerField': {'anotherField': 'foo'},
        'stringField': 'value'
      };
      expect(
          new OuterMessage.fromJson(serialized),
          new OuterMessage((b) => b
            ..innerField = new InnerMessage((b) => b..anotherField = 'foo')
            ..stringField = 'value'));
    });
    test('deserialize', () {
      var message = new OuterMessage((b) => b
        ..innerField = new InnerMessage((b) => b..anotherField = 'foo')
        ..stringField = 'value');
      expect(message.toJson(), {
        'innerField': {'anotherField': 'foo'},
        'stringField': 'value'
      });
    });
    test('hashcode', () {
      var message = new OuterMessage((b) => b
        ..innerField = new InnerMessage((b) => b..anotherField = 'foo')
        ..stringField = 'value');
      var messageSame = new OuterMessage((b) => b
        ..innerField = new InnerMessage((b) => b..anotherField = 'foo')
        ..stringField = 'value');
      var messageDifferent = new OuterMessage((b) => b
        ..innerField = new InnerMessage((b) => b..anotherField = 'different')
        ..stringField = 'value');
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
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
          new OuterMessageWithList.fromJson(serialized),
          new OuterMessageWithList((b) => b
            ..innerField = [
              new InnerMessageInList((b) => b..anotherField = 'foo'),
              new InnerMessageInList((b) => b..anotherField = 'bar'),
            ]));
    });
    test('deserialize', () {
      var message = new OuterMessageWithList((b) => b
        ..innerField = [
          new InnerMessageInList((b) => b..anotherField = 'foo'),
          new InnerMessageInList((b) => b..anotherField = 'bar')
        ]);
      expect(message.toJson(), {
        'innerField': [
          {'anotherField': 'foo'},
          {'anotherField': 'bar'}
        ]
      });
    });
    test('hashcode', () {
      var message = new OuterMessageWithList((b) => b
        ..innerField = [
          new InnerMessageInList((b) => b..anotherField = 'foo')
        ]);
      var messageSame = new OuterMessageWithList((b) => b
        ..innerField = [
          new InnerMessageInList((b) => b..anotherField = 'foo')
        ]);
      var messageDifferent = new OuterMessageWithList((b) => b
        ..innerField = [
          new InnerMessageInList((b) => b..anotherField = 'different')
        ]);
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
    }, skip: 'Hashcode is broken for collections');
  });

  group('subclassed message', () {
    test('deserialize', () {
      var serialized = {'selectField': 'firstValue', 'firstField': 1};
      expect(new ParentMessage.fromJson(serialized),
          new isInstanceOf<FirstChildMessage>());
      expect(new ParentMessage.fromJson(serialized),
          new FirstChildMessage((b) => b..firstField = 1));
    });

    test('serialize', () {
      var message = new ThirdChildMessage();
      expect(message.toJson(), {'selectField': 'thirdValue'});
    });
  });
}
