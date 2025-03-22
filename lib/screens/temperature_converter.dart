import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  _TemperatureConverterScreenState createState() =>
      _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _controller = TextEditingController();
  double _inputValue = 0.0;
  double _convertedValue = 0.0;
  String _fromUnit = 'Celsius';
  String _toUnit = 'Fahrenheit';

  final Map<String, Function(double)> _conversionFunctions = {
    'Celsius to Fahrenheit': (c) => (c * 9 / 5) + 32,
    'Celsius to Kelvin': (c) => c + 273.15,
    'Fahrenheit to Celsius': (f) => (f - 32) * 5 / 9,
    'Fahrenheit to Kelvin': (f) => (f - 32) * 5 / 9 + 273.15,
    'Kelvin to Celsius': (k) => k - 273.15,
    'Kelvin to Fahrenheit': (k) => (k - 273.15) * 9 / 5 + 32,
  };

  void _convert() {
    setState(() {
      String key = '$_fromUnit to $_toUnit';
      if (_conversionFunctions.containsKey(key)) {
        _convertedValue = _conversionFunctions[key]!(_inputValue);

        // Add to Firebase history
        _firebaseService.addCalculationToHistory(
          calculationType: 'Temperature Conversion',
          expression: '$_inputValue $_fromUnit to $_toUnit',
          result: '${_convertedValue.toStringAsFixed(2)} $_toUnit',
        );
      } else {
        _convertedValue = _inputValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Temperature Converter"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter temperature",
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (value) {
                  setState(() {
                    _inputValue = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: _fromUnit,
                    dropdownColor: Colors.white,
                    items:
                        ['Celsius', 'Fahrenheit', 'Kelvin'].map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child:
                            Text(unit, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _fromUnit = value!;
                      });
                    },
                  ),
                  Text("to",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  DropdownButton<String>(
                    value: _toUnit,
                    dropdownColor: Colors.white,
                    items:
                        ['Celsius', 'Fahrenheit', 'Kelvin'].map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child:
                            Text(unit, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _toUnit = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _convert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text("Convert",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 16.0),
              Text(
                "Converted Value: ${_convertedValue.toStringAsFixed(3)} $_toUnit",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
