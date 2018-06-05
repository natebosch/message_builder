class AnotherMessage {
  AnotherMessage._(this.innerMessageMap);

  factory AnotherMessage(void Function(AnotherMessage$Builder) init) {
    final b = new AnotherMessage$Builder._();
    init(b);
    return new AnotherMessage._(b.innerMessageMap);
  }

  factory AnotherMessage.fromJson(Map params) => new AnotherMessage._(
      params.containsKey('innerMessageMap') && params['innerMessageMap'] != null
          ? params['innerMessageMap']
          : null);

  final Map<String, String> innerMessageMap;

  Map toJson() {
    final $$result = {};
    final $innerMessageMap = innerMessageMap;
    if ($innerMessageMap != null) {
      $$result['innerMessageMap'] = $innerMessageMap;
    }
    return $$result;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = _hashCombine(hash, _deepHashCode(innerMessageMap));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) {
    if (other is! AnotherMessage) return false;
    var o = other as AnotherMessage;
    if (!_deepEquals(innerMessageMap, o.innerMessageMap)) return false;
    return true;
  }
}

class AnotherMessage$Builder {
  AnotherMessage$Builder._();

  Map<String, String> innerMessageMap;
}

class SomeMapMessage {
  SomeMapMessage._(this.intMap, this.listMap, this.mapMap, this.messageMap);

  factory SomeMapMessage(void Function(SomeMapMessage$Builder) init) {
    final b = new SomeMapMessage$Builder._();
    init(b);
    return new SomeMapMessage._(b.intMap, b.listMap, b.mapMap, b.messageMap);
  }

  factory SomeMapMessage.fromJson(Map params) => new SomeMapMessage._(
      params.containsKey('intMap') && params['intMap'] != null
          ? params['intMap']
          : null,
      params.containsKey('listMap') && params['listMap'] != null
          ? params['listMap']
          : null,
      params.containsKey('mapMap') && params['mapMap'] != null
          ? params['mapMap']
          : null,
      params.containsKey('messageMap') && params['messageMap'] != null
          ? new Map.fromIterable(params['messageMap'].keys,
              value: (v) =>
                  new AnotherMessage.fromJson(params['messageMap'][v]))
          : null);

  final Map<String, int> intMap;

  final Map<String, List<int>> listMap;

  final Map<String, Map<String, String>> mapMap;

  final Map<String, AnotherMessage> messageMap;

  Map toJson() {
    final $$result = {};
    final $intMap = intMap;
    if ($intMap != null) {
      $$result['intMap'] = $intMap;
    }
    final $listMap = listMap;
    if ($listMap != null) {
      $$result['listMap'] = $listMap;
    }
    final $mapMap = mapMap;
    if ($mapMap != null) {
      $$result['mapMap'] = $mapMap;
    }
    final $messageMap = messageMap == null
        ? null
        : new Map.fromIterable(messageMap.keys,
            value: (v) => messageMap[v]?.toJson());
    if ($messageMap != null) {
      $$result['messageMap'] = $messageMap;
    }
    return $$result;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = _hashCombine(hash, _deepHashCode(intMap));
    hash = _hashCombine(hash, _deepHashCode(listMap));
    hash = _hashCombine(hash, _deepHashCode(mapMap));
    hash = _hashCombine(hash, _deepHashCode(messageMap));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) {
    if (other is! SomeMapMessage) return false;
    var o = other as SomeMapMessage;
    if (!_deepEquals(intMap, o.intMap)) return false;
    if (!_deepEquals(listMap, o.listMap)) return false;
    if (!_deepEquals(mapMap, o.mapMap)) return false;
    if (!_deepEquals(messageMap, o.messageMap)) return false;
    return true;
  }
}

class SomeMapMessage$Builder {
  SomeMapMessage$Builder._();

  Map<String, int> intMap;

  Map<String, List<int>> listMap;

  Map<String, Map<String, String>> mapMap;

  Map<String, AnotherMessage> messageMap;
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
