import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:math';

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
      home: FadingTextAnimation(toggleTheme: toggleTheme),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final VoidCallback toggleTheme;

  FadingTextAnimation({required this.toggleTheme});

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  Color _textColor = Colors.blue;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
      _isVisible ? _controller.reverse() : _controller.forward();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isVisible ? "Text is Visible" : "Text is Hidden"),
        duration: Duration(seconds: 1),
      ),
    );
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
        title: Text('Rotating Animation'),
        actions: [
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: pickColor,
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: Duration(seconds: 1),
          child: RotationTransition(
            turns: _controller.drive(Tween(begin: 0.0, end: 1.0)),
            child: Text(
              'Rotating Text!',
              style: TextStyle(fontSize: 28, color: _textColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
