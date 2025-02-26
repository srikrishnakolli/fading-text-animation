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

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  Color _textColor = Colors.blue;
  bool _showFrame = false;

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
        title: Text('Fading Text Animation'),
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
      body: GestureDetector(
        onTap: toggleVisibility,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: Text(
                  'Hello, Flutter!',
                  style: TextStyle(fontSize: 24, color: _textColor),
                ),
              ),
              SizedBox(height: 20),
              SwitchListTile(
                title: Text('Show Frame Around Image'),
                value: _showFrame,
                onChanged: (value) {
                  setState(() {
                    _showFrame = value;
                  });
                },
              ),
              Container(
                decoration: _showFrame
                    ? BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      )
                    : null,
                child: Image.network(
                  'https://flutter.dev/images/flutter-logo-sharing.png',
                  width: 100,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Go to Second Animation"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondAnimationScreen(),
                    ),
                  );
                },
              ),
            ],
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

class SecondAnimationScreen extends StatefulWidget {
  @override
  _SecondAnimationScreenState createState() => _SecondAnimationScreenState();
}

class _SecondAnimationScreenState extends State<SecondAnimationScreen> {
  bool _isVisible = true;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Animation')),
      body: Center(
        child: GestureDetector(
          onTap: toggleVisibility,
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: Duration(seconds: 2),
            curve: Curves.bounceInOut,
            child: Text(
              'Flutter Animations!',
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
