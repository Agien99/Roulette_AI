import 'package:flutter/material.dart';
import 'package:Roulette_AI_Predictor/roulette_analyzer.dart';
import 'package:Roulette_AI_Predictor/loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roulette Predictor AI by Agien',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const LoadingScreen(),
    );
  }
}

class RoulettePredictorScreen extends StatefulWidget {
  const RoulettePredictorScreen({super.key});

  @override
State<RoulettePredictorScreen> createState() => _RoulettePredictorScreenState();
}

class _RoulettePredictorScreenState extends State<RoulettePredictorScreen> {
  late RouletteAnalyzer _analyzer;
  List<int> _predictions = [];
  List<int> _history = [];
  String _hitMissStatus = '';
  int _hitCount = 0;
  int _missCount = 0;

  @override
  void initState() {
    super.initState();
    _analyzer = RouletteAnalyzer();
    _initializeAnalyzer();
  }

  Future<void> _initializeAnalyzer() async {
    await _analyzer.history; // Ensure history is loaded
    setState(() {
      _predictions = _analyzer.getPredictions();
      _history = List.from(_analyzer.history);
    });
  }

  Future<void> _onNumberPressed(int number) async {
    if (_predictions.isNotEmpty) {
      if (_predictions.contains(number)) {
        _hitMissStatus = 'HIT!';
        _hitCount++;
      } else {
        _hitMissStatus = 'MISS.';
        _missCount++;
      }
    }
    await _analyzer.addNumber(number);
    setState(() {
      _predictions = _analyzer.getPredictions();
      _history = List.from(_analyzer.history);
    });
  }

  Future<void> _resetHistory() async {
    await _analyzer.resetHistory();
    setState(() {
      _history = [];
      _predictions = _analyzer.getPredictions();
      _hitMissStatus = '';
      _hitCount = 0;
      _missCount = 0;
    });
  }

  Color _getRouletteNumberColor(int number) {
    if (number == 0) {
      return Colors.green;
    }
    final redNumbers = {1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36};
    if (redNumbers.contains(number)) {
      return Colors.red;
    }
    return Colors.black;
  }

  List<Widget> _buildPredictionRows(List<int> numbers) {
    List<Widget> rows = [];
    for (int i = 0; i < numbers.length; i += 8) {
      List<int> rowNumbers = numbers.sublist(i, (i + 8 > numbers.length) ? numbers.length : i + 8);
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Center(
            child: Wrap(
              spacing: 1.0,
              runSpacing: 1.0,
              children: rowNumbers.map((number) => Chip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.all(2.0),
                label: SizedBox(
                  width: 20, // Adjust as needed to fit two digits
                  child: Text(
                    number.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                backgroundColor: _getRouletteNumberColor(number),
              )).toList(),
            ),
          ),
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roulette Predictor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetHistory,
            tooltip: 'Reset History',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hit/Miss Status
            if (_hitMissStatus.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _hitMissStatus,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _hitMissStatus == 'HIT!' ? Colors.green : Colors.red,
                  ),
                ),
              ),
            
            // Predictions
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Next Recommended Numbers:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (_predictions.isNotEmpty && _predictions[0] == 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Center(
                          child: Chip(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.all(2.0),
                            label: SizedBox(
                              width: 20, // Adjust as needed to fit two digits
                              child: Text(
                                _predictions[0].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            backgroundColor: _getRouletteNumberColor(_predictions[0]),
                          ),
                        ),
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildPredictionRows(_predictions.isNotEmpty && _predictions[0] == 0 ? _predictions.sublist(1) : _predictions),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Number Input Grid
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(
                        child: SizedBox(
                          width: 50, // Adjust size as needed
                          height: 50, // Adjust size as needed
                          child: ElevatedButton(
                            onPressed: () => _onNumberPressed(0),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(8),
                              backgroundColor: _getRouletteNumberColor(0),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              '0',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverGrid.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: 36, // Numbers 1 to 36
                    itemBuilder: (context, index) {
                      final number = index + 1; // Start from 1
                      return ElevatedButton(
                        onPressed: () => _onNumberPressed(number),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(8),
                          backgroundColor: _getRouletteNumberColor(number),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          number.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // History
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('History:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 50, // Adjusted height for single line
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 6.0,
                          children: _history.reversed.map((number) => Chip(
                            label: Text(
                              number.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: _getRouletteNumberColor(number),
                          )).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hit/Miss Counters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Hits: $_hitCount', style: const TextStyle(fontSize: 18, color: Colors.green)),
                Text('Misses: $_missCount', style: const TextStyle(fontSize: 18, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}