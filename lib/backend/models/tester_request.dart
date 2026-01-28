class TesterRequestModel {
  final String docId;
  final String appId;
  final String appName;
  final String status;
  final String testerId; // This is the email of the tester

  TesterRequestModel({
    required this.docId,
    required this.appId,
    required this.appName,
    required this.status,
    required this.testerId,
  });

  factory TesterRequestModel.fromFirestore(String id, Map<String, dynamic> data) {
    return TesterRequestModel(
      docId: id,
      appId: data['appid'] ?? '',
      appName: data['appname'] ?? '',
      status: data['status'] ?? 'pending',
      testerId: data['testerid'] ?? '',
    );
  }

  // Useful for manual data entry or testing
  Map<String, dynamic> toMap() {
    return {
      'appid': appId,
      'appname': appName,
      'status': status,
      'testerid': testerId,
    };
  }
}