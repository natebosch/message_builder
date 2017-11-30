class SomeListMessage {
  SomeListMessage._(this.intList, this.stringList);

  factory SomeListMessage(void Function(SomeListMessage$Builder) init) {
    final b = new SomeListMessage$Builder._();
    init(b);
    return new SomeListMessage._(b.intList, b.stringList);
  }

  factory SomeListMessage.fromJson(Map params) => new SomeListMessage._(
      params.containsKey('intList') ? params['intList'] : null,
      params.containsKey('stringList') ? params['stringList'] : null);

  final List<int> intList;

  final List<String> stringList;

  Map toJson() => {'intList': intList, 'stringList': stringList};
  @override
  int get hashCode {
    var hash = 0;
    hash = 0x1fffffff & (hash + intList.hashCode);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    hash ^= hash >> 6;
    hash = 0x1fffffff & (hash + stringList.hashCode);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    hash ^= hash >> 6;
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }

  @override
  bool operator ==(Object other) {
    if (other is! SomeListMessage) return false;
    var o = other as SomeListMessage;
    if (!_deepEquals(intList, o.intList)) return false;
    if (!_deepEquals(stringList, o.stringList)) return false;
    return true;
  }
}

class SomeListMessage$Builder {
  SomeListMessage$Builder._();

  List<int> intList;

  List<String> stringList;
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
  if (left is Map && right is Map) {
    var leftLength = left.length;
    var rightLength = right.length;
    if (leftLength != rightLength) return false;
    for (final key in left.keys) {
      if (!_deepEquals(left[key], right[key])) return false;
    }
    return true;
  }
  return left == right;
}
