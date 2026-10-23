import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String imagePath = 'assets/images';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5BB7F2),
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: 390,
            height: 844,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // 하늘 배경
                Container(
                  color: const Color(0xFF5BB7F2),
                ),

                // 초록색 바닥
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 310,
                  child: Image.asset(
                    '$imagePath/grass.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // 맨 위 구름
                Positioned(
                  top: 18,
                  right: 12,
                  width: 135,
                  child: Image.asset(
                    '$imagePath/cloud_top.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // BUGGIE 로고
                Positioned(
                  top: 76,
                  left: 18,
                  right: 18,
                  height: 145,
                  child: Image.asset(
                    '$imagePath/buggie_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // 왼쪽 작은 구름
                Positioned(
                  top: 243,
                  left: -15,
                  width: 105,
                  child: Image.asset(
                    '$imagePath/cloud_small.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // 가운데 큰 구름
                Positioned(
                  top: 208,
                  right: -5,
                  width: 170,
                  child: Image.asset(
                    '$imagePath/cloud_middle.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // 나무와 튤립
                Positioned(
                  top: 326,
                  left: 0,
                  right: 0,
                  height: 285,
                  child: Image.asset(
                    '$imagePath/tree_flower.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // 사과를 든 고양이
                Positioned(
                  top: 278,
                  left: 58,
                  width: 330,
                  height: 380,
                  child: Image.asset(
                    '$imagePath/cat.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // 애벌레
                Positioned(

                  left: 30,
                  bottom: 150,
                  width: 170,
                  child: Image.asset(
                    '$imagePath/bugg.png',
                    fit: BoxFit.contain,
                  ),
                ),


                // 왼쪽 아래 잔디와 꽃
                Positioned(
                  left: 0,
                  bottom: 0,
                  width: 155,
                  child: Image.asset(
                    '$imagePath/left_grass.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomLeft,
                  ),
                ),

                // 오른쪽 아래 잔디와 꽃
                Positioned(
                  right: 0,
                  bottom: 0,
                  width: 150,
                  child: Image.asset(
                    '$imagePath/right_grass.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                  ),
                ),

                // 로그인, 회원가입 버튼
                Positioned(
                  left: 35,
                  right: 35,
                  bottom: 58,
                  child: Row(
                    children: [
                      Expanded(
                        child: _LoginButton(
                          text: 'login',
                          backgroundColor: Colors.white,
                          textColor: const Color(0xFF239EEB),
                          onTap: () {
                            // 로그인 화면으로 이동
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _LoginButton(
                          text: 'join',
                          backgroundColor: const Color(0xFF1CA7F5),
                          textColor: Colors.white,
                          onTap: () {
                            // 회원가입 화면으로 이동
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _LoginButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFF1689C9),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.only(bottom: 7),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 29,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}