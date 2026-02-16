import 'package:flutter/material.dart';

void main() {
  runApp(const CounterImageToggleApp());
}

class CounterImageToggleApp extends StatelessWidget {
  const CounterImageToggleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CW1 Counter & Toggle',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _counter = 0;
  double _incrementValue = 1;
  bool _isDark = false;
  bool _isFirstImage = true;

  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() => _counter += _incrementValue.toInt());
  }

  void _decrementCounter() {
    setState(() => _counter -= _incrementValue.toInt());
  }

  void _resetCounter() {
    setState(() => _counter = 0);
  }

  Color _counterColor() {
    if (_counter == 0) return Colors.grey;

    // Clamp intensity between 0.2 and 1.0
    double intensity = (_counter.abs() / 50).clamp(0.2, 1.0);

    if (_counter > 0) {
      return Color.lerp(Colors.green.shade200, Colors.green.shade900, intensity)!;
    } else {
      return Color.lerp(Colors.red.shade200, Colors.red.shade900, intensity)!;
    }
  }


  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
  }

  void _toggleImage() {
    if (_isFirstImage) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() => _isFirstImage = !_isFirstImage);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CW1 Counter & Toggle'),
          actions: [
            IconButton(
              onPressed: _toggleTheme,
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Counter: $_counter',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: _counterColor(),
                    ),
              ),
              const SizedBox(height: 12),
              Slider(
                value: _incrementValue,
                min: 1,
                max: 10,
                divisions: 9,
                label: '$_incrementValue',
                onChanged: (double value) {
                  setState(() {
                    _incrementValue = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _incrementCounter,
                    child: const Text('Increase'),
                  ),
                  ElevatedButton(
                    onPressed: _decrementCounter,
                    child: const Text('Decrease')
                  ),
                  ElevatedButton(
                    onPressed: _resetCounter,
                    child: const Text('Reset')
                  ,)
                ]
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Cat image display first
                  Image.asset(
                    'assets/cat.jpg',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),

                  // Dog image fades in/out on top of cat
                  ScaleTransition(
                    scale: _fade,
                    child: Image.asset(
                      'assets/dog.jpg',
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _toggleImage,
                child: const Text('Toggle Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

