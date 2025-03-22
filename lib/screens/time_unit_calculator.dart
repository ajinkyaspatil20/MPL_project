import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class TimeUnitCalculator extends StatefulWidget {
  const TimeUnitCalculator({super.key});

  @override
  _TimeUnitCalculatorState createState() => _TimeUnitCalculatorState();
}

class _TimeUnitCalculatorState extends State<TimeUnitCalculator> {
  final TextEditingController inputController = TextEditingController();
  String fromUnit = "Seconds";
  String toUnit = "Minutes";
  double convertedValue = 0.0;
  String errorMessage = '';

  // List of time units including more advanced units
  final List<String> timeUnits = [
    "Nanoseconds",
    "Milliseconds",
    "Seconds",
    "Minutes",
    "Hours",
    "Days",
    "Weeks",
    "Fortnights",
  ];

  // Conversion factors (base: seconds)
  final Map<String, double> unitFactors = {
    "Nanoseconds": 1e-9,
    "Milliseconds": 1e-3,
    "Seconds": 1,
    "Minutes": 60,
    "Hours": 3600,
    "Days": 86400,
    "Weeks": 604800,
    "Fortnights": 1209600, // 2 weeks
  };

  final FirebaseService _firebaseService = FirebaseService();

  void convertTime() {
    double inputValue = double.tryParse(inputController.text) ?? 0.0;

    if (inputValue <= 0) {
      setState(() {
        errorMessage = "Please enter a positive number.";
        convertedValue = 0.0;
      });
      return;
    }

    // Convert input to seconds first
    double inSeconds = inputValue * unitFactors[fromUnit]!;

    // Convert from seconds to target unit
    double result = inSeconds / unitFactors[toUnit]!;

    setState(() {
      errorMessage = '';
      convertedValue = result;
    });

    // Add to Firebase history
    _firebaseService.addCalculationToHistory(
      calculationType: 'Time Conversion',
      expression: '$inputValue $fromUnit to $toUnit',
      result: '$result $toUnit',
    );
  }

  void swapUnits() {
    setState(() {
      String temp = fromUnit;
      fromUnit = toUnit;
      toUnit = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advanced Time Unit Converter"),
        backgroundColor: Colors.blueGrey[900],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(),
            const SizedBox(height: 10),
            _buildDropdowns(),
            const SizedBox(height: 20),
            _buildButtons(),
            const SizedBox(height: 20),
            _buildResult(),
            _buildErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: inputController,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "Enter Value",
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white70),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.lightBlue),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[850],
      ),
    );
  }

  Widget _buildDropdowns() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: fromUnit,
          dropdownColor: Colors.grey[850],
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "From",
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.grey[850],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (value) {
            setState(() {
              fromUnit = value!;
            });
          },
          items: timeUnits.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: toUnit,
          dropdownColor: Colors.grey[850],
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "To",
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.grey[850],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (value) {
            setState(() {
              toUnit = value!;
            });
          },
          items: timeUnits.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: convertTime,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text("Convert", style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: swapUnits,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text("Swap", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return Center(
      child: Text(
        "Result: ${convertedValue.toStringAsFixed(2)} $toUnit",
        style: const TextStyle(
            fontSize: 24,
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Text(
        errorMessage,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
