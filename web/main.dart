import 'dart:html' as html;
import 'package:uix/uix.dart';
import 'package:uix_snake/src/game.dart';
import 'package:uix_snake/src/view.dart';

void main() {
  initUix();

  final state = new AppState();

  scheduler.nextFrame.write().then((_) {
    injectComponent(createAppView(state), html.document.body);
  });
}
