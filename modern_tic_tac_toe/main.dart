import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Define custom color once
    const Color primaryNavy = Color(0xFF0F3460); //Darker Navy
    const Color accentPink = Color(0xFFE94560); //vibrant Pink/Red accent
    const Color backgroundNavy = Color(0xFF1A1A2E); //Dark Navy/Space color

    return MaterialApp(
      title: 'Modern Tic Tac Toe',
      debugShowCheckedModeBanner: false,

      //Use ThemeData.dark() as base
      theme: ThemeData.dark().copyWith(
        //Set the overalldark aesthetic
        scaffoldBackgroundColor: backgroundNavy,
        primaryColor: primaryNavy,

        //override color scheme with accents
        colorScheme: const ColorScheme.dark().copyWith(
          //primary is the main accent color (buttons, app bar, etc)
          primary: accentPink,

          //secondary is another acccent, good for things like reset button
          secondary: accentPink,
          surface: backgroundNavy,
        ),

        //Apply google fonts globally
        textTheme: GoogleFonts.pressStart2pTextTheme(
          ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
      ),
      home: const TicTacToeGame(),
    );
  }
}

//The main game widget
class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  //Game State Variables
  List<String> displayElement = List.filled(9, ''); //initialized with 9 empty strings
  bool isTurnOfX = true; // 'X' is Player 1 (pink)
  int filledBoxes = 0;
  int xScore = 0;
  int oScore = 0;

  //Modern Player Colors
  static const Color playerXColor = Color(0xFFE94560); //vibrant Pink/Red
  static const Color playerOColor = Color(0xFF16E0BD); //vibrant Teal/Green

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GRID BATTLE',
          style: GoogleFonts.pressStart2p(fontSize: 16),
        ),
        backgroundColor: Colors.transparent, //Transparent Appbar
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          //Scoreboard & Player turn Indicator
          _buildScoreboard(context),

          //Game board UI
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ), 
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _tapped(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor, //Dark box color
                        borderRadius: BorderRadius.circular(15),
                        //Add a subtle shadow for a "lifted" effect
                        boxShadow: [
                          BoxShadow(
                            color: const Color (0x80000000),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        //Apply a simple FadeIn animation for modern touch
                        child: FadeIn(
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            displayElement[index],
                            style: GoogleFonts.pressStart2p(
                              color: displayElement[index] == 'X'
                              ? playerXColor
                              : playerOColor,
                              fontSize: 48,
                            ),
                          )
                        ),
                      ),
                    ),
                  );
                }
              ),
            )
          ),

          //reset buttons UI (Restart round and reset score)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //restart round button (Clears board, keep score)
                    ElevatedButton.icon(
                      onPressed: _clearBoard, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                      ),
                      icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                      label: Text(
                        'RESTART ROUND',
                        style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.white),
                      ),
                    ),

                    //Reset score button
                    ElevatedButton.icon(
                      onPressed: _resetScores, 
                      label: Text(
                        'RESET SCORES',
                        style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor, //Use a different color for distinction
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      icon: const Icon(Icons.leaderboard_outlined, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            )
          )
        ],
      ),
    );
  }

  //---Widget Builders---
  Widget _buildScoreboard(BuildContext context) {
    String currentTurn = isTurnOfX ? 'X' : 'O';
    Color turnColor =isTurnOfX ? playerXColor : playerOColor;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildScoreColumn('PLAYER X (Pink)', xScore, playerXColor),
              _buildScoreColumn('PLAYER O (Teal)', oScore, playerOColor),
            ],
          ),
          const SizedBox(height: 15),
          // Dynamic Turn Indicator
          BounceInDown(
            animate: true,
            key: ValueKey<bool>(isTurnOfX), // Key changes force re-render/animation
            child: Text(
              'TURN: $currentTurn',
              style: GoogleFonts.pressStart2p(fontSize: 18, color: turnColor),
            ))
        ],
      ));
  }

  Widget _buildScoreColumn(String title, int score, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: GoogleFonts.pressStart2p(fontSize: 12, color: color),
        ),
        const SizedBox(height: 5),
        Text(
          score.toString(),
          style: GoogleFonts.pressStart2p(fontSize: 24, color: color),
        ),
      ],
    );
  }

  //game logic (Remains similar, but dialogs are styled)
  void _tapped(int index) {
    if (displayElement[index] == '') {
      setState(() {
        displayElement[index] = isTurnOfX ? 'X' : 'O';
        filledBoxes++;
        _checkWinner(); //check for winner first
        isTurnOfX = !isTurnOfX; //Switch turn only if no winner/draw yet
      });
    }
  }

  // the check winner logic remains the same
  void _checkWinner() {
    //Check rows
    for (int i=0; i <= 6; i +=3) {
      if (displayElement[i] == displayElement[i + 1] &&
          displayElement[i] == displayElement[i + 2] &&
          displayElement[i] != '') {
        _showWinDialog(displayElement[i]);
        return;
      }
    }

    //check columns
    for (int i = 0; i <= 2; i++) {
      if (displayElement[i] == displayElement[i + 3] &&
          displayElement[i] == displayElement[i + 6] &&
          displayElement[i] != '') {
        _showWinDialog(displayElement[i]);
        return;
      }
    }

    //check diagonals
    if (displayElement[0] == displayElement[4] &&
        displayElement[0] == displayElement[8] &&
        displayElement[0] != '') {
      _showWinDialog(displayElement[0]);
      return;
    }

    if (displayElement[2] == displayElement[4] &&
        displayElement[2] == displayElement[6] &&
        displayElement[2] != '') {
      _showWinDialog(displayElement[2]);
      return;
    }

    //check draws
    if (filledBoxes == 9) {
      _showDrawDialog();
    }
  }

  //Styled Dialog functions
  void _showWinDialog(String winner) {
    setState(() {
      if (winner == 'X') {
        xScore++;
      } else {
        oScore++;
      }
    });

    Color winnerColor = winner == 'X' ? playerXColor : playerOColor;

    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (BuildContext context) {
        return ZoomIn(
          child: AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: winnerColor, width: 3),
            ),
            title: Text(
              'WINNER: $winner!',
              style: GoogleFonts.pressStart2p(fontSize: 14, color: winnerColor),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Congratulations! Player $winner takes the round',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: winnerColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  _clearBoard();
                  Navigator.of(context).pop();
                }, 
                child: Text(
                  'NEXT ROUND',
                  style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.white),
                )
              )
            ],
          )
        );
      }
    );
  }

  void _showDrawDialog() {
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (BuildContext context) {
        return ZoomIn(
          child: AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            title: Text(
              'IT\'S A DRAW',
              style: GoogleFonts.pressStart2p(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'The grid is full, no winner this time.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  _clearBoard;
                  Navigator.of(context).pop();
                }, 
                child: Text(
                  'PLAY AGAIN',
                  style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.white),
                )
              )
            ],
          )
        );
      }
    );
  }

  //Functions to clear the board for a new game
  void _clearBoard() {
    setState(() {
      displayElement = List.filled(9, '');
      filledBoxes = 0;
      isTurnOfX = true; //X starts the new game
    });
  }

  //reset scores and clear the board
  void _resetScores() {
    setState(() {
      xScore = 0;
      oScore = 0;
      _clearBoard(); //Also clear the board immediately
    });
  }
}
