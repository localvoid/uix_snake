library app.view;

import 'dart:html' as html;
import 'package:uix/uix.dart';
import 'game.dart';

const int cellSize = 30;

class AppView extends Component<AppState> {
  VNode _grid;

  void init() {
    element
        ..onKeyDown.listen(data.handleKeyDown)
        ..onFocus.capture(_handleFocus)
        ..onBlur.capture(_handleBlur);

    element.onClick
        ..matches('.StartButton').listen(_handleStart);

    addSubscription(data.onChange.listen(invalidate));
  }

  void _handleStart(html.MouseEvent e) {
    e.preventDefault();
    data.start();
    scheduler.nextFrame.after().then((_) {
      (_grid.ref as html.Element).focus();
    });
  }

  void _handleFocus(html.FocusEvent e) {
    if ((e.target as html.Element).matches('.Grid')) {
      data.togglePause(false);
    }
  }

  void _handleBlur(html.FocusEvent e) {
    if ((e.target as html.Element).matches('.Grid')) {
      data.togglePause(true);
    }
  }

  updateView() {
    _grid = vElement('div',
        type: 'Grid',
        attrs: const {Attr.tabIndex: '0'},
        style: {
          Style.width: '${cellSize * data.grid.cols}px',
          Style.height: '${cellSize * data.grid.rows}px'})(
      data.grid.cells.map((c) => vElement('div', type: 'Cell', classes: cellClasses(c))));

    final children = [_grid];

    if (data.mode == GameMode.init || data.mode == GameMode.gameOver) {
      children.add(vElement('div', type: 'Modal')(vElement('div', type: 'StartButton')('Start')));
    } else if (data.isPaused) {
      children.add(vElement('div', type: 'Modal')('Paused'));
    }

    updateRoot(vRoot(type: 'SnakeGame',
        classes: data.mode == GameMode.gameOver ? const ['gameOver'] : null,
        children: children));
  }

  static List<String> cellClasses(int c) {
    if ((c & Grid.body) != 0) {
      if ((c & Grid.head) != 0) {
        return const ['body', 'head'];
      }
      return const ['body'];
    } else if ((c & Grid.food) != 0) {
      return const ['food'];
    }
    return null;
  }
}
