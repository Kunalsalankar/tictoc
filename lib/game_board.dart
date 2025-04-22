import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_logic.dart';

class GameBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        return GridView.builder(
          padding: EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => gameState.makeMove(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: gameState.winningLine?.contains(index) == true
                      ? Colors.green.shade200
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: gameState.board[index] != null
                      ? Text(
                    gameState.board[index].toString().split('.').last,
                    style: TextStyle(
                      fontSize: 64.0,
                      fontWeight: FontWeight.bold,
                      color: gameState.board[index] == Player.X
                          ? Colors.blue
                          : Colors.red,
                    ),
                  )
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }
}