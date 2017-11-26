class InnerMessage {
  final String anotherField;

  InnerMessage._(this.anotherField);
  factory InnerMessage(void init(InnerMessage$Builder b)) {
    var b = new InnerMessage$Builder._();
    init(b);
    return new InnerMessage._(b.anotherField);
  }

  factory InnerMessage.fromJson(Map params) => new InnerMessage._(
      params.containsKey("anotherField") ? params["anotherField"] : null);

  Map toJson() => {"anotherField": anotherField};

  @override
  bool operator ==(Object other) {
    if (other is! InnerMessage) return false;
    var o = other as InnerMessage;
    if (anotherField != o.anotherField) return false;
    return true;
  }

  @override
  int get hashCode {
    int hash = 0;
    for (var field in [anotherField]) {
      hash = 0x1fffffff & (hash + field.hashCode);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

class InnerMessage$Builder {
  String anotherField;

  InnerMessage$Builder._();
}

class OuterMessage {
  final InnerMessage innerField;
  final String stringField;

  OuterMessage._(this.innerField, this.stringField);
  factory OuterMessage(void init(OuterMessage$Builder b)) {
    var b = new OuterMessage$Builder._();
    init(b);
    return new OuterMessage._(b.innerField, b.stringField);
  }

  factory OuterMessage.fromJson(Map params) => new OuterMessage._(
      params.containsKey("innerField")
          ? new InnerMessage.fromJson(params["innerField"])
          : null,
      params.containsKey("stringField") ? params["stringField"] : null);

  Map toJson() =>
      {"innerField": innerField?.toJson(), "stringField": stringField};

  @override
  bool operator ==(Object other) {
    if (other is! OuterMessage) return false;
    var o = other as OuterMessage;
    if (innerField != o.innerField) return false;
    if (stringField != o.stringField) return false;
    return true;
  }

  @override
  int get hashCode {
    int hash = 0;
    for (var field in [innerField, stringField]) {
      hash = 0x1fffffff & (hash + field.hashCode);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

class OuterMessage$Builder {
  InnerMessage innerField;
  String stringField;

  OuterMessage$Builder._();
}
