import 'package:flutter/material.dart';

enum AuthTab { login, signup }

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  
  AuthTab _activeTab = AuthTab.login;

  
  String _selectedAccountType = 'Publisher';
  bool _rememberMe = false;
  bool _obscurePassword = true;

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
        _textField("Loisbecket@gmail.com"),
        const SizedBox(height: 20),
        _label("Password"),
        _textField("*******", isPassword: true),
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
        _textField("John Doe"),
        const SizedBox(height: 20),
        _label(
          _selectedAccountType == "Account Provider" ? "Google Gmail" : "Email",
        ),
        _textField("Loisbecket@gmail.com"),
        if (_selectedAccountType == "Account Provider") ...[
          const SizedBox(height: 20),
          _label("Phone Number"),
          _textField("+201273299508"),
        ],
        const SizedBox(height: 20),
        _label(
          _selectedAccountType == "Account Provider"
              ? "Google Password"
              : "Password",
        ),
        _textField("*******", isPassword: true),
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

  Widget _textField(String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword && _obscurePassword,
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
        onPressed: () {},
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
}
