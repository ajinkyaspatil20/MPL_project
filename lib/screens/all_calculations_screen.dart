import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'loan_emi_calculator.dart';
import 'time_unit_calculator.dart';
import 'currency_converter.dart';
import 'unit_converter.dart'; // ✅ Import Unit Converter Screen
import 'date_calculation.dart'; // ✅ Import Date Calculation Screen

class AllCalculatorsScreen extends StatelessWidget {
  const AllCalculatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Calculators"),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.black,
      body: GridView.count(
        padding: EdgeInsets.all(12),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _buildCalculatorButton(context, "Calculator",
              FontAwesomeIcons.calculator, Colors.orange),
          _buildCalculatorButton(context, "Time Converter & Calculations",
              FontAwesomeIcons.clock, Colors.green),
          _buildCalculatorButton(context, "Currency Converter",
              FontAwesomeIcons.moneyBill, Colors.blue),
          _buildCalculatorButton(context, "Unit Converter",
              FontAwesomeIcons.ruler, Colors.purple), // ✅ FIXED
          _buildCalculatorButton(context, "Loan EMI Calculator",
              FontAwesomeIcons.creditCard, Colors.red),
          _buildCalculatorButton(context, "Date Calculations",
              FontAwesomeIcons.calendar, Colors.teal),
        ],
      ),
    );
  }

  Widget _buildCalculatorButton(
      BuildContext context, String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        print("$label button tapped!"); // 🔍 Debugging Print

        if (label == "Unit Converter") {
          // ✅ Open Unit Converter Screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UnitConverterScreen()));
        } else if (label == "Loan EMI Calculator") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoanEmiCalculator()));
        } else if (label == "Time Converter & Calculations") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TimeUnitCalculator()));
        } else if (label == "Currency Converter") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CurrencyConverterScreen()));
        } else if (label == "Date Calculations") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DateCalculationScreen()));
        } else if (label == "Calculator") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("$label is in working state"),
            duration: Duration(seconds: 2),
          ));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 40, color: Colors.white),
            SizedBox(height: 10),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
