class TesterModel {
  final String docId;
  final String name;
  final String email;
  final String password;
  final AppBeingTested? activeTest;
  final int moneyEarned;

  TesterModel({
    required this.docId,
    required this.name,
    required this.email,
    required this.password,
    this.activeTest,
    required this.moneyEarned,
  });

  factory TesterModel.fromFirestore(String id, Map<String, dynamic> data) {
    return TesterModel(
      docId: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      activeTest: data['appsbeingtested'] != null 
          ? AppBeingTested.fromMap(data['appsbeingtested'] as Map<String, dynamic>) 
          : null,
      moneyEarned: data['moneyearned'] ?? 0,
    );
  }
}

class AppBeingTested {
  final String appId;
  final String appName;
  final String publisherEmail;
  final String accountHoldingApp;
  final int numberOfDays;

  AppBeingTested({
    required this.appId,
    required this.appName,
    required this.publisherEmail,
    required this.accountHoldingApp,
    required this.numberOfDays,
  });

  factory AppBeingTested.fromMap(Map<String, dynamic> map) {
    return AppBeingTested(
      appId: map['appid'] ?? '',
      appName: map['appname'] ?? '',
      publisherEmail: map['publisheremail'] ?? '',
      accountHoldingApp: map['accountholdingtheapp'] ?? '',
      numberOfDays: map['numberofdays'] ?? 0,
    );
  }
}