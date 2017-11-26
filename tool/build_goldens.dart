import 'package:build_runner/build_runner.dart';
import 'package:message_builder/message_builder.dart';

main() async {
  var actions = [
    new BuildAction(const MessageBuilder(), 'message_builder',
        inputs: ['test/goldens/**'])
  ];
  await build(actions);
}
