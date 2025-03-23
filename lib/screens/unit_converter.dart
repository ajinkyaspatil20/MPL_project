import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'mass_converter.dart'; // ✅ Import Mass Converter Screen
import 'temperature_converter.dart'; // ✅ Import Temperature Converter Screen
import 'length_converter.dart'; // ✅ Import Length Converter Screen
import 'data_converter.dart'; // ✅ Import Data Converter Screen
import 'area_converter.dart'; // ✅ Import Area Converter Screen
import 'volume_converter.dart'; // ✅ Import Volume Converter Screen


class UnitConverterScreen extends StatelessWidget {
  const UnitConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unit Converter"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.black,
      body: GridView.count(
        padding: EdgeInsets.all(12),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _buildUnitConverterOption(context, "Mass Converter",
              FontAwesomeIcons.weightScale, MassConverterScreen()),
          _buildUnitConverterOption(context, "Temperature Converter",
              FontAwesomeIcons.temperatureHalf, TemperatureConverterScreen()),
          _buildUnitConverterOption(context, "Length Converter",
              FontAwesomeIcons.rulerVertical, LengthConverterScreen()),
          _buildUnitConverterOption(context, "Data Converter",
              FontAwesomeIcons.database, DataConverterScreen()),
          _buildUnitConverterOption(context, "Area Converter",
              FontAwesomeIcons.chartArea, AreaConverterScreen()),
          _buildUnitConverterOption(context, "Volume Converter",
              FontAwesomeIcons.cube, VolumeConverterScreen()),

        ],
      ),
    );
  }

  // ✅ Function to build clickable unit converter options (Moved inside the class)
  Widget _buildUnitConverterOption(
      BuildContext context, String label, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
