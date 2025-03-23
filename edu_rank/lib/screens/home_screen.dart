import 'package:edu_rank/data/quizzes_data.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Main Screen'),
          SizedBox(height: 10),
          Text('Total Score: $totalScore points'),
          Text('Total Time: $totalTime seconds'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              Navigator.pushNamed(context, '/profile');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
            child: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
