import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// ====================================================================
// GAME CONSTANTS AND ENUMS
// ====================================================================

const int GRID_SIZE = 20;
const int INITIAL_SPEED_MS = 300; 

enum Direction { up, down, left, right }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Snake',
      theme: ThemeData(
        // Appealing dark background
        scaffoldBackgroundColor: const Color(0xFF1E1E1E), 
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const SnakeGame(),
    );
  }
}

// ====================================================================
// SNAKE GAME WIDGET
// ====================================================================

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  // Game State Variables
  List<int> snakePosition = []; // Stores grid indices
  int foodPosition = 0;
  Direction currentDirection = Direction.down;
  Timer? gameTimer;
  bool isPlaying = false;
  String gameStatusMessage = "Press START to Play!";

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }
  
  void _initializeGame() {
    snakePosition = [45, 65, 85]; // Initial snake body (starts with 3 segments)
    generateFood();
  }

  // --- GAME LOGIC METHODS ---

  void startGame() {
    // Cancel any existing timer
    gameTimer?.cancel();
    
    setState(() {
      _initializeGame();
      currentDirection = Direction.down;
      isPlaying = true;
      gameStatusMessage = "Game Started!";
    });

    // Start the game loop
    gameTimer = Timer.periodic(
      const Duration(milliseconds: INITIAL_SPEED_MS),
      (Timer timer) {
        if (mounted) {
          moveSnake();
          if (checkGameOver()) {
            timer.cancel();
            setState(() {
              isPlaying = false;
              gameStatusMessage = "GAME OVER! Score: ${snakePosition.length - 3}";
            });
          }
        }
      },
    );
  }
  
  void generateFood() {
    // Generate food in a random cell that is NOT part of the snake
    final maxIndex = GRID_SIZE * GRID_SIZE;
    foodPosition = 0; // Reset
    
    // Simple loop to find a free spot
    while (foodPosition == 0 || snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(maxIndex);
    }
  }

  void moveSnake() {
    setState(() {
      int newHead = snakePosition.last;

      // Determine the next head position based on direction (with wrap-around)
      switch (currentDirection) {
        case Direction.down:
          newHead += GRID_SIZE;
          if (newHead >= GRID_SIZE * GRID_SIZE) newHead -= (GRID_SIZE * GRID_SIZE);
          break;
        case Direction.up:
          newHead -= GRID_SIZE;
          if (newHead < 0) newHead += (GRID_SIZE * GRID_SIZE);
          break;
        case Direction.left:
          // Check for wrap-around boundary (right to left)
          if (newHead % GRID_SIZE == 0) {
            newHead += (GRID_SIZE - 1);
          } else {
            newHead -= 1;
          }
          break;
        case Direction.right:
          // Check for wrap-around boundary (left to right)
          if ((newHead + 1) % GRID_SIZE == 0) {
            newHead -= (GRID_SIZE - 1);
          } else {
            newHead += 1;
          }
          break;
      }

      // Add the new head position
      snakePosition.add(newHead);

      // Check for eating food
      if (newHead == foodPosition) {
        generateFood(); // Grow the snake (by NOT removing the tail)
      } else {
        snakePosition.removeAt(0); // Move the snake (by removing the tail)
      }
    });
  }

  bool checkGameOver() {
    // Check for self-collision: head collides with any part of its body
    final head = snakePosition.last;
    // Check if the head is contained in the body (excluding the head itself)
    return snakePosition.sublist(0, snakePosition.length - 1).contains(head);
  }
  
  // Helper function to change direction, preventing immediate reversal
  void changeDir(Direction newDir) {
    if (!isPlaying) return;
    
    // Logic to prevent 180-degree turn
    if (newDir == Direction.up && currentDirection != Direction.down) {
      currentDirection = newDir;
    } else if (newDir == Direction.down && currentDirection != Direction.up) {
      currentDirection = newDir;
    } else if (newDir == Direction.left && currentDirection != Direction.right) {
      currentDirection = newDir;
    } else if (newDir == Direction.right && currentDirection != Direction.left) {
      currentDirection = newDir;
    }
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  // --- UI WIDGET METHODS ---

  Widget _buildGameGrid() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C), // Slightly lighter gray for the board
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFF4A4A4A), width: 3),
        ),
        padding: const EdgeInsets.all(4.0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: GRID_SIZE * GRID_SIZE,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: GRID_SIZE,
          ),
          itemBuilder: (BuildContext context, int index) {
            // Cell Coloring Logic
            Color color = Colors.transparent;
            if (snakePosition.contains(index)) {
              // Appealing snake color (Emerald Green)
              color = (index == snakePosition.last) 
                  ? const Color(0xFF4CAF50) // Head: Lighter green
                  : const Color(0xFF388E3C); // Body: Darker green
            } else if (index == foodPosition) {
              // Appealing food color (Ruby Red)
              color = const Color(0xFFE53935);
            }
            
            return Container(
              margin: const EdgeInsets.all(1), // Small margin for grid effect
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildDirectionPad() {
    // Use the same Teal color for controls
    const controlColor = Color(0xFF00BFA5); 
    
    // Directional button widget
    Widget buildButton(IconData icon, Direction dir) {
      return IconButton(
        icon: Icon(icon, size: 30),
        color: controlColor,
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFF333333), // Darker button background
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: isPlaying ? () => changeDir(dir) : null,
      );
    }

    return Column(
      children: [
        // UP Button
        buildButton(Icons.keyboard_arrow_up_rounded, Direction.up),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LEFT Button
            buildButton(Icons.keyboard_arrow_left_rounded, Direction.left),
            const SizedBox(width: 80), // Spacer for the center
            // RIGHT Button
            buildButton(Icons.keyboard_arrow_right_rounded, Direction.right),
          ],
        ),
        // DOWN Button
        buildButton(Icons.keyboard_arrow_down_rounded, Direction.down),
      ],
    );
  }


  // --- BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              // Score & Status Display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score: ${snakePosition.length - 3}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00BFA5), // Teal accent color
                    ),
                  ),
                  Text(
                    gameStatusMessage,
                    style: TextStyle(
                      fontSize: 18,
                      color: isPlaying ? Colors.white70 : Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Game Grid
              _buildGameGrid(),
              
              const SizedBox(height: 20),

              // Start/Control Button
              ElevatedButton(
                onPressed: isPlaying ? null : startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA5),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isPlaying ? 'Playing...' : 'S T A R T',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // D-PAD CONTROLS
              _buildDirectionPad(), 
            ],
          ),
        ),
      ),
    );
  }
}
