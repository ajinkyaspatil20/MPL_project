import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/firebase_service.dart';

class AreaConverterScreen extends StatefulWidget {
  const AreaConverterScreen({super.key});

  @override
  State<AreaConverterScreen> createState() => _AreaConverterScreenState();
}

class _AreaConverterScreenState extends State<AreaConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _fromUnit = 'Square Meters';
  String _toUnit1 = 'Square Kilometers';
  String _toUnit2 = 'Acres';
  String _toUnit3 = 'Hectares';
  int _unitCount = 1;
  String _result1 = '', _result2 = '', _result3 = '';

  final List<String> _units = [
    'Square Meters',
    'Square Kilometers',
    'Acres',
    'Hectares'
  ]; 
  final FirebaseService _firebaseService = FirebaseService(); 

  final Map<String, double> _toSquareMeters = {
    'Square Meters': 1,
    'Square Kilometers': 1e6,
    'Acres': 4046.86,
    'Hectares': 10000,
  };

  void _convert() {
    if (_inputController.text.isEmpty) return;
    try {
      double inputValue = double.parse(_inputController.text);
      double inSquareMeters = inputValue * _toSquareMeters[_fromUnit]!;
      setState(() {
        _result1 =
            (inSquareMeters / _toSquareMeters[_toUnit1]!).toStringAsFixed(6);
        _result2 = _unitCount >= 2
            ? (inSquareMeters / _toSquareMeters[_toUnit2]!).toStringAsFixed(6)
            : '';
        _result3 = _unitCount == 3
            ? (inSquareMeters / _toSquareMeters[_toUnit3]!).toStringAsFixed(6)
            : '';
      });

      // Add to Firebase history
      String historyEntry = '$inputValue $_fromUnit = $_result1 $_toUnit1';
      if (_unitCount >= 2 && _result2.isNotEmpty) {
        historyEntry += ', $_result2 $_toUnit2';
      }
      if (_unitCount == 3 && _result3.isNotEmpty) {
        historyEntry += ', $_result3 $_toUnit3';
      }
      _firebaseService.addCalculationToHistory(
        calculationType: 'Area Conversion',
        expression: historyEntry,
        result: '${_result1} $_toUnit1',
      );

    } catch (e) {
      setState(() {
        _result1 = 'Invalid input';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Area Converter'),
          backgroundColor: Colors.deepPurple),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdownUnitCount(),
            const SizedBox(height: 20),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration:
                  _inputDecoration('Enter Area', FontAwesomeIcons.ruler),
            ),
            const SizedBox(height: 10),
            _buildDropdownRow('From', _fromUnit, (value) {
              setState(() {
                _fromUnit = value!;
              });
            }),
            const SizedBox(height: 10),
            _buildDropdownRow('To', _toUnit1, (value) {
              setState(() {
                _toUnit1 = value!;
              });
            }),
            if (_unitCount >= 2)
              _buildDropdownRow('Second To', _toUnit2,
                  (value) => setState(() => _toUnit2 = value!)),
            if (_unitCount == 3)
              _buildDropdownRow('Third To', _toUnit3,
                  (value) => setState(() => _toUnit3 = value!)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _convert, child: const Text('Convert')),
            Expanded(
              child: ListView(
                children: [
                  _buildResultBox(_result1, _toUnit1),
                  if (_unitCount >= 2) _buildResultBox(_result2, _toUnit2),
                  if (_unitCount == 3) _buildResultBox(_result3, _toUnit3),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownUnitCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _dropdownBoxDecoration(),
      child: DropdownButton<int>(
        value: _unitCount,
        isExpanded: true,
        dropdownColor: Colors.grey[900],
        style: const TextStyle(color: Colors.white),
        underline: Container(),
        items: [1, 2, 3]
            .map((int count) => DropdownMenuItem<int>(
                value: count, child: Text('$count Units')))
            .toList(),
        onChanged: (value) => setState(() => _unitCount = value!),
      ),
    );
  }

  Widget _buildDropdownRow(
      String label, String value, Function(String?) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: _dropdownBoxDecoration(),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              underline: Container(),
              items: _units
                  .map((unit) =>
                      DropdownMenuItem<String>(value: unit, child: Text(unit)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      prefixIcon: Icon(icon, color: Colors.deepPurple),
    );
  }

  BoxDecoration _dropdownBoxDecoration() {
    return BoxDecoration(
        border: Border.all(color: Colors.deepPurple.shade400),
        borderRadius: BorderRadius.circular(8));
  }
}
