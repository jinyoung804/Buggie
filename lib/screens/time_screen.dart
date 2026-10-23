import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // 1. 게이지 상태 수치 (0.0 ~ 1.0) -> 숫자만 변경하면 상단 연두색 바 비율이 바뀝니다.
  double gaugeProgress = 0.75; // 예: 75%

  // 2. 고양이 시계 타이머 진행률 (0.0 ~ 1.0) -> 시간이 지날수록 주황색 영역이 늘어납니다.
  double timerProgress = 0.25
  ; // 예: 25% 진행 (90도 분량 차오름)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ==================== 배경 이미지 적용 영역 ====================
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/time_screen_background.png'), // <-- 배경 이미지 경로를 넣어주세요
            fit: BoxFit.cover, // 화면 전체를 채움
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                children: [
                  // ==================== 1. 상단 게이지 & 일시정지 버튼 ====================
                  Row(
                    children: [
                      // 상단 프로그레스 게이지
                      Expanded(
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFF299BF2), // 파란 배경 트랙
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF1D7CBD),
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                FractionallySizedBox(
                                  widthFactor: gaugeProgress.clamp(0.0, 1.0), // 게이지 비율
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8DE855), // 연두색 게이지
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      // 우측 일시정지 버튼 (클릭 가능 + 이미지 경로 적용)
                      GestureDetector(
                        onTap: () {
                          // 일시정지 버튼 클릭 시 동작할 이벤트를 여기에 작성하세요
                          print("Pause button clicked!");
                        },
                        child: Image.asset(
                          'assets/images/pause_button.png', // <-- 일시정지 버튼 이미지 경로를 넣어주세요
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10), // SingleChildScrollView 내부이므로 Spacer 대신 SizedBox 사용

                  // ==================== 2. 가운데 고양이 시계 ====================
                  Transform.translate(
                    offset: const Offset(0, -10), // Y축 이동
                    child: Center(
                      child: SizedBox(
                        width: 600,
                        height: 600,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Layer 1: 고양이 시계 바탕
                            Image.asset(
                              'assets/images/cat_clock.png',
                              width: 600,
                              height: 600,
                              fit: BoxFit.contain,
                            ),

                            // Layer 2: 주황색 부채꼴 게이지
                            Positioned(
                              left: 58,
                              child: SizedBox(
                                width: 265,
                                height: 265,
                                child: CustomPaint(
                                  painter: OrangeClockProgressPainter(progress: timerProgress),
                                ),
                              ),
                            ),

                            // Layer 3: 고양이 얼굴 표정
                            Positioned(
                              left: 143,
                              child: Image.asset(
                                'assets/images/cat_clock_face.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 1),

                  // ==================== 3. 하단 타이머 시계 카드 ====================
                  Transform.translate(
                    offset: const Offset(0, -100),
                    child: Container(
                      width: 260,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF43A3E2),
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/clock.png',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '08:24',
                                style: TextStyle(
                                  color: Color(0xFF51C0FF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '11:18',
                            style: TextStyle(
                              color: Color(0xFF2FA2FF),
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
                          ),
                          const Text(
                            'Timer',
                            style: TextStyle(
                              color: Color(0xFF75C7FF),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 고양이 시계 내부 주황색 게이지 그리기 (CustomPainter)
class OrangeClockProgressPainter extends CustomPainter {
  final double progress; // 0.0 ~ 1.0 (0% ~ 100%)

  OrangeClockProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFFFC076)
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    double startAngle = -pi / 2;
    double sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant OrangeClockProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}