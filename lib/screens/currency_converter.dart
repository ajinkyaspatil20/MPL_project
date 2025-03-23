import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/firebase_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController amountController = TextEditingController();

  String fromCurrency = "INR";
  String toCurrency = "USD";
  double convertedAmount = 0.0;
  bool isLoading = false;

  // 🔹 Available Currencies
  final List<String> currencies = [
    "INR",
    "USD",
    "EUR",
    "GBP",
    "JPY",
    "AUD",
    "CAD",
    "CHF",
    "CNY",
    "AED"
  ];

  final FirebaseService _firebaseService = FirebaseService();

  Future<void> convertCurrency() async {
    setState(() {
      isLoading = true;
    });

    String apiKey =
        "Orlr88ssoaAuRalJ1ZURjHbjNUfaX51q"; // 🔹 Replace with your API Key
    String url =
        "https://api.apilayer.com/exchangerates_data/latest?base=$fromCurrency&symbols=$toCurrency";

    try {
      final response =
          await http.get(Uri.parse(url), headers: {"apikey": apiKey});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["rates"] != null && data["rates"].containsKey(toCurrency)) {
          double rate = data["rates"][toCurrency];
          double amount = double.tryParse(amountController.text) ?? 0.0;

          if (amount <= 0) {
            throw Exception("Please enter a valid amount greater than zero.");
          }

          setState(() {
            convertedAmount = amount * rate;
            isLoading = false;
          });

          // Add to Firebase history
          _firebaseService.addCalculationToHistory(
            calculationType: 'Currency Conversion',
            expression: '$amount $fromCurrency to $toCurrency',
            result: '${convertedAmount.toStringAsFixed(2)} $toCurrency',
          );
        } else {
          throw Exception("Invalid response structure from the API.");
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Converter",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Amount Input Box
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                  labelText: "Enter Amount",
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.purple.shade200, width: 2),
                  ),
                  prefixIcon:
                      const Icon(Icons.attach_money, color: Colors.white),
                ),
              ),
            ),

            // 🔹 Currency Selection (From)
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: DropdownButton<String>(
                      value: fromCurrency,
                      dropdownColor: Colors.black87,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        setState(() {
                          fromCurrency = value!;
                        });
                      },
                      items: currencies.map((currency) {
                        return DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: DropdownButton<String>(
                      value: toCurrency,
                      dropdownColor: Colors.black87,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        setState(() {
                          toCurrency = value!;
                        });
                      },
                      items: currencies.map((currency) {
                        return DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),

            // 🔹 Convert Button
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : convertCurrency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        "Convert",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),

            // 🔹 Result Display
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    "${amountController.text.isEmpty ? '0.00' : amountController.text} $fromCurrency = ",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${convertedAmount.toStringAsFixed(2)} $toCurrency",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
