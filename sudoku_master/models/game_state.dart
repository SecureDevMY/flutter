import 'sudoku_puzzle.dart';

class GameState {
  List<List<int>> currentBoard;
  List<List<int>> solutionBoard;
  List<List<bool>> fixedCells;
  List<List<Set<int>>> notes;
  List<GameMove> moveHistory;
  String difficulty;
  int hintsUsed;
  DateTime startTime;

  GameState({
    required this.currentBoard,
    required this.solutionBoard,
    required this.fixedCells,
    required this.notes,
    required this.moveHistory,
    required this.difficulty,
    required this.hintsUsed,
    required this.startTime,
  });

  factory GameState.fromPuzzle(SudokuPuzzle puzzle) {
    final notes = List.generate(9, (_) => List.generate(9, (_) => <int>{}));
    return GameState(
      currentBoard: puzzle.initial.map((row) => List<int>.from(row)).toList(),
      solutionBoard: puzzle.solution.map((row) => List<int>.from(row)).toList(),
      fixedCells: List.generate(
        9,
        (i) => List.generate(9, (j) => puzzle.initial[i][j] != 0),
      ),
      notes: notes,
      moveHistory: [],
      difficulty: puzzle.difficulty,
      hintsUsed: 0,
      startTime: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentBoard': currentBoard,
      'solutionBoard': solutionBoard,
      'fixedCells': fixedCells.map((row) => row.map((e) => e ? 1 : 0).toList()).toList(),
      'notes': notes.map((row) => row.map((set) => set.toList()).toList()).toList(),
      'moveHistory': moveHistory.map((m) => m.toJson()).toList(),
      'difficulty': difficulty,
      'hintsUsed': hintsUsed,
      'startTime': startTime.toIso8601String(),
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      currentBoard: List<List<int>>.from(json['currentBoard'].map((row) => List<int>.from(row))),
      solutionBoard: List<List<int>>.from(json['solutionBoard'].map((row) => List<int>.from(row))),
      fixedCells: List<List<bool>>.from(
        json['fixedCells'].map((row) => List<bool>.from(row.map((e) => e == 1))),
      ),
      notes: List<List<Set<int>>>.from(
        json['notes'].map((row) => List<Set<int>>.from(row.map((list) => Set<int>.from(list)))),
      ),
      moveHistory: List<GameMove>.from(json['moveHistory'].map((m) => GameMove.fromJson(m))),
      difficulty: json['difficulty'],
      hintsUsed: json['hintsUsed'],
      startTime: DateTime.parse(json['startTime']),
    );
  }
}

class GameMove {
  final int row;
  final int col;
  final int previousValue;
  final int newValue;
  final Set<int> previousNotes;

  GameMove({
    required this.row,
    required this.col,
    required this.previousValue,
    required this.newValue,
    required this.previousNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'col': col,
      'previousValue': previousValue,
      'newValue': newValue,
      'previousNotes': previousNotes.toList(),
    };
  }

  factory GameMove.fromJson(Map<String, dynamic> json) {
    return GameMove(
      row: json['row'],
      col: json['col'],
      previousValue: json['previousValue'],
      newValue: json['newValue'],
      previousNotes: Set<int>.from(json['previousNotes']),
    );
  }
}
