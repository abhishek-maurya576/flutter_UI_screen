import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/animated_background.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _buttonAnimation;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _validateAndLogin() async {
    // Clear previous error
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please fill in all fields";
        _isLoading = false;
      });
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        _errorMessage = "Please enter a valid email address";
        _isLoading = false;
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = "Password must be at least 6 characters";
        _isLoading = false;
      });
      return;
    }

    // Simulate login process
    await Future.delayed(const Duration(seconds: 1));
    
    // Show success message and reset loading
    _showSuccessDialog("Login Successful", "Welcome back to Futura!");
    setState(() {
      _isLoading = false;
    });
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.blue.withOpacity(0.5),
              width: 2,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.orbitron(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.quicksand(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text(
                "OK",
                style: GoogleFonts.quicksand(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated 3D background with custom animation
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF0F3460),
                  Color(0xFF16213E),
                ],
              ),
            ),
            child: const AnimatedParticlesBackground(
              numberOfParticles: 70,
              colors: [
                Colors.blue,
                Colors.blueAccent,
                Colors.lightBlueAccent,
                Colors.white,
              ],
            ),
          ),
          // Login Form with Glassmorphism
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Title
                    Text(
                      'FUTURA',
                      style: GoogleFonts.orbitron(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.blue.withOpacity(0.5),
                            offset: const Offset(0, 5),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome to the future',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Login Card with Glassmorphism
                    GlassmorphicContainer(
                      width: size.width > 400 ? 400 : size.width * 0.9,
                      height: _errorMessage != null ? 410 : 380,
                      borderRadius: 20,
                      blur: 20,
                      alignment: Alignment.center,
                      border: 2,
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                        stops: const [0.1, 1],
                      ),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.2),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Email TextField
                            _buildNeumorphicTextField(
                              controller: _emailController,
                              hint: 'Email',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),
                            // Password TextField
                            _buildNeumorphicTextField(
                              controller: _passwordController,
                              hint: 'Password',
                              prefixIcon: Icons.lock_outline,
                              isPassword: true,
                              isPasswordVisible: _isPasswordVisible,
                              onVisibilityToggle: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Forgot password logic
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            // Error message if any
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.red.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: GoogleFonts.quicksand(
                                          color: Colors.red[100],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            // Login Button with Glow and Animation
                            _buildLoginButton(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Sign up text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.quicksand(
                            color: Colors.white70,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/register');
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.quicksand(
                              color: Colors.blue[300],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeumorphicTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // Outer shadow (bottom right)
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(3, 3),
            blurRadius: 5,
          ),
          // Inner shadow (top left - lighter)
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            offset: const Offset(-2, -2),
            blurRadius: 5,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          style: GoogleFonts.quicksand(color: Colors.white),
          obscureText: isPassword && !isPasswordVisible,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.quicksand(color: Colors.white54),
            prefixIcon: Icon(
              prefixIcon,
              color: Colors.blue[300],
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white54,
                    ),
                    onPressed: onVisibilityToggle,
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) {
        _animationController.reverse();
        _validateAndLogin();
      },
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _buttonAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _buttonAnimation.value,
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[700]!,
                    Colors.blue[400]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.6),
                    spreadRadius: 1,
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'LOGIN',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
} 