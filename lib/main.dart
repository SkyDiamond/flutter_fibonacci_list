import 'package:flutter/material.dart';
import 'package:flutter_fibonacci_list/fibonacci_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FibonacciModel> fibonacci = [];
  List<FibonacciModel> filteredFibonacci = [];
  List<FibonacciModel> tappedFibonacci = [];

  int? currentFibonacciIndex;
  IconData? currentSymbol;

  @override
  void initState() {
    super.initState();
    fibonacci = generateFibonacciModels(41);
    filterFibonacciModels();
  }

  List<FibonacciModel> generateFibonacciModels(int n) {
    if (n <= 0) {
      return [];
    }

    List<int> fib = List.filled(n, 0);
    fib[0] = 0;

    if (n > 1) {
      fib[1] = 1;
      for (int i = 2; i < n; i++) {
        fib[i] = fib[i - 1] + fib[i - 2];
      }
    }

    return List.generate(n, (i) {
      IconData symbol;
      switch (i % 3) {
        case 0:
          symbol = Icons.crop_square;
          break;
        case 1:
          symbol = Icons.close;
          break;
        case 2:
          symbol = Icons.circle;
          break;
        default:
          symbol = Icons.crop_square;
      }
      return FibonacciModel(index: i, number: fib[i], symbol: symbol);
    });
  }

  void filterFibonacciModels() {
    filteredFibonacci = fibonacci.where((e) => !tappedFibonacci.contains(e)).toList();
  }

  void showBottomSheet(List<FibonacciModel> sheetFibonacci) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
            itemCount: sheetFibonacci.length,
            itemBuilder: (context, index) {
              return sheetListTile(sheetFibonacci[index]);
            },
          ),
        );
      },
    );
  }

  ListTile mainListTile(FibonacciModel model) {
    return ListTile(
      title: Text('Index: ${model.index}, Number: ${model.number}'),
      trailing: Icon(model.symbol),
      tileColor: currentFibonacciIndex == model.index ? Colors.red : null,
      onTap: () => handleMainListTileTap(model),
    );
  }

  void handleMainListTileTap(FibonacciModel model) {
    setState(() {
      currentFibonacciIndex = model.index;
      currentSymbol = model.symbol;
      tappedFibonacci.add(model);
      tappedFibonacci.sort((a, b) => a.index.compareTo(b.index));
      filterFibonacciModels();
    });
    showBottomSheet(tappedFibonacci.where((e) => e.symbol == currentSymbol).toList());
  }

  ListTile sheetListTile(FibonacciModel model) {
    return ListTile(
      title: Text('Number: ${model.number}'),
      subtitle: Text('Index: ${model.index}'),
      trailing: Icon(model.symbol),
      tileColor: currentFibonacciIndex == model.index ? Colors.green : null,
      onTap: () => handleSheetListTileTap(model),
    );
  }

  void handleSheetListTileTap(FibonacciModel model) {
    setState(() {
      currentFibonacciIndex = model.index;
      tappedFibonacci.remove(model);
      filterFibonacciModels();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: filteredFibonacci.length,
        itemBuilder: (context, index) {
          return mainListTile(filteredFibonacci[index]);
        },
      ),
    );
  }
}
