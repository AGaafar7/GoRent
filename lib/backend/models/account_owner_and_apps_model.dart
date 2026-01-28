class HostedApp {
  final String appId;
  final String appName;
  final String publisherEmail;
  final String status; // e.g., "submitted"

  HostedApp({
    required this.appId,
    required this.appName,
    required this.publisherEmail,
    required this.status,
  });

  factory HostedApp.fromMap(Map<String, dynamic> map) {
    return HostedApp(
      appId: map['appid'] ?? '',
      appName: map['appname'] ?? 'Unknown App',
      publisherEmail: map['publisheremail'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }
}

class AccountOwnerModel {
  final String googleName;
  final String googleEmail;
  final HostedApp? activeApp; // The new map you added

  AccountOwnerModel({
    required this.googleName,
    required this.googleEmail,
    this.activeApp,
  });

  factory AccountOwnerModel.fromFirestore(Map<String, dynamic> data) {
    final googleDetails = data['googleaccount']?['accountdetails'] ?? {};
    
    return AccountOwnerModel(
      googleName: googleDetails['name'] ?? 'Owner',
      googleEmail: googleDetails['email'] ?? '',
      // Only parse the app if the 'apps' map exists in Firestore
      activeApp: data['apps'] != null ? HostedApp.fromMap(data['apps']) : null,
    );
  }
}