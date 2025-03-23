import 'dart:async';
import 'package:edu_rank/data/quizzes_data.dart';
import 'package:edu_rank/time_manager.dart';
import 'package:flutter/material.dart';
import '/widgets/time_selector.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with SingleTickerProviderStateMixin {
  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;
  bool _isRunning = false;
  Timer? _timer;

  int _timerSeconds = 0;
  int _timerMinutes = 0;
  int _timerHours = 0;
  bool _timerRunning = false;
  Timer? _timerTimer;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _startCounter() {
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

  void _stopCounter() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _resetCounter() {
    _stopCounter();
    totalTime += _seconds + _minutes*60 + _hours*3600;
    TimeManager.saveTime(totalTime);
    setState(() {
      _seconds = 0;
      _minutes = 0;
      _hours = 0;
    });
  }

  void _startTimer() {
    if (!_timerRunning && (_timerSeconds > 0 || _timerMinutes > 0 || _timerHours > 0)) {
      setState(() {
        _timerRunning = true;
      });
      
      _timerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timerSeconds > 0) {
            _timerSeconds--;
          } else {
            if (_timerMinutes > 0) {
              _timerMinutes--;
              _timerSeconds = 59;
            } else {
              if (_timerHours > 0) {
                _timerHours--;
                _timerMinutes = 59;
                _timerSeconds = 59;
              } else {
                _timerTimer?.cancel();
                _timerRunning = false;
              }
            }
          }
        });
      });
    }
  }

  void _stopTimer() {
    if (_timerRunning) {
      _timerTimer?.cancel();
      setState(() {
        _timerRunning = false;
      });
    }
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _timerSeconds = 0;
      _timerMinutes = 0;
      _timerHours = 0;
    });
  }

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
                      onPressed: _startCounter,
                      child: const Text('Başlat'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: _stopCounter,
                      child: const Text('Durdur'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: _resetCounter,
                      child: const Text('Sıfırla'),
                    ),
                  ],
                ),
              ],
            ),
          ),          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_formatNumber(_timerHours)}:${_formatNumber(_timerMinutes)}:${_formatNumber(_timerSeconds)}',
                  style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                if (!_timerRunning)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TimeSelector(
                        label: 'Saat',
                        value: _timerHours,
                        onChanged: (value) {
                          setState(() {
                            _timerHours = value;
                          });
                        },
                        minValue: 0,
                        maxValue: 23,
                      ),                      
                      TimeSelector(
                        label: 'Dakika',
                        value: _timerMinutes,
                        onChanged: (value) {
                          setState(() {
                            _timerMinutes = value;
                          });
                        },
                        minValue: 0,
                        maxValue: 59,
                      ),                      
                      TimeSelector(
                        label: 'Saniye',
                        value: _timerSeconds,
                        onChanged: (value) {
                          setState(() {
                            _timerSeconds = value;
                          });
                        },
                        minValue: 0,
                        maxValue: 59,
                      ),
                    ],
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
        ],
      ),
    );
  }
}
