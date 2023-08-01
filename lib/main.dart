import 'package:flutter/material.dart';

import './constants.dart';

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
  late List<String> symbolList;
  late List<List<String>> symbolMatrix;
  late int currentIdx;
  late bool isGameOver;
  late MediaQueryData media;
  late double deviceWidth;
  late double deviceHeight;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    isGameOver = false;

    symbolList = List.generate(9, (_) => '');
    symbol = Constants.symbolX;
    currentIdx = -1;

    symbolMatrix = [];
    for (var i = 0; i < Constants.size; ++i) {
      symbolMatrix.add(
        List.generate(Constants.size, (_) => ''),
      );
    }
  }

  String _getSymbol() {
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
  Widget build(BuildContext context) {
    media = MediaQuery.of(context);
    deviceWidth = media.size.width;
    deviceHeight = media.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            tooltip: 'Restart Game',
            onPressed: () {
              setState(() {
                _initialize();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: deviceWidth < deviceHeight
                ? deviceWidth * 0.6
                : deviceHeight * 0.6,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: Constants.size,
              children: List.generate(
                Constants.size * Constants.size,
                (index) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: InkWell(
                    onTap: !isGameOver && symbolList[index].trim().isEmpty
                        ? () {
                            setState(() {
                              currentIdx = index;
                            });

                            symbolList[index] = _getSymbol();

                            if (_isGameOver()) {
                              _showSnackBar(context, symbolList[currentIdx]);
                              return;
                            }
                          }
                        : null,
                    child: Center(
                      child: Text(
                        symbolList[index],
                        style: TextStyle(
                          fontSize: deviceWidth < deviceHeight
                              ? deviceWidth * 0.1
                              : deviceHeight * 0.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String winner) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The Winner is $winner!'),
        duration: const Duration(
          seconds: 3,
        ),
        action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  bool _isGameOver() {
    int row = currentIdx ~/ Constants.size;
    int col = currentIdx % Constants.size;

    symbolMatrix[row][col] = symbolList[currentIdx];

    if (_rowWin(row, col, symbolList[currentIdx]) ||
        _colWin(row, col, symbolList[currentIdx]) ||
        _primaryDiagonalWin(row, col, symbolList[currentIdx]) ||
        _secondaryDiagonalWin(row, col, symbolList[currentIdx])) {
      setState(() {
        isGameOver = true;
      });
      return true;
    }

    return false;
  }

  bool _rowWin(int row, int col, String symbol) {
    int count = 1;
    int currRow = row - 1;

    while (currRow >= 0) {
      if (symbolMatrix[currRow][col] == '' ||
          symbolMatrix[currRow][col] != symbol) return false;
      currRow--;
      count++;
    }

    currRow = row + 1;
    while (currRow < Constants.size) {
      if (symbolMatrix[currRow][col] == '' ||
          symbolMatrix[currRow][col] != symbol) return false;
      currRow++;
      count++;
    }

    return count == Constants.size;
  }

  bool _colWin(int row, int col, String symbol) {
    int count = 1;
    int currCol = col - 1;

    while (currCol >= 0) {
      if (symbolMatrix[row][currCol] == '' ||
          symbolMatrix[row][currCol] != symbol) {
        return false;
      }
      currCol--;
      count++;
    }

    currCol = col + 1;
    while (currCol < Constants.size) {
      if (symbolMatrix[row][currCol] == '' ||
          symbolMatrix[row][currCol] != symbol) return false;
      currCol++;
      count++;
    }

    return count == Constants.size;
  }

  bool _primaryDiagonalWin(int row, int col, String symbol) {
    int count = 1;
    int currRow = row + 1;
    int currCol = col + 1;
    while (currRow < Constants.size && currCol < Constants.size) {
      if (symbolMatrix[currRow][currCol] == '' ||
          symbolMatrix[currRow][currCol] != symbol) return false;
      currRow++;
      currCol++;
      count++;
    }

    currRow = row - 1;
    currCol = col - 1;
    while (currRow >= 0 && currCol >= 0) {
      if (symbolMatrix[currRow][currCol] == '' ||
          symbolMatrix[currRow][currCol] != symbol) return false;
      currRow--;
      currCol--;
      count++;
    }

    return count == Constants.size;
  }

  bool _secondaryDiagonalWin(int row, int col, String symbol) {
    int count = 1;
    int currRow = row + 1;
    int currCol = col - 1;

    while (currRow < Constants.size && currCol >= 0) {
      if (symbolMatrix[currRow][currCol] == '' ||
          symbolMatrix[currRow][currCol] != symbol) return false;
      currRow++;
      currCol--;
      count++;
    }

    currRow = row - 1;
    currCol = col + 1;
    while (currRow >= 0 && currCol < Constants.size) {
      if (symbolMatrix[currRow][currCol] == '' ||
          symbolMatrix[currRow][currCol] != symbol) return false;
      currRow--;
      currCol++;
      count++;
    }

    return count == Constants.size;
  }
}
