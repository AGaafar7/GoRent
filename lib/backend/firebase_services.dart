import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/models.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<AccountOwnerModel> streamAccountOwner(String docId) {
    return _db.collection('AccountOwner').doc(docId).snapshots().map((doc) {
      if (!doc.exists) throw Exception("Account Owner not found");
      return AccountOwnerModel.fromFirestore(doc.data()!);
    });
  }

  Stream<TesterModel> streamTester(String docId) {
    return _db.collection('Tester').doc(docId).snapshots().map((doc) {
      if (!doc.exists) throw Exception("Tester not found");
      return TesterModel.fromFirestore(doc.id, doc.data()!);
    });
  }

Stream<PublisherModel> streamPublisher(String docId) {
  return _db.collection('Publisher').doc(docId).snapshots().map((doc) {
    if (!doc.exists) throw Exception("Publisher not found");
    return PublisherModel.fromFirestore(doc.id, doc.data()!);
  });
}

  Future<PublisherModel> getPublisher(String docId) async {
    final doc = await _db.collection('Publisher').doc(docId).get();
    if (!doc.exists) throw Exception("Publisher not found");
    return PublisherModel.fromFirestore(doc.id, doc.data()!);
  }

  Future<List<TesterRequestModel>> getAllRequests() async {
    final snapshot = await _db.collection('TesterRequests').get();
    return snapshot.docs
        .map((doc) => TesterRequestModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}