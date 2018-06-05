class InnerMessage {
  InnerMessage._(this.anotherField);

  factory InnerMessage(void Function(InnerMessage$Builder) init) {
    final b = new InnerMessage$Builder._();
    init(b);
    return new InnerMessage._(b.anotherField);
  }

  factory InnerMessage.fromJson(Map params) => new InnerMessage._(
      params.containsKey('anotherField') && params['anotherField'] != null
          ? params['anotherField']
          : null);

  final String anotherField;

  Map toJson() {
    final $$result = {};
    final $anotherField = anotherField;
    if ($anotherField != null) {
      $$result['anotherField'] = $anotherField;
    }
    return $$result;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = _hashCombine(hash, _deepHashCode(anotherField));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) {
    if (other is! InnerMessage) return false;
    var o = other as InnerMessage;
    if (anotherField != o.anotherField) return false;
    return true;
  }
}

class InnerMessage$Builder {
  InnerMessage$Builder._();

  String anotherField;
}

class OuterMessage {
  OuterMessage._(this.innerField, this.stringField);

  factory OuterMessage(void Function(OuterMessage$Builder) init) {
    final b = new OuterMessage$Builder._();
    init(b);
    return new OuterMessage._(b.innerField, b.stringField);
  }

  factory OuterMessage.fromJson(Map params) => new OuterMessage._(
      params.containsKey('innerField') && params['innerField'] != null
          ? new InnerMessage.fromJson(params['innerField'])
          : null,
      params.containsKey('stringField') && params['stringField'] != null
          ? params['stringField']
          : null);

  final InnerMessage innerField;

  final String stringField;

  Map toJson() {
    final $$result = {};
    final $innerField = innerField?.toJson();
    if ($innerField != null) {
      $$result['innerField'] = $innerField;
    }
    final $stringField = stringField;
    if ($stringField != null) {
      $$result['stringField'] = $stringField;
    }
    return $$result;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = _hashCombine(hash, _deepHashCode(innerField));
    hash = _hashCombine(hash, _deepHashCode(stringField));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) {
    if (other is! OuterMessage) return false;
    var o = other as OuterMessage;
    if (innerField != o.innerField) return false;
    if (stringField != o.stringField) return false;
    return true;
  }
}

class OuterMessage$Builder {
  OuterMessage$Builder._();

  InnerMessage innerField;

  String stringField;
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
