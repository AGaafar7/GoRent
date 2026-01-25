import 'package:flutter/material.dart';

class PublisherHome extends StatefulWidget {
  const PublisherHome({super.key});

  @override
  State<PublisherHome> createState() => _PublisherHomeState();
}

class _PublisherHomeState extends State<PublisherHome> {
  bool hasApps = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 32),
              if (hasApps) ...[
                const Text(
                  "Apps",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F111A),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Expanded(child: hasApps ? _buildAppList() : _buildEmptyState()),
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
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Hi, Gaafar!",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F111A),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blueAccent.withValues(alpha: 0.2),
              width: 3,
            ),
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "Start publishing your apps",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAppList() {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F111A),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150',
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "App Name",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Text(
                "Status",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isUploading = false;

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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: _isUploading
                ? _buildSuccessAnimation()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _modalField("App Name", "App Name"),
                        _modalField(
                          "App Description",
                          "this app is for chatting online",
                        ),
                        _modalField("Category", "category"),
                        _buildUploadPlaceholder("App File", "aab or .ipk"),
                        _buildUploadPlaceholder(
                          "App Images",
                          "upload a zip file with images",
                        ),
                        const SizedBox(height: 40),
                        _buildUploadButton(setModalState, context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _modalField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black87),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Colors.greenAccent,
          size: 100,
        ),
        Row(children: [Spacer()]),
        const SizedBox(height: 24),
        const Text(
          "Upload Successful!",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Your app is now under review.",
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 40),
        TextButton(
          onPressed: () {
            setState(() => _isUploading = false);
            Navigator.pop(context);
          },
          child: const Text("Back to Dashboard"),
        ),
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
              border: Border.all(
                color: const Color.fromARGB(
                  255,
                  0,
                  0,
                  0,
                ).withValues(alpha: 0.2),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.02),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                const SizedBox(width: 12),
                Text(hint, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(
    StateSetter setModalState,
    BuildContext modalContext,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          
          setModalState(() => _isUploading = true);

          
          
          await Future.delayed(const Duration(seconds: 2));

          
          if (modalContext.mounted) {
            setModalState(() {
              
            });

            
            await Future.delayed(const Duration(seconds: 2));
            if (modalContext.mounted) {
              Navigator.of(modalContext).pop();
              
              setState(() => _isUploading = false);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          "Proceed to payment",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
