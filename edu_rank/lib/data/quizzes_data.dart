import 'package:edu_rank/models/quiz.dart';
import 'package:edu_rank/models/quiz_question.dart';

var quizzes = [
  Quiz(
    1,
    'Math Basics',
    'https://news.harvard.edu/wp-content/uploads/2022/11/iStock-mathproblems.jpg',
    [
      QuizQuestion(
        '3x17=?',
        [
          '51',
          '41',
          '49',
          '53',
        ],
      ),
      QuizQuestion(
        '18x12=?',
        [
          '216',
          '256',
          '214',
          '244',
        ],
      ),
      QuizQuestion(
        '312/26=?',
        [
          '12',
          '22',
          '18',
          '16',
        ],
      ),
      QuizQuestion(
        '18x3-16/4=?',
        [
          '50',
          '38',
          '48',
          '46',
        ],
      ),
      QuizQuestion(
        '14x14/7=?',
        [
          '28',
          '48',
          '38',
          '56',
        ],
      ),
      QuizQuestion(
        '169/13+17=?',
        [
          '30',
          '31',
          '32',
          '33',
        ],
      ),
    ],
  ),
  Quiz(
    2,
    'English Vocabulary',
    'https://www.novakidschool.com/blog/wp-content/uploads/2022/06/unnamed-1.webp',
    [
      QuizQuestion(
        'What is the synonym of "happy"?',
        [
          'Joyful',
          'Sad',
          'Angry',
          'Tired',
        ],
      ),
      QuizQuestion(
        'What is the opposite of "cold"?',
        [
          'Hot',
          'Freezing',
          'Wet',
          'Cool',
        ],
      ),
      QuizQuestion(
        'Which word means "a place where books are kept"?',
        [
          'Library',
          'Hospital',
          'School',
          'Theater',
        ],
      ),
      QuizQuestion(
        'Which word is a verb?',
        [
          'Eat',
          'Beautiful',
          'Quickly',
          'Happy',
        ],
      ),
      QuizQuestion(
        'What is the plural of "child"?',
        [
          'Children',
          'Childs',
          'Childes',
          'Childrens',
        ],
      ),
    ],
  ),
  Quiz(
    3,
    'Capitals',
    'https://cdn.myikas.com/images/16150df7-ec89-4f31-9fbe-4ecb06279433/5a34cb10-1e60-44dc-8777-fc3a8e13c8ff/3840/4543523423.webp',
    [
      QuizQuestion(
        'What is the capital of France?',
        [
          'Paris',
          'Rome',
          'Berlin',
          'Madrid',
        ],
      ),
      QuizQuestion(
        'What is the capital of Japan?',
        [
          'Tokyo',
          'Beijing',
          'Seoul',
          'Bangkok',
        ],
      ),
      QuizQuestion(
        'What is the capital of Canada?',
        [
          'Ottawa',
          'Toronto',
          'Vancouver',
          'Montreal',
        ],
      ),
      QuizQuestion(
        'What is the capital of Australia?',
        [
          'Canberra',
          'Sydney',
          'Melbourne',
          'Brisbane',
        ],
      ),
      QuizQuestion(
        'What is the capital of Brazil?',
        [
          'Brasília',
          'Rio de Janeiro',
          'São Paulo',
          'Buenos Aires',
        ],
      ),
    ],
  ),
  Quiz(
    4,
    'Science',
    'https://platform.vox.com/wp-content/uploads/sites/2/chorus/uploads/chorus_asset/file/15414153/shutterstock_172355312.0.0.1435352379.jpg?quality=90&strip=all&crop=0%2C9.7745324109659%2C100%2C80.450935178068&w=2400',
    [
      QuizQuestion(
        'What planet is known as the Red Planet?',
        [
          'Mars',
          'Venus',
          'Jupiter',
          'Saturn',
        ],
      ),
      QuizQuestion(
        'What do humans breathe in to survive?',
        [
          'Oxygen',
          'Carbon Dioxide',
          'Nitrogen',
          'Hydrogen',
        ],
      ),
      QuizQuestion(
        'What is H2O commonly known as?',
        [
          'Water',
          'Oxygen',
          'Salt',
          'Carbon Dioxide',
        ],
      ),
      QuizQuestion(
        'What is the closest star to Earth?',
        [
          'The Sun',
          'The Moon',
          'Alpha Centauri',
          'Sirius',
        ],
      ),
      QuizQuestion(
        'How many senses do humans have?',
        [
          'Five',
          'Three',
          'Seven',
          'Four',
        ],
      ),
    ],
  ),
  Quiz(
    5,
    'General Knowledge',
    'https://www.challies.com/media/2022/08/AdobeStock_243388799-1.jpeg',
    [
      QuizQuestion(
        'Who painted the Mona Lisa?',
        [
          'Leonardo da Vinci',
          'Vincent van Gogh',
          'Pablo Picasso',
          'Claude Monet',
        ],
      ),
      QuizQuestion(
        'What is the largest ocean on Earth?',
        [
          'Pacific Ocean',
          'Atlantic Ocean',
          'Indian Ocean',
          'Arctic Ocean',
        ],
      ),
      QuizQuestion(
        'How many continents are there?',
        [
          'Seven',
          'Five',
          'Six',
          'Eight',
        ],
      ),
      QuizQuestion(
        'What is the name of the longest river in the world?',
        [
          'Nile River',
          'Amazon River',
          'Yangtze River',
          'Mississippi River',
        ],
      ),
      QuizQuestion(
        'Which planet is closest to the Sun?',
        [
          'Mercury',
          'Venus',
          'Mars',
          'Earth',
        ],
      ),
    ],
  ),
  Quiz(
    6,
    'Technology & Computers',
    'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?q=80&w=2669&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    [
      QuizQuestion(
        'What does "CPU" stand for?',
        [
          'Central Processing Unit',
          'Computer Power Unit',
          'Core Processing Utility',
          'Central Performance Unit',
        ],
      ),
      QuizQuestion(
        'Which one is an operating system?',
        [
          'Linux',
          'Python',
          'HTML',
          'Google Chrome',
        ],
      ),
      QuizQuestion(
        'What is the main function of RAM?',
        [
          'Temporary data storage for quick access',
          'Long-term data storage',
          'Graphics processing',
          'Power supply management',
        ],
      ),
      QuizQuestion(
        'Which programming language is primarily used for web development?',
        [
          'JavaScript',
          'C++',
          'Java',
          'Swift',
        ],
      ),
      QuizQuestion(
        'What does "HTML" stand for?',
        [
          'HyperText Markup Language',
          'HighTech Machine Learning',
          'Hyperlink and Text Management Language',
          'Home Tool Management Library',
        ],
      ),
    ],
  ),
];
