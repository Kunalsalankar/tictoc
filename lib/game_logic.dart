import 'package:flutter/foundation.dart';

enum Player { X, O }

class GameState with ChangeNotifier {
  List<Player?> _board = List.filled(9, null);
  Player _currentPlayer = Player.X;
  bool _gameOver = false;
  List<int>? _winningLine;
  bool _isDraw = false;
  Player? _winner;

  List<Player?> get board => _board;
  Player get currentPlayer => _currentPlayer;
  bool get gameOver => _gameOver;
  List<int>? get winningLine => _winningLine;
  bool get isDraw => _isDraw;
  Player? get winner => _winner;

  void makeMove(int position) {
    if (_gameOver || _board[position] != null) {
      return;
    }

    _board[position] = _currentPlayer;

    _checkWinOrDraw();

    if (!_gameOver) {
      _currentPlayer = _currentPlayer == Player.X ? Player.O : Player.X;
    } else if (_winningLine != null) {
      _winner = _currentPlayer;
    }

    notifyListeners();
  }

  void resetGame() {
    _board = List.filled(9, null);
    _currentPlayer = Player.X;
    _gameOver = false;
    _winningLine = null;
    _isDraw = false;
    _winner = null;
    notifyListeners();
  }

  void _checkWinOrDraw() {
    final winningLines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (final line in winningLines) {
      if (_board[line[0]] != null &&
          _board[line[0]] == _board[line[1]] &&
          _board[line[1]] == _board[line[2]]) {
        _gameOver = true;
        _winningLine = line;
        return;
      }
    }

    if (!_board.contains(null)) {
      _gameOver = true;
      _isDraw = true;
    }
  }
}