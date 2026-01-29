class HostedApp {
  final String appId;
  final String appName;
  final String publisherEmail;
  final String accountEmail;
  final String status;

  HostedApp({
    required this.appId,
    required this.appName,
    required this.publisherEmail,
    required this.accountEmail,
    required this.status,
  });

  factory HostedApp.fromMap(Map<String, dynamic> map) {
    return HostedApp(
      appId: map['appid'] ?? '',
      appName: map['appname'] ?? 'Unknown App',
      publisherEmail: map['publisheremail'] ?? '',
      accountEmail: map['accountemail'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }
}

class AccountOwnerModel {
  final String name;
  final int phoneNumber;
  final String userEmail;
  final String userPassword;
  final Map<String, dynamic> googleAccountDetails;
  final HostedApp? activeApp;
  final int moneyEarned;

  AccountOwnerModel({
    required this.name,
    required this.phoneNumber,
    required this.userEmail,
    required this.userPassword,
    required this.googleAccountDetails,
    this.activeApp,
    required this.moneyEarned,
  });

  factory AccountOwnerModel.fromFirestore(Map<String, dynamic> data) {
    final details = data['googleaccount']?['accountdetails'] ?? {};
    
    return AccountOwnerModel(
      name: data['name'] ?? 'Owner',
      phoneNumber: data['phonenumber'] ?? 0,
      userEmail: data['useremail'] ?? '',
      userPassword: data['userpassword'] ?? '',
      
      googleAccountDetails: {
        'email': details['email'] ?? '',
        'password': details['password'] ?? '',
      },
      
      activeApp: data['apps'] != null ? HostedApp.fromMap(data['apps']) : null,
      moneyEarned: data['moneyearned'] ?? 0,
    );
  }
}