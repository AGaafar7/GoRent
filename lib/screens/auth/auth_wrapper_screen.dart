import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gorent/screens/accountownerscreens/home_account_owner_screen.dart';
import 'package:gorent/screens/publisherscreens/publisher_screen.dart';
import 'package:gorent/screens/testerscreens/tester_home_screen.dart';

enum AuthTab { login, signup }

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  
  AuthTab _activeTab = AuthTab.login;

  
  String _selectedAccountType = 'Publisher';
  bool _rememberMe = false;
  bool _obscurePassword = true;
  @override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  _nameController.dispose();
  _phoneController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      body: Stack(
        children: [
          _buildHeader(),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildMainContainer(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    bool isLogin = _activeTab == AuthTab.login;
    return Positioned(
      top: 60,
      left: 24,
      right: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on, color: Colors.purpleAccent, size: 24),
              const SizedBox(width: 8),
              const Text(
                'GoRent',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            isLogin ? 'Welcome Back' : 'Get Started now',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isLogin
                ? 'Login to check your earnings or to publish your apps'
                : 'Create an account to start earning or to publish your apps',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          _buildCustomTabBar(),
          const SizedBox(height: 32),
          
          Expanded(
            child: SingleChildScrollView(
              child: _activeTab == AuthTab.login
                  ? _buildLoginForm()
                  : _buildRegisterForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _tabButton("Log In", AuthTab.login)),
          Expanded(child: _tabButton("Sign Up", AuthTab.signup)),
        ],
      ),
    );
  }

  Widget _tabButton(String label, AuthTab tab) {
    bool isActive = _activeTab == tab;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = tab), 
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Email"),
        _textField("Loisbecket@gmail.com", controller: _emailController),
        const SizedBox(height: 20),
        _label("Password"),
        _textField("*******", isPassword: true, controller: _passwordController),
        _buildFooterOptions(),
        const SizedBox(height: 40),
        _submitButton("Log In"),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Account Type"),
        _dropdown(),
        const SizedBox(height: 20),
        _label("Name"),
        _textField("John Doe", controller: _nameController),
        const SizedBox(height: 20),
        _label(
          _selectedAccountType == "Account Provider" ? "Google Gmail" : "Email",
        ),
        _textField("Loisbecket@gmail.com", controller: _emailController),
        if (_selectedAccountType == "Account Provider") ...[
          const SizedBox(height: 20),
          _label("Phone Number"),
          _textField("+201273299508", controller: _phoneController),
        ],
        const SizedBox(height: 20),
        _label(
          _selectedAccountType == "Account Provider"
              ? "Google Password"
              : "Password",
        ),
        _textField("*******", isPassword: true, controller: _passwordController),
        _buildFooterOptions(),
        const SizedBox(height: 40),
        _submitButton("Get Started"),
      ],
    );
  }

  

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 14)),
  );

  Widget _textField(String hint, {bool isPassword = false, TextEditingController? controller}) {
    return TextField(
      obscureText: isPassword && _obscurePassword,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _dropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedAccountType,
          isExpanded: true,
          items: [
            'Publisher',
            'Account Provider',
            'Tester',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _selectedAccountType = v!),
        ),
      ),
    );
  }

  Widget _buildFooterOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (v) => setState(() => _rememberMe = v!),
            ),
            const Text(
              "Remember me",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Forgot Password ?",
            style: TextStyle(color: Colors.blueAccent, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _submitButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
       onPressed: _isLoading ? null : () {
  if (_activeTab == AuthTab.login) {
    _handleLogin();
  } else {
    _handleRegister();
  }
},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B7CFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

 Future<void> _handleLogin() async {
  setState(() => _isLoading = true);
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  try {
    var ownerDoc = await FirebaseFirestore.instance.collection('AccountOwner')
        .where('useremail', isEqualTo: email)
        .where('userpassword', isEqualTo: password)
        .get();

    if (ownerDoc.docs.isNotEmpty) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccountOwnerHome(userId: ownerDoc.docs.first.id))
        );
      }
      return;
    }

    var pubDoc = await FirebaseFirestore.instance.collection('Publisher')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if (pubDoc.docs.isNotEmpty) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PublisherHome(userId: pubDoc.docs.first.id))
        );
      }
      return;
    }

    var testDoc = await FirebaseFirestore.instance.collection('Tester')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if (testDoc.docs.isNotEmpty) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TesterDashboard(userId: testDoc.docs.first.id))
        );
      }
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account not found. Please check credentials or register."))
      );
    }
  } catch (e) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

Future<void> _handleRegister() async {
  setState(() => _isLoading = true);
  final db = FirebaseFirestore.instance;

  Map<String, dynamic> commonData = {
    'name': _nameController.text.trim(),
    'email': _emailController.text.trim(),
    'password': _passwordController.text.trim(),
  };

  try {
    if (_selectedAccountType == 'Publisher') {
      DocumentReference docRef = await db.collection('Publisher').add({
        ...commonData,
        'apps': {},
      });
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PublisherHome(userId: docRef.id)),
        );
      }
    } else if (_selectedAccountType == 'Tester') {
      DocumentReference docRef = await db.collection('Tester').add({
        ...commonData,
        'appsbeingtested': null,
        'moneyearned': 0,
      });
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TesterDashboard(userId: docRef.id)),
        );
      }
    } else if (_selectedAccountType == 'Account Provider') {
      DocumentReference docRef = await db.collection('AccountOwner').add({
        'name': _nameController.text.trim(),
        'useremail': _emailController.text.trim(),
        'userpassword': _passwordController.text.trim(),
        'phonenumber': int.tryParse(_phoneController.text.trim()) ?? 0,
        'googleaccount': {
          'accountdetails': {
            'email': '',
            'password': '',
          }
        },
        'apps': {}, 
        'moneyearned': 0,
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccountOwnerHome(userId: docRef.id)),
        );
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Failed: $e")));
    }
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
}
