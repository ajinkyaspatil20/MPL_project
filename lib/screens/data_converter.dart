import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/firebase_service.dart';

class DataConverterScreen extends StatefulWidget {
  const DataConverterScreen({super.key});

  @override
  State<DataConverterScreen> createState() => _DataConverterScreenState();
}

class _DataConverterScreenState extends State<DataConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _fromUnit = 'Bit';
  String _toUnit = 'Byte'; // Initialize output unit

  String _result1 = '';

  final FirebaseService _firebaseService = FirebaseService();

  final List<String> _units = [
    'Bit',
    'Kilobit',
    'Megabit',
    'Gigabit',
    'Terabit',
    'Byte',
    'Kilobyte',
    'Megabyte',
    'Gigabyte',
    'Terabyte'
  ];

  final List<String> _toUnits = [
    'Byte',
    'Kilobyte',
    'Megabyte',
    'Gigabyte',
    'Terabyte'
  ];

  // Conversion factors to bits
  final Map<String, double> _toBitFactors = {
    'Bit': 1,
    'Kilobit': 1000,
    'Megabit': 1000000,
    'Gigabit': 1000000000,
    'Terabit': 1000000000000,
    'Byte': 8,
    'Kilobyte': 8000,
    'Megabyte': 8000000,
    'Gigabyte': 8000000000,
    'Terabyte': 8000000000000,
  };

  Future<void> _convert() async {
    if (_inputController.text.isEmpty) return;

    try {
      double inputValue = double.parse(_inputController.text);
      double inBits = inputValue * _toBitFactors[_fromUnit]!; // Correct conversion logic
      setState(() {
        _result1 = (inBits / _toBitFactors[_toUnit]!).toStringAsFixed(6);
      });

      String historyEntry = '$inputValue $_fromUnit = $_result1 $_toUnit'; 
      await _firebaseService.addCalculationToHistory(
        calculationType: 'Data Conversion',
        expression: historyEntry,
        result: '$_result1 $_toUnit',
      );
    } catch (e) {
      setState(() {
        _result1 = 'Invalid input';
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Converter'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter Value',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(FontAwesomeIcons.database,
                    color: Colors.deepPurple),
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            // Conversion units selection
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: _fromUnit,
                      isExpanded: true,
                      dropdownColor: Colors.grey[900],
                      style: const TextStyle(color: Colors.white),
                      underline: Container(),
                      items: _units.map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _fromUnit = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(FontAwesomeIcons.rightLong,
                      color: Colors.deepPurple),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: _toUnit, 
                      isExpanded: true,
                      dropdownColor: Colors.grey[900],
                      style: const TextStyle(color: Colors.white),
                      underline: Container(),
                      items: _toUnits.map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _toUnit = newValue; 
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Convert button
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Convert'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            // Result display
            Expanded(
              child: ListView(
                children: [
                  _buildResultBox(_result1, _toUnit),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultBox(String result, String unit) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.deepPurple.shade400),
      ),
      child: Column(
        children: [
          Text(result.isNotEmpty ? '$result $unit' : '0',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
