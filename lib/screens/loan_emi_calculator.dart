import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';
import '../services/firebase_service.dart';

class LoanEmiCalculator extends StatefulWidget {
  const LoanEmiCalculator({super.key});

  @override
  _LoanEmiCalculatorState createState() => _LoanEmiCalculatorState();
}

class _LoanEmiCalculatorState extends State<LoanEmiCalculator> {
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();

  double emiResult = 0.0;

  final FirebaseService _firebaseService = FirebaseService();

  void calculateEMI() {
    double P = double.tryParse(loanAmountController.text) ?? 0.0;
    double annualRate = double.tryParse(interestRateController.text) ?? 0.0;
    double tenureMonths = double.tryParse(tenureController.text) ?? 0.0;

    if (P == 0 || annualRate == 0 || tenureMonths == 0) {
      setState(() {
        emiResult = 0.0;
      });
      return;
    }

    double r = (annualRate / 12) / 100; // Monthly interest rate
    double n = tenureMonths; // Loan tenure in months

    double emi = (P * r * pow((1 + r), n)) / (pow((1 + r), n) - 1);

    setState(() {
      emiResult = emi;
    });

    // Add to Firebase history
    _firebaseService.addCalculationToHistory(
      calculationType: 'Loan EMI Calculation',
      expression:
          'Principal: ₹$P, Rate: $annualRate%, Tenure: $tenureMonths months',
      result: 'EMI: ₹${emi.toStringAsFixed(2)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan EMI Calculator",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.deepPurple[900],
        elevation: 6.0,
        shadowColor: Colors.deepPurple[300],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // EMI Banner Image
              Center(
                child: Image.asset(
                  "assets/images/EMI-Calculator.png", // Make sure this image exists
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // Input fields
              _buildTextField(loanAmountController, "Loan Amount (₹)",
                  FontAwesomeIcons.rupeeSign),
              _buildTextField(interestRateController,
                  "Annual Interest Rate (%)", FontAwesomeIcons.percent),
              _buildTextField(tenureController, "Loan Tenure (Months)",
                  FontAwesomeIcons.calendar),

              const SizedBox(height: 20),

              // EMI Calculation button
              Center(
                child: ElevatedButton.icon(
                  onPressed: calculateEMI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    shadowColor: Colors.deepPurple[300],
                  ),
                  icon: const Icon(FontAwesomeIcons.calculator,
                      color: Colors.white),
                  label: const Text("Calculate EMI",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),

              // EMI result display
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[700],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    "EMI: ₹${emiResult.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
          filled: true,
          fillColor: Colors.grey[850],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),
    );
  }
}
