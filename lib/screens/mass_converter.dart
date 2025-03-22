import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class MassConverterScreen extends StatefulWidget {
  const MassConverterScreen({super.key});

  @override
  _MassConverterScreenState createState() => _MassConverterScreenState();
}

class _MassConverterScreenState extends State<MassConverterScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _controller = TextEditingController();
  double _inputValue = 0.0;
  double _convertedValue = 0.0;
  String _fromUnit = 'Kilograms';
  String _toUnit = 'Grams';

  final Map<String, double> _conversionRates = {
    'Kilograms': 1.0,
    'Grams': 1000.0,
    'Pounds': 2.20462,
    'Ounces': 35.274,
  };

  void _convert() {
    setState(() {
      double fromRate = _conversionRates[_fromUnit]!;
      double toRate = _conversionRates[_toUnit]!;
      _convertedValue = (_inputValue / fromRate) * toRate;

      // Add to Firebase history
      _firebaseService.addCalculationToHistory(
        calculationType: 'Mass Conversion',
        expression: '$_inputValue $_fromUnit to $_toUnit',
        result: '${_convertedValue.toStringAsFixed(2)} $_toUnit',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mass Converter"),
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
                  labelText: "Enter mass",
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.black,
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
                    items: _conversionRates.keys.map((String unit) {
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
                    items: _conversionRates.keys.map((String unit) {
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
