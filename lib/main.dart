import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: BouncingTextAnimation(toggleTheme: toggleTheme),
    );
  }
}

class BouncingTextAnimation extends StatefulWidget {
  final VoidCallback toggleTheme;

  BouncingTextAnimation({required this.toggleTheme});

  @override
  _BouncingTextAnimationState createState() => _BouncingTextAnimationState();
}

class _BouncingTextAnimationState extends State<BouncingTextAnimation> with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  Color _textColor = Colors.blue;
  double _textSize = 24.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 15).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceInOut,
    ));
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pick a Text Color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _textColor,
              onColorChanged: (color) {
                setState(() {
                  _textColor = color;
                });
              },
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text("Select"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bouncing Animation'),
        actions: [
          IconButton(icon: Icon(Icons.color_lens), onPressed: pickColor),
          IconButton(icon: Icon(Icons.brightness_6), onPressed: widget.toggleTheme),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: Duration(seconds: 1),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animation.value),
                    child: Text(
                      'Bouncing Text!',
                      style: TextStyle(fontSize: _textSize, color: _textColor, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Slider(
              value: _textSize,
              min: 16,
              max: 48,
              divisions: 10,
              label: _textSize.round().toString(),
              onChanged: (value) {
                setState(() {
                  _textSize = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleVisibility,
              child: Text("Toggle Animation"),
            ),
          ],
        ),
      ),
    );
  }
}
