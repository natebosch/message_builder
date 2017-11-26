class SomeEnum {
  static const anotherValue = const SomeEnum._(2);
  static const someValue = const SomeEnum._(1);
  final int _value;
  const SomeEnum._(this._value);
  factory SomeEnum.fromJson(int value) {
    const values = const {2: SomeEnum.anotherValue, 1: SomeEnum.someValue};
    return values[value];
  }
  int toJson() => _value;
}
