import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mathInterestController = TextEditingController();

  String role = "Student";
  String difficultyLevel = "Intermediate";
  String favoriteMathField = "Algebra";

  final List<String> difficultyLevels = ["Beginner", "Intermediate", "Advanced"];
  final List<String> mathFields = ["Algebra", "Geometry", "Calculus", "Trigonometry", "Statistics"];

  @override
  void dispose() {
    _usernameController.dispose();
    _mathInterestController.dispose();
    super.dispose();
  }

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Profile Updated Successfully!", style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade300, Colors.black],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🟢 Profile Picture Selection
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: _profileImage != null
                          ? ClipOval(
                        child: Image.file(
                          _profileImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Icon(Icons.person, size: 60, color: Colors.deepPurple),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Tap to change profile picture",
                    style: TextStyle(fontSize: 14, color: Colors.white54),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Create Your Profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),

                  SizedBox(height: 30),

                  _buildTextField("Username", _usernameController),

                  SizedBox(height: 20),

                  _buildDropdown("Role", ["Student", "Teacher"], role, (value) => setState(() => role = value!)),

                  SizedBox(height: 20),

                  _buildTextField("What do you love about math?", _mathInterestController),

                  SizedBox(height: 20),

                  _buildDropdown("Math Difficulty Level", difficultyLevels, difficultyLevel, (value) => setState(() => difficultyLevel = value!)),

                  SizedBox(height: 20),

                  _buildDropdown("Favorite Math Field", mathFields, favoriteMathField, (value) => setState(() => favoriteMathField = value!)),

                  SizedBox(height: 30),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("Username: ${_usernameController.text}, Role: $role, Interest: ${_mathInterestController.text}, Level: $difficultyLevel, Favorite: $favoriteMathField");
                          _showSuccessMessage(); // Show success message after saving
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text("Save Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
      ),
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, String selectedValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.grey[900],
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: TextStyle(color: Colors.white)))).toList(),
      onChanged: onChanged,
    );
  }
}
