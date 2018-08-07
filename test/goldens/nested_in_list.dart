class InnerMessageInList {
  InnerMessageInList._(this.anotherField);

  factory InnerMessageInList(void Function(InnerMessageInList$Builder) init) {
    final b = InnerMessageInList$Builder._();
    init(b);
    return InnerMessageInList._(b.anotherField);
  }

  factory InnerMessageInList.fromJson(Map params) => InnerMessageInList._(
      params.containsKey('anotherField') && params['anotherField'] != null
          ? params['anotherField']
          : null);

  final String anotherField;

  Map toJson() => {'anotherField': anotherField};
  @override
  int get hashCode {
    var hash = 0;
    hash = _hashCombine(hash, _deepHashCode(anotherField));
    return _hashComplete(hash);
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
    final b = OuterMessageWithList$Builder._();
    init(b);
    return OuterMessageWithList._(b.innerField);
  }

  factory OuterMessageWithList.fromJson(Map params) => OuterMessageWithList._(
      params.containsKey('innerField') && params['innerField'] != null
          ? (params['innerField'] as List)
              .map((v) => InnerMessageInList.fromJson(v))
              .toList()
          : null);

  final List<InnerMessageInList> innerField;

  Map toJson() => {'innerField': innerField?.map((v) => v?.toJson())?.toList()};
  @override
  int get hashCode {
    var hash = 0;
    hash = _hashCombine(hash, _deepHashCode(innerField));
    return _hashComplete(hash);
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
