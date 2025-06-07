import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket.dart';
import '../models/purchase.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all tickets from your existing Firebase collection
  Stream<List<Ticket>> getTickets() {
    return _firestore.collection('Ticket').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return Ticket.fromMap(doc.data(), doc.id);
        } catch (e) {
          print('Error parsing ticket ${doc.id}: $e');
          return null;
        }
      }).where((ticket) => ticket != null).cast<Ticket>().toList();
    });
  }

  // Add a purchase
  Future<String> addPurchase(Purchase purchase) async {
    try {
      DocumentReference docRef = await _firestore.collection('purchases').add(purchase.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add purchase: $e');
    }
  }

  // Get purchase by ID
  Future<Purchase?> getPurchase(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('purchases').doc(id).get();
      if (doc.exists) {
        return Purchase.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get purchase: $e');
    }
  }
}
