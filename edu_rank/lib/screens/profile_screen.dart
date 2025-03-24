import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/profile_item.dart';
import '/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Fetching profile data...');
      final result = await AuthService.getProfile();
      print('Profile data received: $result');

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (result['success']) {
            _profileData = result;
            print('Profile data loaded successfully');
            print('Total score: ${_profileData?['total_score']}');
            print('Total time spent: ${_profileData?['total_time_spent']}');
          } else {
            _errorMessage = result['message'];
            print('Failed to load profile: ${result['message']}');
          }
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'An error occurred: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.logout();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          Navigator.of(context).pushReplacementNamed('/');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Çıkış yapılırken bir hata oluştu'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[150],
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProfile,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadProfile,
                      child: const Text('Yeniden Dene'),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 24,
                          color: Colors.black,
                        ),
                        Text(
                          'Skorlarınız',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 30),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Toplam Skorunuz',
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${_profileData?['total_score'] != null ? _profileData!['total_score'].toStringAsFixed(0) : 0}',
                                  style: GoogleFonts.roboto(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.timer, color: Colors.blue, size: 30),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Toplam Süreniz',
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${_profileData?['total_time_spent'] != null ? (_profileData!['total_time_spent'] / 60).toStringAsFixed(1) : 0} dakika',
                                  style: GoogleFonts.roboto(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    const Divider(),
                    ProfileItem(
                      icon: Icons.person_outline,
                      title: 'Kullanıcı Adı',
                      value: _profileData?['username'] ?? 'Kullanıcı',
                    ),
                    ProfileItem(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: _profileData?['email'] ?? 'Email',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                        ),
                        child: const Text('Çıkış Yap'),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
