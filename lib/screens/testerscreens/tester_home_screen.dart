import 'package:flutter/material.dart';
import 'package:gorent/backend/firebase_services.dart';
import 'package:gorent/backend/models/models.dart';
import 'package:gorent/screens/testerscreens/explore_apps_screen.dart';

class TesterDashboard extends StatefulWidget {
  final String userId;
  const TesterDashboard({super.key, required this.userId});

  @override
  State<TesterDashboard> createState() => _TesterDashboardState();
}

class _TesterDashboardState extends State<TesterDashboard> {
  int _currentIndex = 0;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TesterModel>(
      stream: _firebaseService.streamTester(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text("Error loading dashboard")));
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final tester = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _currentIndex == 0 ? _buildProfessionalAppBar(tester) : null,
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildHomeBody(tester),
              ExploreAppsScreen(
                userId: tester.docId,
                userEmail: tester.email,
              ),
            ],
          ),
          bottomNavigationBar: _buildProfessionalNavBar(),
        );
      },
    );
  }

  PreferredSizeWidget _buildProfessionalAppBar(TesterModel tester) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dashboard",
            style: TextStyle(
              color: Color(0xFF1A1C1E),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Text(
            "Welcome back, ${tester.name}",
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.person, color: Color(0xFF1A1C1E), size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeBody(TesterModel tester) {
    final activeApp = tester.activeTest;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBalanceSection(tester.moneyEarned),
          const SizedBox(height: 32),
          const Text(
            "Apps in Testing",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 12),
          activeApp != null 
              ? _buildProfessionalList(activeApp) 
              : _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(int money) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "Current Earnings",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "\$ ${money.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Color(0xFF1A1C1E),
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalList(AppBeingTested app) {
    String statusText;
    Color statusColor;

    if (app.numberOfDays == 0) {
      statusText = "Awaiting Access";
      statusColor = Colors.orange;
    } else {
      int remaining = 14 - app.numberOfDays;
      statusText = remaining <= 0 ? "Testing Complete" : "$remaining Days Remaining";
      statusColor = remaining <= 0 ? Colors.green : Colors.blueAccent;
    }

    return Column(
      children: [
        _workCard(app.appName, statusText, statusColor),
      ],
    );
  }

  Widget _workCard(String name, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1C1E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.layers_outlined, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalNavBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1A1C1E),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize_outlined),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: "Explore",
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.auto_awesome_motion_outlined, size: 50, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "No active tests",
              style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              "Go to Explore to find apps to test",
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}