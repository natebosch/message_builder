class SomeMessage {
  final int intField;
  final String stringField;

  SomeMessage._(this.intField, this.stringField);
  factory SomeMessage(void init(SomeMessage$Builder b)) {
    var b = new SomeMessage$Builder._();
    init(b);
    return new SomeMessage._(b.intField, b.stringField);
  }

  factory SomeMessage.fromJson(Map params) => new SomeMessage._(
      params.containsKey("intField") ? params["intField"] : null,
      params.containsKey("stringField") ? params["stringField"] : null);

  Map toJson() => {"intField": intField, "stringField": stringField};

  @override
  bool operator ==(Object other) {
    if (other is! SomeMessage) return false;
    var o = other as SomeMessage;
    if (intField != o.intField) return false;
    if (stringField != o.stringField) return false;
    return true;
  }

  @override
  int get hashCode {
    int hash = 0;
    for (var field in [intField, stringField]) {
      hash = 0x1fffffff & (hash + field.hashCode);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

class SomeMessage$Builder {
  int intField;
  String stringField;

  SomeMessage$Builder._();
}
