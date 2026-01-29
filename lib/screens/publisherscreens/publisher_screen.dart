import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gorent/backend/models/models.dart';

class PublisherHome extends StatefulWidget {
  final String userId;
  const PublisherHome({super.key, required this.userId});

  @override
  State<PublisherHome> createState() => _PublisherHomeState();
}
//TODO: Add the additional fields in the firebase backend
class _PublisherHomeState extends State<PublisherHome> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  bool _isUploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Publisher').doc(widget.userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Scaffold(body: Center(child: Text("Error loading data")));
        if (!snapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));

        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        final publisher = PublisherModel.fromFirestore(snapshot.data!.id, data);
        
        final Map<String, dynamic> appsMap = data['apps'] is Map ? data['apps'] : {};
        final hasApps = appsMap.isNotEmpty;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FE),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(publisher.name),
                  const SizedBox(height: 32),
                  if (hasApps) ...[
                    const Text(
                      "Your Published Apps",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F111A),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Expanded(
                    child: hasApps 
                      ? _buildAppList(appsMap) 
                      : _buildEmptyState(),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddAppModal(context),
            backgroundColor: const Color(0xFF0F111A),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
        );
      },
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Hi, $name!",
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F111A),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent.withValues(alpha:0.2), width: 3),
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "Start publishing your apps",
        style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildAppList(Map<String, dynamic> apps) {
    final keys = apps.keys.toList();

    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final appData = apps[keys[index]] as Map<String, dynamic>;
        final app = PublishedApp.fromMap(appData);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F111A),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.android, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.appName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "ID: ${app.appId}",
                      style: TextStyle(color: Colors.white.withValues(alpha:0.5), fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  app.status,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddAppModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.fromLTRB(24, 30, 24, MediaQuery.of(context).viewInsets.bottom + 20),
            child: _isUploading
                ? _buildSuccessAnimation()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _modalField("App Name", "My Awesome App", _nameController),
                        _modalField("App Description", "Tell us about it...", _descController),
                        _modalField("Category", "Productivity", _categoryController),
                        _buildUploadPlaceholder("App File", "aab or .ipk"),
                        _buildUploadPlaceholder("App Images", "upload a zip file"),
                        const SizedBox(height: 40),
                        _buildUploadButton(setModalState, context),
                      ],
                    ),
                  ),
          );
        },
      ),
    ).then((_) {
      _nameController.clear();
      _descController.clear();
      _categoryController.clear();
    });
  }

  Widget _modalField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildUploadButton(StateSetter setModalState, BuildContext modalContext) {
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: () async {
        if (_nameController.text.trim().isEmpty) return;

        setModalState(() => _isUploading = true);

        try {
          final String timestampId = DateTime.now().millisecondsSinceEpoch.toString();
          
          await FirebaseFirestore.instance
              .collection('Publisher')
              .doc(widget.userId)
              .update({
            'apps.$timestampId': {
              'appname': _nameController.text.trim(),
              'appid': int.parse(timestampId.substring(timestampId.length - 6)),
              'appfileurl': 'pending_upload', 
              'publishedonaccount': 'Not assigned',
              'status': 'Under Review',
            }
          });

          await Future.delayed(const Duration(seconds: 2));
          if (modalContext.mounted) {
            await Future.delayed(const Duration(seconds: 1));
            if (modalContext.mounted) {
              Navigator.pop(modalContext);
            }
          }

          if (mounted) {
            setState(() => _isUploading = false);
          }
        } catch (e) {
          if (mounted) {
            setModalState(() => _isUploading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: $e"))
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text(
        "Proceed to payment",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

  Widget _buildSuccessAnimation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 100),
        const SizedBox(height: 24),
        const Text("Upload Successful!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("Your app is now under review.", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildUploadPlaceholder(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withValues(alpha:0.02),
            ),
            child: Row(
              children: [
                const Icon(Icons.cloud_upload_outlined, color: Colors.black),
                const SizedBox(width: 12),
                Text(hint, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}