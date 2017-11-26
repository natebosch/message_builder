class SomeMessage {
  final List<int> intList;
  final List<String> stringList;

  SomeMessage._(this.intList, this.stringList);
  factory SomeMessage(void init(SomeMessage$Builder b)) {
    var b = new SomeMessage$Builder._();
    init(b);
    return new SomeMessage._(b.intList, b.stringList);
  }

  factory SomeMessage.fromJson(Map params) => new SomeMessage._(
      params.containsKey("intList") ? params["intList"] : null,
      params.containsKey("stringList") ? params["stringList"] : null);

  Map toJson() => {"intList": intList, "stringList": stringList};

  @override
  bool operator ==(Object other) {
    if (other is! SomeMessage) return false;
    var o = other as SomeMessage;
    if (!_deepEquals(intList, o.intList)) return false;
    if (!_deepEquals(stringList, o.stringList)) return false;
    return true;
  }

  @override
  int get hashCode {
    int hash = 0;
    for (var field in [intList, stringList]) {
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
  List<int> intList;
  List<String> stringList;

  SomeMessage$Builder._();
}

_deepEquals(dynamic left, dynamic right) {
  if (left is List && right is List) {
    var leftLength = left.length;
    var rightLength = right.length;
    if (leftLength != rightLength) return false;
    for (int i = 0; i < leftLength; i++) {
      if (!_deepEquals(left[i], right[i])) return false;
    }
    return true;
  }
  return left == right;
}
