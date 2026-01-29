import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExploreAppsScreen extends StatefulWidget {
  final String userId; 
  final String userEmail;

  const ExploreAppsScreen({
    super.key, 
    required this.userId, 
    required this.userEmail
  });

  @override
  State<ExploreAppsScreen> createState() => _ExploreAppsScreenState();
}

class _ExploreAppsScreenState extends State<ExploreAppsScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("Explore Apps", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                _filterChip("ALL", true),
                _filterChip("Android", false),
                _filterChip("Apple", false),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _db.collection('AccountOwner').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Center(child: Text("Error loading apps"));
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  List<Map<String, dynamic>> allAvailableApps = [];

                  for (var doc in snapshot.data!.docs) {
                    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    final Map<String, dynamic> apps = data['apps'] as Map<String, dynamic>? ?? {};
                    
                   apps.forEach((key, value) {
                      if (value is Map<String, dynamic>) {
                        Map<String, dynamic> appWithMetadata = Map.from(value);
                        appWithMetadata['owner_email'] = data['email'];
                        allAvailableApps.add(appWithMetadata);
                      }
                    });
                  }

                  if (allAvailableApps.isEmpty) {
                    return const Center(child: Text("No apps available for testing yet."));
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: allAvailableApps.length,
                    itemBuilder: (context, index) {
                      final appData = allAvailableApps[index];
                      return _buildAppGridItem(context, appData);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: active ? Colors.grey[700] : Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: active ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAppGridItem(BuildContext context, Map<String, dynamic> appData) {
    return GestureDetector(
      onTap: () => _showRequestDialog(context, appData),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.blueGrey[50],
                ),
                child: const Center(child: Icon(Icons.android, size: 50, color: Colors.blueAccent)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appData['appname'] ?? "Unknown App",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Available", style: TextStyle(fontSize: 10, color: Colors.green)),
                      Text("${appData['appid'] ?? 'N/A'}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showRequestDialog(BuildContext context, Map<String, dynamic> appData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text("Test ${appData['appname']}", style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("By requesting, you agree to test this app for 14 days. Ensure you have the test link ready."),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  //TODO: Replace those with the correct appurl
                  const Expanded(
                    child: Text("https://play.google.com/test...", overflow: TextOverflow.ellipsis),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: "https://play.google.com/store"));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Link Copied!")));
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await _handleTestRequest(appData);
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B7CFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Request to Test", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handleTestRequest(Map<String, dynamic> appData) async {
    try {
      final String requestId = _db.collection('TesterRequests').doc().id;

      await _db.collection('TesterRequests').doc(requestId).set({
        'appid': appData['appid'].toString(),
        'appname': appData['appname'],
        'status': 'pending',
        'testerid': widget.userEmail,
      });

      await _db.collection('Tester').doc(widget.userId).update({
        'appsbeingtested': {
          'appid': appData['appid'].toString(),
          'appname': appData['appname'],
          'publisheremail': appData['publisheremail'] ?? 'N/A',
          'accountholdingtheapp': appData['owner_email'] ?? 'Admin',
          'numberofdays': 0,
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Request sent and added to your dashboard!"))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"))
        );
      }
    }
  }
}