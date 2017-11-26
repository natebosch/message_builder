abstract class ParentMessage {
  factory ParentMessage.fromJson(Map params) {
    var selectBy = params["selectField"];
    if (selectBy == "firstValue") return new FirstChildMessage.fromJson(params);
    if (selectBy == "secondValue")
      return new SecondChildMessage.fromJson(params);
    if (selectBy == "thirdValue") return new ThirdChildMessage.fromJson(params);

    throw new ArgumentError('Could not match ParentMessage for $selectBy');
  }
  Map toJson();
}

class FirstChildMessage implements ParentMessage {
  final selectField = "firstValue";
  final int firstField;

  FirstChildMessage._(this.firstField);
  factory FirstChildMessage(void init(FirstChildMessage$Builder b)) {
    var b = new FirstChildMessage$Builder._();
    init(b);
    return new FirstChildMessage._(b.firstField);
  }

  factory FirstChildMessage.fromJson(Map params) => new FirstChildMessage._(
      params.containsKey("firstField") ? params["firstField"] : null);

  Map toJson() => {"selectField": "firstValue", "firstField": firstField};

  @override
  bool operator ==(Object other) {
    if (other is! FirstChildMessage) return false;
    var o = other as FirstChildMessage;
    if (firstField != o.firstField) return false;
    return true;
  }

  @override
  int get hashCode {
    int hash = 0;
    for (var field in [firstField]) {
      hash = 0x1fffffff & (hash + field.hashCode);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

class FirstChildMessage$Builder {
  int firstField;

  FirstChildMessage$Builder._();
}

class SecondChildMessage implements ParentMessage {
  final selectField = "secondValue";
  final String secondField;

  SecondChildMessage._(this.secondField);
  factory SecondChildMessage(void init(SecondChildMessage$Builder b)) {
    var b = new SecondChildMessage$Builder._();
    init(b);
    return new SecondChildMessage._(b.secondField);
  }

  factory SecondChildMessage.fromJson(Map params) => new SecondChildMessage._(
      params.containsKey("secondField") ? params["secondField"] : null);

  Map toJson() => {"selectField": "secondValue", "secondField": secondField};

  @override
  bool operator ==(Object other) {
    if (other is! SecondChildMessage) return false;
    var o = other as SecondChildMessage;
    if (secondField != o.secondField) return false;
    return true;
  }

  @override
  int get hashCode {
    int hash = 0;
    for (var field in [secondField]) {
      hash = 0x1fffffff & (hash + field.hashCode);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

class SecondChildMessage$Builder {
  String secondField;

  SecondChildMessage$Builder._();
}

class ThirdChildMessage implements ParentMessage {
  final selectField = "thirdValue";

  const ThirdChildMessage();
  const ThirdChildMessage.fromJson([_]);

  Map toJson() => {
        "selectField": "thirdValue",
      };

  @override
  bool operator ==(Object other) => other is ThirdChildMessage;

  @override
  int get hashCode {
    int hash = 0;
    for (var field in []) {
      hash = 0x1fffffff & (hash + field.hashCode);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

class ThirdChildMessage$Builder {
  ThirdChildMessage$Builder._();
}
