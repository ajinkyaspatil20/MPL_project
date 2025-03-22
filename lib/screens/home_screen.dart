import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:mpl_lab/screens/all_calculations_screen.dart';
import 'dart:math';
// import 'screens/all_calculations_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isScientific = false;
  bool isDegreeMode = true;
  String expression = "";
  String result = "";

  void onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        expression = "";
        result = "";
      } else if (value == "=") {
        try {
          result = evaluateExpression(expression);
        } catch (e) {
          result = "Error";
        }
      } else if (value == "Deg/Rad") {
        isDegreeMode = !isDegreeMode;
      } else {
        expression += value;
      }
    });
  }

  String evaluateExpression(String expr) {
    try {
      Parser parser = Parser();
      ContextModel cm = ContextModel();

      expr = expr.replaceAllMapped(
          RegExp(r'(sin|cos|tan|sinh|cosh|tanh)\(([^)]+)\)'), (match) {
        String function = match.group(1)!;
        String value = match.group(2)!;
        if (isDegreeMode) {
          return '$function(${double.parse(value) * (pi / 180)})';
        }
        return match.group(0)!;
      });

      expr = expr.replaceAllMapped(RegExp(r'ln\(([^)]+)\)'), (match) {
        double value = double.parse(match.group(1)!);
        return value > 0 ? log(value).toString() : "Error";
      });

      expr = expr.replaceAllMapped(RegExp(r'log10\(([^)]+)\)'), (match) {
        double value = double.parse(match.group(1)!);
        return value > 0 ? (log(value) / log(10)).toString() : "Error";
      });

      expr = expr.replaceAllMapped(RegExp(r'(\d+)!'), (match) {
        int num = int.parse(match.group(1)!);
        return factorial(num).toString();
      });

      Expression parsedExpression = parser.parse(expr);
      double evalResult = parsedExpression.evaluate(EvaluationType.REAL, cm);
      return evalResult.toString();
    } catch (e) {
      return "Error";
    }
  }

  int factorial(int n) {
    if (n < 0) return -1;
    return (n == 0 || n == 1) ? 1 : n * factorial(n - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF252525),
        title: Center(child: Text(
            "Smart Calculator", style: TextStyle(color: Colors.white))),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildNavBar(), // NAVIGATION BAR MOVED TO THE TOP
            _buildDisplay(),
            _buildToggleButtons(),
            Expanded(child: _buildButtonGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      color: Color(0xFF252525),
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _navBarButton("Home", FontAwesomeIcons.home, () {}),
          SizedBox(width: 15),
          _navBarButton("All", FontAwesomeIcons.list, () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => AllCalculatorsScreen()));
          }),
          SizedBox(width: 15),
          _navBarButton("Settings", FontAwesomeIcons.cog, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _navBarButton(String label, IconData icon, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: FaIcon(icon, color: Colors.white, size: 16),
      label: Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

  Widget _buildDisplay() {
    return Container(
      height: 100,
      width: double.infinity,
      padding: EdgeInsets.all(12),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(expression, style: TextStyle(fontSize: 22, color: Colors.white)),
          SizedBox(height: 5),
          Text(result, style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _toggleButton("Basic Mode", "Scientific Mode", isScientific, () {
            setState(() {
              isScientific = !isScientific;
            });
          }),
          _toggleButton("Degree Mode", "Radian Mode", isDegreeMode, () {
            onButtonPressed("Deg/Rad");
          }),
        ],
      ),
    );
  }

  Widget _toggleButton(String offLabel, String onLabel, bool isActive,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(color: isActive ? Colors.teal : Colors.blue,
            borderRadius: BorderRadius.circular(6)),
        child: Text(isActive ? onLabel : offLabel,
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }

  Widget _buildButtonGrid() {
    List<String> basicButtons = [
      "7", "8", "9", "C", "4", "5", "6", "/", "1", "2", "3", "*",
      "0", ".", "=", "+", "-", "(", ")", "%"
    ];
    List<String> scientificButtons = [
      "sin", "cos", "tan", "sinh", "cosh", "tanh",
      "log10", "ln", "√", "π", "^", "!"
    ];

    List<String> buttons = isScientific
        ? scientificButtons + basicButtons
        : basicButtons;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: GridView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isScientific ? 5 : 4,
          childAspectRatio: 1.1,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
        ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          return _buildButton(buttons[index]);
        },
      ),
    );
  }

  Widget _buildButton(String value) {
    Color buttonColor = Colors.grey[900]!;
    Color textColor = Colors.white;

    if (value == "C") {
      buttonColor = Colors.red;
    } else if (value == "=") {
      buttonColor = Colors.green[600]!;
    }

    return GestureDetector(
      onTap: () => onButtonPressed(value),
      child: Container(
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(4)),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        child: Text(value, style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
      ),
    );
  }
}
