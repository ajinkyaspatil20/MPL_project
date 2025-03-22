import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class LengthConverterScreen extends StatefulWidget {
  const LengthConverterScreen({super.key});

  @override
  _LengthConverterScreenState createState() => _LengthConverterScreenState();
}

class _LengthConverterScreenState extends State<LengthConverterScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _controller = TextEditingController();
  double _inputValue = 0.0;
  double _convertedValue = 0.0;
  String _fromUnit = 'Meters';
  String _toUnit = 'Kilometers';

  final Map<String, Function(double)> _conversionFunctions = {
    'Meters to Kilometers': (m) => m / 1000,
    'Meters to Centimeters': (m) => m * 100,
    'Meters to Inches': (m) => m * 39.3701,
    'Meters to Feet': (m) => m * 3.28084,
    'Meters to Miles': (m) => m / 1609.34,
    'Kilometers to Meters': (km) => km * 1000,
    'Kilometers to Centimeters': (km) => km * 100000,
    'Kilometers to Inches': (km) => km * 39370.1,
    'Kilometers to Feet': (km) => km * 3280.84,
    'Kilometers to Miles': (km) => km / 1.60934,
    'Centimeters to Meters': (cm) => cm / 100,
    'Centimeters to Kilometers': (cm) => cm / 100000,
    'Centimeters to Inches': (cm) => cm / 2.54,
    'Centimeters to Feet': (cm) => cm / 30.48,
    'Centimeters to Miles': (cm) => cm / 160934,
    'Inches to Meters': (inches) => inches / 39.3701,
    'Inches to Kilometers': (inches) => inches / 39370.1,
    'Inches to Centimeters': (inches) => inches * 2.54,
    'Inches to Feet': (inches) => inches / 12,
    'Inches to Miles': (inches) => inches / 63360,
    'Feet to Meters': (feet) => feet / 3.28084,
    'Feet to Kilometers': (feet) => feet / 3280.84,
    'Feet to Centimeters': (feet) => feet * 30.48,
    'Feet to Inches': (feet) => feet * 12,
    'Feet to Miles': (feet) => feet / 5280,
    'Miles to Meters': (miles) => miles * 1609.34,
    'Miles to Kilometers': (miles) => miles * 1.60934,
    'Miles to Centimeters': (miles) => miles * 160934,
    'Miles to Inches': (miles) => miles * 63360,
    'Miles to Feet': (miles) => miles * 5280,
  };

  void _convert() {
    setState(() {
      String key = '$_fromUnit to $_toUnit';
      if (_conversionFunctions.containsKey(key)) {
        _convertedValue = _conversionFunctions[key]!(_inputValue);

        // Add to Firebase history
        _firebaseService.addCalculationToHistory(
          calculationType: 'Length Conversion',
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
        title: Text("Length Converter"),
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
                  labelText: "Enter length",
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
                    items: [
                      'Meters',
                      'Kilometers',
                      'Centimeters',
                      'Inches',
                      'Feet',
                      'Miles'
                    ].map((String unit) {
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
                    items: [
                      'Meters',
                      'Kilometers',
                      'Centimeters',
                      'Inches',
                      'Feet',
                      'Miles'
                    ].map((String unit) {
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
