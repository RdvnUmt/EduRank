import 'dart:async';

import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with SingleTickerProviderStateMixin {
  // Kronometre değişkenleri
  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;
  bool _isRunning = false;
  Timer? _timer;

  // Geri sayım değişkenleri
  int _countdownSeconds = 0;
  int _countdownMinutes = 0;
  int _countdownHours = 0;
  bool _isCountdownRunning = false;
  Timer? _countdownTimer;

  // Tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countdownTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  // Kronometre başlatma fonksiyonu
  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
      });
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
          if (_seconds == 60) {
            _seconds = 0;
            _minutes++;
            if (_minutes == 60) {
              _minutes = 0;
              _hours++;
              if (_hours == 24) {
                _hours = 0;
              }
            }
          }
        });
      });
    }
  }

  // Kronometre durdurma fonksiyonu
  void _stopTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  // Kronometre sıfırlama fonksiyonu
  void _resetTimer() {
    _stopTimer();
    setState(() {
      _seconds = 0;
      _minutes = 0;
      _hours = 0;
    });
  }

  // Geri sayım başlatma fonksiyonu
  void _startCountdown() {
    if (!_isCountdownRunning && (_countdownSeconds > 0 || _countdownMinutes > 0 || _countdownHours > 0)) {
      setState(() {
        _isCountdownRunning = true;
      });
      
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownSeconds > 0) {
            _countdownSeconds--;
          } else {
            if (_countdownMinutes > 0) {
              _countdownMinutes--;
              _countdownSeconds = 59;
            } else {
              if (_countdownHours > 0) {
                _countdownHours--;
                _countdownMinutes = 59;
                _countdownSeconds = 59;
              } else {
                // Geri sayım tamamlandı
                _countdownTimer?.cancel();
                _isCountdownRunning = false;
                // Burada alarm veya bildirim eklenebilir
              }
            }
          }
        });
      });
    }
  }

  // Geri sayım durdurma fonksiyonu
  void _stopCountdown() {
    if (_isCountdownRunning) {
      _countdownTimer?.cancel();
      setState(() {
        _isCountdownRunning = false;
      });
    }
  }

  // Geri sayım sıfırlama fonksiyonu
  void _resetCountdown() {
    _stopCountdown();
    setState(() {
      _countdownSeconds = 0;
      _countdownMinutes = 0;
      _countdownHours = 0;
    });
  }

  // Zamanı iki basamaklı gösterme fonksiyonu
  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Kronometre', icon: Icon(Icons.timer, color: Colors.black),height: 46,),
            Tab(text: 'Zamanlayıcı', icon: Icon(Icons.hourglass_empty, color: Colors.black),height: 46,),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Kronometre Sayfası
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_formatNumber(_hours)}:${_formatNumber(_minutes)}:${_formatNumber(_seconds)}',
                  style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: _startTimer,
                      child: const Text('Başlat'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: _stopTimer,
                      child: const Text('Durdur'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: _resetTimer,
                      child: const Text('Sıfırla'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Geri Sayım Sayfası
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_formatNumber(_countdownHours)}:${_formatNumber(_countdownMinutes)}:${_formatNumber(_countdownSeconds)}',
                  style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                if (!_isCountdownRunning)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Saat seçimi
                      _buildTimeSelector(
                        label: 'Saat',
                        value: _countdownHours,
                        onAdd: () {
                          setState(() {
                            if (_countdownHours < 23) {
                              _countdownHours++;
                            }
                          });
                        },
                        onRemove: () {
                          setState(() {
                            if (_countdownHours > 0) {
                              _countdownHours--;
                            }
                          });
                        },
                      ),
                      
                      // Dakika seçimi
                      _buildTimeSelector(
                        label: 'Dakika',
                        value: _countdownMinutes,
                        onAdd: () {
                          setState(() {
                            if (_countdownMinutes < 59) {
                              _countdownMinutes++;
                            } else {
                              _countdownMinutes = 0;
                              if (_countdownHours < 23) {
                                _countdownHours++;
                              }
                            }
                          });
                        },
                        onRemove: () {
                          setState(() {
                            if (_countdownMinutes > 0) {
                              _countdownMinutes--;
                            } else if (_countdownHours > 0) {
                              _countdownMinutes = 59;
                              _countdownHours--;
                            }
                          });
                        },
                      ),
                      
                      // Saniye seçimi
                      _buildTimeSelector(
                        label: 'Saniye',
                        value: _countdownSeconds,
                        onAdd: () {
                          setState(() {
                            if (_countdownSeconds < 59) {
                              _countdownSeconds++;
                            } else {
                              _countdownSeconds = 0;
                              if (_countdownMinutes < 59) {
                                _countdownMinutes++;
                              } else {
                                _countdownMinutes = 0;
                                if (_countdownHours < 23) {
                                  _countdownHours++;
                                }
                              }
                            }
                          });
                        },
                        onRemove: () {
                          setState(() {
                            if (_countdownSeconds > 0) {
                              _countdownSeconds--;
                            } else if (_countdownMinutes > 0) {
                              _countdownSeconds = 59;
                              _countdownMinutes--;
                            } else if (_countdownHours > 0) {
                              _countdownSeconds = 59;
                              _countdownMinutes = 59;
                              _countdownHours--;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _startCountdown,
                      child: const Text('Başlat'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _stopCountdown,
                      child: const Text('Durdur'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _resetCountdown,
                      child: const Text('Sıfırla'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Zaman seçici widget
  Widget _buildTimeSelector({
    required String label,
    required int value,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(label),
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: onAdd,
          ),
          Text(
            _formatNumber(value),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
