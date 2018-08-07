## 0.1.3+4

- Use the 2.0 stable SDK.

## 0.1.3+3

- Cast to `Iterable` before calling `map` when parsing from json to get a
  correct reified list type.
- Switch to `Map.map` instead of `new Map.fromIterable`.
- Cast primitive typed `List` and `Map` instances to a corrected reified type.

## 0.1.3+2

- Allow `package:build_config` version `0.3.x`.

## 0.1.3+1

- Allow `package:build` version `0.12.x`.

## 0.1.3

- Upgrade to `code_builder` version 3.0
- Add default for `generate_for` to avoid applying to `pubspec.yaml` by default.

## 0.1.2

- Handle keys explicitly set to `null` as if they were missing.

## 0.1.1

- Add a `build.yaml` so this builder can be used with `build_runner` v0.7.0

## 0.1.0

- Initial version. Extracted from
  [dart_language_server](https://github.com/natebosch/dart_language_server)
- Refactor to use `code_builder`.
- Add support for Map type fields.
