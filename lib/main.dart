import 'package:flutter/material.dart';
import 'pages/input_page.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

// 🔥 SIMPLE THEME CONTROLLER
class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController _controller = ThemeController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MaterialApp(
          title: 'Kalkulator BMI',
          debugShowCheckedModeBanner: false,

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _controller.themeMode,

          home: InputPageWrapper(controller: _controller),
        );
      },
    );
  }
}

// 🔥 WRAPPER
class InputPageWrapper extends StatelessWidget {
  final ThemeController controller;

  const InputPageWrapper({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const InputPage(),

      // 🔥 BUTTON TOGGLE THEME
      floatingActionButton: FloatingActionButton(
        onPressed: controller.toggleTheme,
        child: Icon(
          controller.themeMode == ThemeMode.light
              ? Icons.dark_mode
              : Icons.light_mode,
        ),
      ),
    );
  }
}