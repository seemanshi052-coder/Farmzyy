import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../utils/extensions.dart';
import 'otp_screen.dart';

/// Phone login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _showPhoneForm = false; // Toggle between login methods

  // Agriculture-themed colors
  static const Color _primaryGreen = Color(0xFF2D5016); // Dark forest green
  static const Color _accentGreen = Color(0xFF4CAF50); // Fresh green
  static const Color _lightGreen = Color(0xFFE8F5E9); // Light sage
  static const Color _goldAccent = Color(0xFFB8860B); // Dark goldenrod (earth tone)
  static const Color _textDark = Color(0xFF1B3A1B); // Dark text

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  /// Handle login with phone number
  Future<void> _handleLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final phone = _phoneController.text.trim();

    setState(() => _isLoading = true);

    try {
      // Request OTP
      await authProvider.requestOtp(phone);

      if (mounted) {
        // Navigate to OTP screen
        context.navigateTo(OtpScreen(phone: phone));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Handle login with Gmail
  Future<void> _handleGmailLogin(BuildContext context) async {
    // TODO: Implement Google Sign-In
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gmail login coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _primaryGreen.withOpacity(0.95),
              _primaryGreen.withOpacity(0.98),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                SizedBox(height: context.height * 0.08),
                _buildHeader(),
                SizedBox(height: context.height * 0.06),

                // Show login options or phone form
                if (!_showPhoneForm)
                  _buildLoginOptions(context)
                else
                  _buildPhoneLoginForm(context),
                
                SizedBox(height: context.height * 0.03),

                // Terms & conditions
                _buildTermsText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build header with title and subtitle
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to\nFarmZyy',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 32,
              ),
        ),
        SizedBox(height: 12),
        Text(
          'Get expert farming insights powered by AI',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _lightGreen,
                fontSize: 16,
              ),
        ),
      ],
    );
  }

  /// Build login options (Gmail and Phone)
  Widget _buildLoginOptions(BuildContext context) {
    return Column(
      children: [
        Text(
          'Choose Your Login Method',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: context.height * 0.04),

        // Gmail Login Button
        _buildLoginOptionButton(
          context: context,
          title: 'Login with Gmail',
          icon: Icons.mail_outline,
          onPressed: () => _handleGmailLogin(context),
          backgroundColor: Colors.white,
          textColor: _primaryGreen,
        ),
        SizedBox(height: 16),

        // Phone Login Button
        _buildLoginOptionButton(
          context: context,
          title: 'Login with Phone Number',
          icon: Icons.phone_outlined,
          onPressed: () => setState(() => _showPhoneForm = true),
          backgroundColor: _accentGreen,
          textColor: Colors.white,
        ),
      ],
    );
  }

  /// Build login option button
  Widget _buildLoginOptionButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24, color: textColor),
        label: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Build phone login form
  Widget _buildPhoneLoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button to switch login method
        TextButton.icon(
          onPressed: () => setState(() => _showPhoneForm = false),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          label: const Text(
            'Back to Options',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: context.height * 0.02),

        // Phone input form
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phone label
              Text(
                'Phone Number',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _lightGreen,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 12),

              // Phone input field
              TextFormField(
                controller: _phoneController,
                enabled: !_isLoading,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter 10-digit mobile number',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: const Icon(Icons.phone, color: _accentGreen, size: 20),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _accentGreen, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _accentGreen, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  counterText: '', // Hide character counter
                ),
                validator: (value) => Validators.validatePhone(value),
              ),
              const SizedBox(height: 12),

              // Helper text
              Text(
                'We\'ll send you an OTP to verify your number',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _lightGreen,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.height * 0.04),

        // Login button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : () => _handleLogin(context),
            icon: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(_primaryGreen),
                    ),
                  )
                : const Icon(Icons.login, size: 20),
            label: Text(
              _isLoading ? 'Requesting OTP...' : 'Continue',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build terms and conditions text
  Widget _buildTermsText() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _lightGreen,
              ),
          children: [
            const TextSpan(text: 'By continuing, you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

