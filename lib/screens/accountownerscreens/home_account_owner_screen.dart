import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gorent/backend/models/models.dart';

class AccountOwnerHome extends StatefulWidget {
  final String userId;
  const AccountOwnerHome({super.key, required this.userId});

  @override
  State<AccountOwnerHome> createState() => _AccountOwnerHomeState();
}

class _AccountOwnerHomeState extends State<AccountOwnerHome> {
  final TextEditingController _dialogEmailController = TextEditingController();
  final TextEditingController _dialogPasswordController = TextEditingController();

  @override
  void dispose() {
    _dialogEmailController.dispose();
    _dialogPasswordController.dispose();
    super.dispose();
  }

  void _showAddAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Google Account"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _dialogEmailController,
              decoration: const InputDecoration(labelText: "Google Email", hintText: "example@gmail.com"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dialogPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Google Password"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('AccountOwner')
                  .doc(widget.userId)
                  .update({
                'googleaccount.accountdetails.email': _dialogEmailController.text.trim(),
                'googleaccount.accountdetails.password': _dialogPasswordController.text.trim(),
              });
              _dialogEmailController.clear();
              _dialogPasswordController.clear();
             if (context.mounted) {
      Navigator.pop(context);
    }
            },
            child: const Text("Save Account"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('AccountOwner').doc(widget.userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final owner = AccountOwnerModel.fromFirestore(data);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildProfessionalAppBar(owner.name),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF1A1C1E),
            onPressed: _showAddAccountDialog,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildMetricsCard(owner.moneyEarned, owner.activeApp != null),
                const SizedBox(height: 24),
                _buildAccountSelector(owner.googleAccountDetails['email']),
                const SizedBox(height: 32),
                _buildSectionHeader("Active Portfolio"),
                const SizedBox(height: 12),
                owner.activeApp != null ? _buildProfessionalAppList(owner.activeApp!, owner.moneyEarned) : _buildEmptyState(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }
    );
  }

  PreferredSizeWidget _buildProfessionalAppBar(String name) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hi, $name!", style: const TextStyle(color: Color(0xFF1A1C1E), fontWeight: FontWeight.bold, fontSize: 20)),
          Text("Management Console", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF1A1C1E)), onPressed: () {}),
        const Padding(
          padding: EdgeInsets.only(right: 16, left: 8),
          child: CircleAvatar(radius: 18, backgroundColor: Color(0xFFF1F4F9), child: Icon(Icons.person, size: 20, color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildMetricsCard(int revenue, bool hasActiveApp) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFF1A1C1E), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("TOTAL REVENUE", style: TextStyle(color: Colors.white.withValues(alpha:0.5), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
              const Icon(Icons.trending_up, color: Colors.greenAccent, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text("\$ $revenue.00", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withValues(alpha:0.1)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metricItem("Apps", hasActiveApp ? "1" : "0"),
              _metricItem("Status", hasActiveApp ? "Active" : "Idle"),
              _metricItem("Avg. ROI", "14%"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha:0.5), fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildAccountSelector(String email) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE0E0E0))),
      child: Row(
        children: [
          const Icon(Icons.business_center_outlined, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              email.isEmpty ? "No Google Account Linked" : email,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A1C1E)),
            ),
          ),
          const Icon(Icons.expand_more_rounded, size: 18, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
        const Icon(Icons.filter_list_rounded, size: 18, color: Colors.grey),
      ],
    );
  }

  Widget _buildProfessionalAppList(HostedApp app, int totalEarned) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE0E0E0))),
      child: Row(
        children: [
          Container(
            height: 48, width: 48,
            decoration: BoxDecoration(color: const Color(0xFFF8F9FE), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFE0E0E0))),
            child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF1A1C1E), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app.appName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 4),
                _statusBadge(app.status),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("\$$totalEarned.00", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Text("Total Earned", style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.green.withValues(alpha:0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(text.toUpperCase(), style: const TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Text("No Assets Published", style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}