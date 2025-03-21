import 'package:flutter/material.dart';
import '/widgets/text_field.dart';
import '/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _form = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _errorMessage = null;
    });

    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> result;

      if (_isLogin) {
        print('Login işlemi başlatılıyor');
        result = await AuthService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
        print('Login işlemi sonucu: $result');
      } else {
        print('Kayıt işlemi başlatılıyor');
        result = await AuthService.register(
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );

        print('Kayıt işlemi sonucu: $result');
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.green,
            ),
          );

          if (!_isLogin) {
            setState(() {
              _isLogin = true;
            });
          } else {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        } else {
          setState(() {
            _errorMessage = result['message'];
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage ?? 'Bir hata oluştu'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Submit metodu hata: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Bir hata oluştu: ${e.toString()}';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İşlem sırasında bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school_rounded,
                  size: 80,
                  color: Color(0xFF4A6572),
                ),
                const SizedBox(height: 16),
                Text(
                  'EduRank',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A6572),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin
                      ? 'Devam etmek için giriş yapın'
                      : 'Yeni bir hesap oluşturun',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 40),
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 20,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          if (!_isLogin)
                            TextFieldCard(
                              controller: _usernameController,
                              label: 'Kullanıcı Adı',
                              hint: 'Kullanıcı adınızı giriniz',
                              icon: Icons.person_outline,
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Lütfen kullanıcı adınızı giriniz';
                                }
                                if (value.trim().length < 3) {
                                  return 'Kullanıcı adı en az 3 karakter olmalıdır';
                                }
                                return null;
                              },
                            ),
                          TextFieldCard(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'Email adresinizi giriniz',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value
                                          .substring(0, value.indexOf('@'))
                                          .length <
                                      4) {
                                return 'Lütfen geçerli bir email adresi giriniz';
                              }
                              if (!value.contains('@etu.edu.tr')) {
                                return 'Lütfen etu.edu.tr email adresi giriniz';
                              }
                              return null;
                            },
                          ),
                          TextFieldCard(
                            controller: _passwordController,
                            label: 'Şifre',
                            hint: 'Şifrenizi giriniz',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lütfen şifrenizi giriniz';
                              }
                              if (value.trim().length < 6) {
                                return 'Şifre en az 6 karakter olmalıdır';
                              }
                              return null;
                            },
                          ),
                          if (_isLogin)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('Şifremi unuttum?'),
                              ),
                            ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : Text(
                                        _isLogin
                                            ? 'Giriş Yap'
                                            : 'Hesap Oluştur',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin
                          ? 'Hesabınız yok mu?'
                          : 'Zaten bir hesabınız var mı?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          _errorMessage = null;
                        });
                      },
                      child: Text(_isLogin ? 'Hesap Oluştur' : 'Giriş Yap'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
