abstract class ParentMessage {
  factory ParentMessage.fromJson(Map params) {
    final selectBy = params['selectField'];
    if (selectBy == 'firstValue') return new FirstChildMessage.fromJson(params);
    if (selectBy == 'secondValue')
      return new SecondChildMessage.fromJson(params);
    if (selectBy == 'thirdValue') return new ThirdChildMessage.fromJson(params);
    throw new ArgumentError('Could not match ParentMessage for $selectBy');
  }

  Map toJson();
}

class FirstChildMessage implements ParentMessage {
  FirstChildMessage._(this.firstField);

  factory FirstChildMessage(void Function(FirstChildMessage$Builder) init) {
    final b = new FirstChildMessage$Builder._();
    init(b);
    return new FirstChildMessage._(b.firstField);
  }

  factory FirstChildMessage.fromJson(Map params) => new FirstChildMessage._(
      params.containsKey('firstField') && params['firstField'] != null
          ? params['firstField']
          : null);

  final int firstField;

  final selectField = 'firstValue';

  Map toJson() {
    final $$result = {};
    final $firstField = firstField;
    if ($firstField != null) {
      $$result['firstField'] = $firstField;
    }
    final $selectField = 'firstValue';
    if ($selectField != null) {
      $$result['selectField'] = $selectField;
    }
    return $$result;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = _hashCombine(hash, _deepHashCode(firstField));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) {
    if (other is! FirstChildMessage) return false;
    var o = other as FirstChildMessage;
    if (firstField != o.firstField) return false;
    return true;
  }
}

class FirstChildMessage$Builder {
  FirstChildMessage$Builder._();

  int firstField;
}

class SecondChildMessage implements ParentMessage {
  SecondChildMessage._(this.secondField);

  factory SecondChildMessage(void Function(SecondChildMessage$Builder) init) {
    final b = new SecondChildMessage$Builder._();
    init(b);
    return new SecondChildMessage._(b.secondField);
  }

  factory SecondChildMessage.fromJson(Map params) => new SecondChildMessage._(
      params.containsKey('secondField') && params['secondField'] != null
          ? params['secondField']
          : null);

  final String secondField;

  final selectField = 'secondValue';

  Map toJson() {
    final $$result = {};
    final $secondField = secondField;
    if ($secondField != null) {
      $$result['secondField'] = $secondField;
    }
    final $selectField = 'secondValue';
    if ($selectField != null) {
      $$result['selectField'] = $selectField;
    }
    return $$result;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = _hashCombine(hash, _deepHashCode(secondField));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) {
    if (other is! SecondChildMessage) return false;
    var o = other as SecondChildMessage;
    if (secondField != o.secondField) return false;
    return true;
  }
}

class SecondChildMessage$Builder {
  SecondChildMessage$Builder._();

  String secondField;
}

class ThirdChildMessage implements ParentMessage {
  const ThirdChildMessage();

  const ThirdChildMessage.fromJson([_]);

  final selectField = 'thirdValue';

  Map toJson() {
    final $$result = {};
    final $selectField = 'thirdValue';
    if ($selectField != null) {
      $$result['selectField'] = $selectField;
    }
    return $$result;
  }

  @override
  int get hashCode {
    var hash = 0;
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) => other is ThirdChildMessage;
}

class ThirdChildMessage$Builder {
  ThirdChildMessage$Builder._();
}

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
