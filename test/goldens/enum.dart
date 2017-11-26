class MessageUsingEnum {
  MessageUsingEnum._(this.enumField);

  factory MessageUsingEnum(void Function(MessageUsingEnum$Builder) init) {
    final b = new MessageUsingEnum$Builder._();
    init(b);
    return new MessageUsingEnum._(b.enumField);
  }

  factory MessageUsingEnum.fromJson(Map params) =>
      new MessageUsingEnum._(params.containsKey('enumField')
          ? new SomeEnum.fromJson(params['enumField'])
          : null);

  final SomeEnum enumField;

  Map toJson() => {'enumField': enumField?.toJson()};
  @override
  int get hashCode {
    var hash = 0;
    hash = 0x1fffffff & (hash + enumField.hashCode);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    hash ^= hash >> 6;
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }

  @override
  bool operator ==(Object other) {
    if (other is! MessageUsingEnum) return false;
    var o = other as MessageUsingEnum;
    if (enumField != o.enumField) return false;
    return true;
  }
}

class MessageUsingEnum$Builder {
  MessageUsingEnum$Builder._();

  SomeEnum enumField;
}

class SomeEnum {
  factory SomeEnum.fromJson(int value) {
    const values = const {2: SomeEnum.anotherValue, 1: SomeEnum.someValue};
    return values[value];
  }

  const SomeEnum._(this._value);

  static const anotherValue = const SomeEnum._(2);

  static const someValue = const SomeEnum._(1);

  final int _value;

  int toJson() => _value;
}
