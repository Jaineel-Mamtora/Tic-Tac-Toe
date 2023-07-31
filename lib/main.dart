import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Tic-Tac-Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String symbol;
  var symbolList = List.generate(9, (_) => '');
  var symbolMatrix = <List<String>>[];
  late int currentIdx;

  @override
  void initState() {
    super.initState();
    symbol = Constants.symbolX;
    currentIdx = -1;
    for (var i = 0; i < Constants.size; ++i) {
      symbolMatrix.add(
        List.generate(Constants.size, (_) => ''),
      );
    }
  }

  String getSymbol() {
    String currSymbol = symbol;

    setState(() {
      if (currSymbol == Constants.symbolX) {
        symbol = Constants.symbolO;
      } else {
        symbol = Constants.symbolX;
      }
    });

    return currSymbol;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Tic-Tac-Toe'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            padding: const EdgeInsets.all(16),
            children: List.generate(
              9,
              (index) => Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: InkWell(
                  onTap: symbolList[index].trim().isEmpty
                      ? () {
                          setState(() {
                            currentIdx = index;
                          });

                          symbolList[index] = getSymbol();

                          if (_isGameOver()) {
                            _showSnackBar(context, symbolList[currentIdx]);
                            return;
                          }
                        }
                      : null,
                  child: Center(
                    child: Text(
                      symbolList[index],
                      style: const TextStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  void _showSnackBar(BuildContext context, String winner) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The Winner is $winner!'),
        duration: const Duration(
            seconds: 3), // Duration for which the snackbar will be visible
        action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () {
            // Code to be executed when the user clicks on the Snackbar action button.
            // Typically used to undo an action or dismiss the Snackbar.
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  bool _isGameOver() {
    int row = currentIdx ~/ Constants.size;
    int col = currentIdx % Constants.size;

    log('row = $row');
    log('col = $col');

    symbolMatrix[row][col] = symbolList[currentIdx];

    log('symbolMatrix = $symbolMatrix');
    log('currentSymbol = ${symbolList[currentIdx]}');

    if (_rowWin(row, col, symbolList[currentIdx])) {
      log('_rowWin');
      return true;
    }
    if (_colWin(row, col, symbolList[currentIdx])) {
      log('_colWin');
      return true;
    }
    if (_primaryDiagonalWin(row, col, symbolList[currentIdx])) {
      log('_primaryDiagonalWin');
      return true;
    }
    if (_secondaryDiagonalWin(row, col, symbolList[currentIdx])) {
      log('_secondaryDiagonalWin');
      return true;
    }

    return false;
  }

  bool _rowWin(int row, int col, String symbol) {
    int currRow = row;
    while (currRow >= 0) {
      if (symbolMatrix[currRow][col] != symbol) return false;
      currRow--;
    }

    currRow = row;
    while (currRow < Constants.size) {
      if (symbolMatrix[currRow][col] != symbol) return false;
      currRow++;
    }

    return true;
  }

  bool _colWin(int row, int col, String symbol) {
    int currCol = col;

    while (currCol >= 0) {
      if (symbolMatrix[row][currCol] != symbol) {
        return false;
      }
      currCol--;
    }

    currCol = col;
    while (currCol < Constants.size) {
      if (symbolMatrix[row][currCol] != symbol) return false;
      currCol++;
    }

    return true;
  }

  bool _primaryDiagonalWin(int row, int col, String symbol) {
    int currRow = row;
    int currCol = col;
    while (currRow < Constants.size && currCol < Constants.size) {
      if (symbolMatrix[currRow][currCol] != symbol) return false;
      currRow++;
      currCol++;
    }

    currRow = row;
    currCol = col;
    while (currRow >= 0 && currCol >= 0) {
      if (symbolMatrix[currRow][currCol] != symbol) return false;
      currRow--;
      currCol--;
    }

    return true;
  }

  bool _secondaryDiagonalWin(int row, int col, String symbol) {
    int currRow = row;
    int currCol = col;

    while (currRow < Constants.size && currCol >= 0) {
      if (symbolMatrix[currRow][currCol] != symbol) return false;
      currRow++;
      currCol--;
    }

    currRow = row;
    currCol = col;
    while (currRow <= 0 && currCol > Constants.size) {
      if (symbolMatrix[currRow][currCol] != symbol) return false;
      currRow--;
      currCol++;
    }

    return true;
  }
}
