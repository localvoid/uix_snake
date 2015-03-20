library app.store;

import 'dart:collection';
import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:async';
import 'observable.dart';

final math.Random _rand = new math.Random();

enum GameMode {
  init,
  run,
  gameOver
}

class Snake {
  Queue<math.Point> body = new Queue<math.Point>();
  int grow = 4;

  math.Point get head => body.last;

  Snake([math.Point startPosition = const math.Point(0, 0)]) {
    body.addLast(startPosition);
  }

  math.Point move(math.Point p) {
    body.addLast(p);
    if (grow > 0) {
      grow--;
      return null;
    } else {
      return body.removeFirst();
    }
  }
}

class Grid {
  static const int body = 1;
  static const int head = 1 << 1;
  static const int food = 1 << 2;

  final int rows;
  final int cols;
  final List<int> cells;

  Grid({int rows: 20, int cols: 20})
      : rows = rows,
        cols = cols,
        cells = new List<int>.filled(rows * cols, 0);

  int cellIndex(math.Point p) => cols * p.y + p.x;

  void setAt(math.Point p, int v) {
    cells[cellIndex(p)] |= v;
  }

  void removeAt(math.Point p, int v) {
    cells[cellIndex(p)] &= ~v;
  }

  void createFood() {
    var i = 0;
    do {
      i = _rand.nextInt(cells.length);
    } while(cells[i] != 0);
    cells[i] |= food;
  }

  bool isBodyAt(math.Point p) => (cells[cellIndex(p)] & body) != 0;
  bool isFoodAt(math.Point p) => (cells[cellIndex(p)] & food) != 0;
}

class AppState extends ObservableNode {
  GameMode mode = GameMode.init;
  bool isPaused = false;
  int startTime = 0;
  int currentTime = 0;

  Grid grid;
  Snake snake;
  math.Point direction = const math.Point(1, 0);
  math.Point newDirection;

  AppState() {
    grid = new Grid();
    new Stream.periodic(const Duration(milliseconds: 100)).listen(_tick);
  }

  void reset() {
    grid = new Grid();
    snake = new Snake();
    for (final p in snake.body) {
      grid.setAt(p, Grid.body);
    }
    grid.setAt(snake.head, Grid.head);
    grid.createFood();
  }

  void start() {
    mode = GameMode.run;
    isPaused = false;
    reset();
    notify();
  }

  void togglePause(bool v) {
    if (isPaused != v) {
      isPaused = v;
      notify();
    }
  }

  void handleKeyDown(html.KeyboardEvent e) {
    switch (e.keyCode) {
      case html.KeyCode.UP:
        e.preventDefault();
        newDirection = const math.Point(0, -1);
        break;
      case html.KeyCode.DOWN:
        e.preventDefault();
        newDirection = const math.Point(0, 1);
        break;
      case html.KeyCode.LEFT:
        e.preventDefault();
        newDirection = const math.Point(-1, 0);
        break;
      case html.KeyCode.RIGHT:
        e.preventDefault();
        newDirection = const math.Point(1, 0);
        break;
    }
  }

  void _tick(int t) {
    if (mode != GameMode.run || isPaused) {
      return;
    }

    if (newDirection != null) {
      if (direction + newDirection != const math.Point(0, 0)) {
        direction = newDirection;
      }
      newDirection = null;
    }

    math.Point nextPosition = snake.head + direction;
    nextPosition = new math.Point(nextPosition.x % grid.cols, nextPosition.y % grid.rows);

    grid.removeAt(snake.head, Grid.head);
    final tail = snake.move(nextPosition);
    if (tail != null) {
      grid.removeAt(tail, Grid.body);
    }
    grid.setAt(nextPosition, Grid.head);

    if (grid.isBodyAt(nextPosition)) {
      mode = GameMode.gameOver;
    } else if (grid.isFoodAt(nextPosition)) {
      snake.grow = 3;
      grid.removeAt(nextPosition, Grid.food);
      grid.createFood();
    }

    grid.setAt(nextPosition, Grid.body);

    notify();
  }
}
