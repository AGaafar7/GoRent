class PublisherModel {
  final String docId;
  final String name;
  final String email;
  final String password;
  final PublishedApp? app;

  PublisherModel({
    required this.docId,
    required this.name,
    required this.email,
    required this.password,
    this.app,
  });

  factory PublisherModel.fromFirestore(String id, Map<String, dynamic> data) {
    return PublisherModel(
      docId: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      app: data['apps'] != null 
          ? PublishedApp.fromMap(data['apps'] as Map<String, dynamic>) 
          : null,
    );
  }
}

class PublishedApp {
  final String appFileUrl;
  final int appId;
  final String appName;
  final String publishedOnAccount; 
  final String status;

  PublishedApp({
    required this.appFileUrl,
    required this.appId,
    required this.appName,
    required this.publishedOnAccount,
    required this.status,
  });

  factory PublishedApp.fromMap(Map<String, dynamic> map) {
    return PublishedApp(
      appFileUrl: map['appfileurl'] ?? '',
      appId: map['appid'] ?? 0,
      appName: map['appname'] ?? '',
      publishedOnAccount: map['publishedonaccount'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }
}