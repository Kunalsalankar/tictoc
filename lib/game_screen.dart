import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_logic.dart';
import 'game_board.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<GameState>(
            builder: (context, gameState, _) {
              String statusText = "";

              if (gameState.gameOver) {
                if (gameState.isDraw) {
                  statusText = "It's a Draw!";
                } else {
                  statusText = "Player ${gameState.winner.toString().split('.').last} Wins!";
                }
              } else {
                statusText = "Player ${gameState.currentPlayer.toString().split('.').last}'s Turn";
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    statusText,
                    key: ValueKey(statusText),
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: !gameState.gameOver
                          ? (gameState.currentPlayer == Player.X ? Colors.blue : Colors.red)
                          : (gameState.isDraw ? Colors.grey : (gameState.winner == Player.X ? Colors.blue : Colors.red)),
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Stack(
              children: [
                GameBoard(),
                Consumer<GameState>(
                  builder: (context, gameState, _) {
                    if (gameState.gameOver && !gameState.isDraw) {
                      return Center(
                        child: WinAnimation(),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          // Moved the restart button here, before the bottom padding
          Consumer<GameState>(
            builder: (context, gameState, _) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 100.0), // Added space between button and bottom
                child: ElevatedButton(
                  onPressed: gameState.resetGame,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  ),
                  child: Text(
                    'Restart Game',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class WinAnimation extends StatefulWidget {
  @override
  _WinAnimationState createState() => _WinAnimationState();
}

class _WinAnimationState extends State<WinAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                "Congratulations!\nYou Win!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}