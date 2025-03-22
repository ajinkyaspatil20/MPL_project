import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a calculation to history
  Future<void> addCalculationToHistory({
    required String calculationType,
    required String expression,
    required String result,
  }) async {
    try {
      await _firestore.collection('calculations').add({
        'type': calculationType,
        'expression': expression,
        'result': result,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding calculation to history: $e');
      rethrow;
    }
  }

  // Get all calculations history
  Stream<QuerySnapshot> getCalculationsHistory() {
    return _firestore
        .collection('calculations')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Get calculations history by type
  Stream<QuerySnapshot> getCalculationsByType(String type) {
    return _firestore
        .collection('calculations')
        .where('type', isEqualTo: type)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Delete a calculation from history
  Future<void> deleteCalculation(String calculationId) async {
    try {
      await _firestore.collection('calculations').doc(calculationId).delete();
    } catch (e) {
      print('Error deleting calculation: $e');
      rethrow;
    }
  }

  // Clear all history
  Future<void> clearAllHistory() async {
    try {
      var snapshots = await _firestore.collection('calculations').get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error clearing history: $e');
      rethrow;
    }
  }
}
