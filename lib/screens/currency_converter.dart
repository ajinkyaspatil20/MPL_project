import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/firebase_service.dart';

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

  // 🔹 Available Currencies with Flags
  final Map<String, String> currencies = {
    "INR": "🇮🇳 Indian Rupee",
    "USD": "🇺🇸 US Dollar",
    "EUR": "🇪🇺 Euro",
    "GBP": "🇬🇧 British Pound",
    "JPY": "🇯🇵 Japanese Yen",
    "AUD": "🇦🇺 Australian Dollar",
    "CAD": "🇨🇦 Canadian Dollar",
    "CHF": "🇨🇭 Swiss Franc",
    "CNY": "🇨🇳 Chinese Yuan",
    "AED": "🇦🇪 UAE Dirham"
  };

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
        double rate = data["rates"][toCurrency];
        double amount = double.tryParse(amountController.text) ?? 0.0;

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
        print("Error: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("💰 Currency Converter",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.moneyBillTrendUp,
                  size: 60, color: Colors.white),
              SizedBox(height: 20),

              // 🔹 Amount Input Box
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Enter Amount",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              SizedBox(height: 20),

              // 🔹 Currency Selection (From)
              Text("From Currency",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: fromCurrency,
                dropdownColor: Colors.deepPurple.shade200,
                style: TextStyle(color: Colors.white, fontSize: 16),
                onChanged: (value) {
                  setState(() {
                    fromCurrency = value!;
                  });
                },
                items: currencies.keys.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text(currencies[currency]!),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),

              // 🔹 Currency Selection (To)
              Text("To Currency",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: toCurrency,
                dropdownColor: Colors.deepPurple.shade200,
                style: TextStyle(color: Colors.white, fontSize: 16),
                onChanged: (value) {
                  setState(() {
                    toCurrency = value!;
                  });
                },
                items: currencies.keys.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text(currencies[currency]!),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              // 🔹 Convert Button
              ElevatedButton.icon(
                onPressed: isLoading ? null : convertCurrency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: Icon(Icons.compare_arrows, color: Colors.white),
                label: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Convert",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
              ),

              SizedBox(height: 20),

              // 🔹 Converted Amount Display
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26, blurRadius: 8, spreadRadius: 2)
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Converted Amount",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "$convertedAmount $toCurrency",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
