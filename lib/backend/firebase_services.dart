import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart'; 

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. STREAM ACCOUNT OWNER (Real-time)
  /// Used for Scenario B UI to monitor account health and hosted app status
  Stream<AccountOwnerModel> streamAccountOwner(String docId) {
    return _db.collection('AccountOwner').doc(docId).snapshots().map((doc) {
      if (!doc.exists) throw Exception("Account Owner not found");
      return AccountOwnerModel.fromFirestore(doc.id, doc.data()!);
    });
  }

  // 2. STREAM TESTER DATA (Real-time)
  /// Used for the Tester UI to see "14 Days left" and app details
  Stream<TesterModel> streamTester(String docId) {
    return _db.collection('Tester').doc(docId).snapshots().map((doc) {
      if (!doc.exists) throw Exception("Tester not found");
      return TesterModel.fromFirestore(doc.id, doc.data()!);
    });
  }

  // 3. FETCH PUBLISHER DATA
  /// Used when a publisher logs in to see their submitted apps
  Future<PublisherModel> getPublisher(String docId) async {
    final doc = await _db.collection('Publisher').doc(docId).get();
    if (!doc.exists) throw Exception("Publisher not found");
    return PublisherModel.fromFirestore(doc.id, doc.data()!);
  }

  // 4. FETCH ALL TESTER REQUESTS (Manual Management)
  /// Since you mentioned handling these manually, this fetches the list
  Future<List<TesterRequestModel>> getAllRequests() async {
    final snapshot = await _db.collection('TesterRequests').get();
    return snapshot.docs
        .map((doc) => TesterRequestModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}