class InnerMessage {
  InnerMessage._(this.anotherField);

  factory InnerMessage(void Function(InnerMessage$Builder) init) {
    final b = new InnerMessage$Builder._();
    init(b);
    return new InnerMessage._(b.anotherField);
  }

  factory InnerMessage.fromJson(Map params) => new InnerMessage._(
      params.containsKey('anotherField') ? params['anotherField'] : null);

  final String anotherField;

  Map toJson() => {'anotherField': anotherField};
  @override
  int get hashCode {
    var hash = 0;
    hash = 0x1fffffff & (hash + anotherField.hashCode);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    hash ^= hash >> 6;
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
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
      params.containsKey('innerField')
          ? new InnerMessage.fromJson(params['innerField'])
          : null,
      params.containsKey('stringField') ? params['stringField'] : null);

  final InnerMessage innerField;

  final String stringField;

  Map toJson() =>
      {'innerField': innerField?.toJson(), 'stringField': stringField};
  @override
  int get hashCode {
    var hash = 0;
    hash = 0x1fffffff & (hash + innerField.hashCode);
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
