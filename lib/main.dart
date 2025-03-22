import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Import Firestore package
import 'screens/home_screen.dart';
import 'firebase_options.dart'; // Make sure this file exists

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Fetch name from Firestore
  //String? fetchedName = await fetchNameFromFirestore();

  runApp(MyApp());
}

// Function to fetch 'name' from Firestore's 'test' collection

class MyApp extends StatelessWidget {
  //final String? fetchedName;
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //print(fetchedName); // Still printing for debugging purposes

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Calculator',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(),
      home: HomeScreen(), // Pass fetched name to HomeScreen
    );
  }
}
