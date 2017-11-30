class InnerMessageInList {
  InnerMessageInList._(this.anotherField);

  factory InnerMessageInList(void Function(InnerMessageInList$Builder) init) {
    final b = new InnerMessageInList$Builder._();
    init(b);
    return new InnerMessageInList._(b.anotherField);
  }

  factory InnerMessageInList.fromJson(Map params) => new InnerMessageInList._(
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
    if (other is! InnerMessageInList) return false;
    var o = other as InnerMessageInList;
    if (anotherField != o.anotherField) return false;
    return true;
  }
}

class InnerMessageInList$Builder {
  InnerMessageInList$Builder._();

  String anotherField;
}

class OuterMessageWithList {
  OuterMessageWithList._(this.innerField);

  factory OuterMessageWithList(
      void Function(OuterMessageWithList$Builder) init) {
    final b = new OuterMessageWithList$Builder._();
    init(b);
    return new OuterMessageWithList._(b.innerField);
  }

  factory OuterMessageWithList.fromJson(Map params) =>
      new OuterMessageWithList._(params.containsKey('innerField')
          ? params['innerField']
              .map((v) => new InnerMessageInList.fromJson(v))
              .toList()
          : null);

  final List<InnerMessageInList> innerField;

  Map toJson() => {'innerField': innerField?.map((v) => v?.toJson())?.toList()};
  @override
  int get hashCode {
    var hash = 0;
    hash = 0x1fffffff & (hash + innerField.hashCode);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    hash ^= hash >> 6;
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }

  @override
  bool operator ==(Object other) {
    if (other is! OuterMessageWithList) return false;
    var o = other as OuterMessageWithList;
    if (!_deepEquals(innerField, o.innerField)) return false;
    return true;
  }
}

class OuterMessageWithList$Builder {
  OuterMessageWithList$Builder._();

  List<InnerMessageInList> innerField;
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
