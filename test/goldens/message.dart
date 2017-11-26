class SomeMessage {
  SomeMessage._(this.intField, this.stringField);

  factory SomeMessage(void Function(SomeMessage$Builder) init) {
    final b = new SomeMessage$Builder._();
    init(b);
    return new SomeMessage._(b.intField, b.stringField);
  }

  factory SomeMessage.fromJson(Map params) => new SomeMessage._(
      params.containsKey('intField') ? params['intField'] : null,
      params.containsKey('stringField') ? params['stringField'] : null);

  final int intField;

  final String stringField;

  Map toJson() => {'intField': intField, 'stringField': stringField};
  @override
  int get hashCode {
    var hash = 0;
    hash = 0x1fffffff & (hash + intField.hashCode);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    hash ^= hash >> 6;
    hash = 0x1fffffff & (hash + stringField.hashCode);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    hash ^= hash >> 6;
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }

  @override
  bool operator ==(Object other) {
    if (other is! SomeMessage) return false;
    var o = other as SomeMessage;
    if (intField != o.intField) return false;
    if (stringField != o.stringField) return false;
    return true;
  }
}

class SomeMessage$Builder {
  SomeMessage$Builder._();

  int intField;

  String stringField;
}
