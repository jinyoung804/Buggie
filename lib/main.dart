import 'package:flutter/material.dart';

import 'fruit_repository.dart'; // 데이터 저장 파일 불러오기
import 'screens/login_screen.dart';


void main() {
  runApp(const BuggieApp());
}

class BuggieApp extends StatelessWidget {
  const BuggieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

// 기능 테스트용 화면 (필요 시 임시 연결)
class TempTestScreen extends StatefulWidget {
  const TempTestScreen({super.key});

  @override
  State<TempTestScreen> createState() => _TempTestScreenState();
}

class _TempTestScreenState extends State<TempTestScreen> {
  int condition = 100; // freshness -> condition 으로 변경
  int bugs = 0;
  int totalTime = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 저장된 데이터 불러오기
  void _loadData() async {
    final data = await FruitRepository.getFruitData('apple');
    setState(() {
      condition = data['condition']!;
      bugs = data['bugs']!;
      totalTime = data['totalTime']!;
    });
  }

  // 10분 사용 테스트
  void _usePhone() async {
    final updated = await FruitRepository.updateUsage(
      fruitId: 'apple',
      addedMinutes: 10,
    );
    setState(() {
      condition = updated['condition']!;
      bugs = updated['bugs']!;
      totalTime = updated['totalTime']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기능 테스트용 화면')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('사과 상태(Condition): $condition%'),
            Text('벌레: $bugs마리'),
            Text('사용 시간: $totalTime분'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _usePhone,
              child: const Text('10분 사용 테스트'),
            ),
          ],
        ),
      ),
    );
  }
}