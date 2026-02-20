import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../utils/extensions.dart';
import '../home/home_screen.dart';

/// OTP verification screen
class OtpScreen extends StatefulWidget {
  final String phone;

  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _focusNodes;
  int _timeoutSeconds = 120; // 2 minutes
  late Future<void> _timerFuture;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
    _timerFuture = _startTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Start countdown timer
  Future<void> _startTimer() async {
    for (int i = 120; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _timeoutSeconds = i);
      }
    }
  }

  /// Handle OTP input change
  void _onOtpChange(int index, String value) {
    if (value.length == 1) {
      // Move to next field if digit entered
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // All fields filled, attempt login
        _focusNodes[index].unfocus();
        _handleVerifyOtp();
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous field if deleted
      _focusNodes[index - 1].requestFocus();
    }
  }

  /// Get OTP from controllers
  String _getOtp() {
    return _otpControllers.map((c) => c.text).join();
  }

  /// Verify OTP
  Future<void> _handleVerifyOtp() async {
    final otp = _getOtp();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 6 digits')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.loginWithOtp(widget.phone, otp);

    if (success && mounted) {
      // Navigate to home screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else if (mounted && authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error ?? 'Login failed')),
      );
    }
  }

  /// Resend OTP
  Future<void> _resendOtp() async {
    setState(() => _timeoutSeconds = 120);
    _timerFuture = _startTimer();

    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.requestOtp(widget.phone);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${authProvider.error}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              _buildBackButton(),
              SizedBox(height: context.height * 0.06),

              // Header
              _buildHeader(),
              SizedBox(height: context.height * 0.04),

              // OTP input fields
              _buildOtpInputFields(),
              SizedBox(height: context.height * 0.04),

              // Verify button
              _buildVerifyButton(),
              SizedBox(height: context.height * 0.03),

              // Resend OTP section
              _buildResendSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build back button
  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
        ),
        child: const Icon(Icons.arrow_back, size: 24),
      ),
    );
  }

  /// Build header with title
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify your number',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            children: [
              const TextSpan(text: 'Enter the 6-digit code sent to '),
              TextSpan(
                text: widget.phone,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build OTP input fields
  Widget _buildOtpInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
        (index) => SizedBox(
          width: 50,
          height: 60,
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            onChanged: (value) => _onOtpChange(index, value),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
                borderSide: const BorderSide(
                  color: AppConstants.primaryColor,
                  width: 2,
                ),
              ),
            ),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }

  /// Build verify button
  Widget _buildVerifyButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: authProvider.isLoading ? null : _handleVerifyOtp,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: authProvider.isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Verifying...'),
                    ],
                  )
                : const Text(
                    'Verify',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        );
      },
    );
  }

  /// Build resend OTP section
  Widget _buildResendSection() {
    return Center(
      child: Column(
        children: [
          if (_timeoutSeconds > 0)
            Text(
              'Resend in ${_timeoutSeconds}s',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            )
          else
            GestureDetector(
              onTap: _resendOtp,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(text: 'Didn\'t receive the code? '),
                    TextSpan(
                      text: 'Resend',
                      style: const TextStyle(
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
