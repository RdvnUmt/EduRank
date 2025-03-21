import 'package:flutter/material.dart';
import '/screens/auth.dart';
import '/screens/profile_screen.dart';
import '/services/auth_service.dart';

class AuthManager extends StatefulWidget {
  const AuthManager({super.key});

  @override
  State<AuthManager> createState() => _AuthManagerState();
}

class _AuthManagerState extends State<AuthManager> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    
    if (mounted) {
      setState(() {
        _isAuthenticated = isLoggedIn;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_isAuthenticated) {
      return const ProfileScreen();
    }
    
    return const AuthScreen();
  }
}
