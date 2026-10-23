import 'package:flutter/material.dart';

class SelectFruitScreen extends StatefulWidget {
  const SelectFruitScreen({super.key});

  @override
  State<SelectFruitScreen> createState() => _SelectFruitScreenState();
}

class _SelectFruitScreenState extends State<SelectFruitScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 선택된 과일의 인덱스 (기본값: 0번 블루베리 선택 상태)
  int selectedIndex = 0;

  // 각 과일 카드의 이미지 경로 데이터 목록
  final List<String> fruitImages = [
    'assets/images/blueberry.png', // 0: 블루베리
    'assets/images/cherry.png',    // 1: 체리
    'assets/images/peach.png',     // 2: 복숭아
    'assets/images/kiwi.png',      // 3: 키위
    'assets/images/tomato.png',    // 4: 토마토
    'assets/images/mango.png',     // 5: 망고
    'assets/images/watermelon.png',// 6: 수박
    'assets/images/grape.png',     // 7: 포도
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9F1FF), // 밝은 하늘색 배경
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF4FC3F7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        title: const Text(
          'FRUIT SHOP',
          style: TextStyle(
            color: Color(0xFF29B6F6),
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF2EACFF), size: 30),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Stack(
            clipBehavior: Clip.none, // 흰색 박스 바깥(하단)으로 삐져나가는 바를 자르지 않음
            children: [
              // 1. 흰색 TabBar 배경
              Container(
                height: 48,
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.transparent, // 기본 인디케이터 숨김
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: 'common'),
                    Tab(text: 'legendary'),
                    Tab(text: 'more'),
                  ],
                ),
              ),

              // 2. 흰색 상자 하단 경계선에 딱 걸쳐있는 파란색 선(인디케이터)
              Positioned(
                bottom: -4, // 👈 바 높이(6px)의 절반만큼 아래로 내리면 경계선 중앙에 반씩 걸쳐집니다!
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _tabController.animation!,
                  builder: (context, child) {
                    double tabWidth = MediaQuery.of(context).size.width / 3;
                    double leftOffset = _tabController.animation!.value * tabWidth;

                    return Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: leftOffset),
                      child: Container(
                        width: tabWidth,
                        alignment: Alignment.center,
                        child: Container(
                          width: 80, // 바의 가로 길이를 원하시는 대로 조정하세요
                          height: 8,  // 바의 두께
                          decoration: BoxDecoration(
                            color: const Color(0xFF66C2FF), // 진하늘색
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // ==================== 1. 과일 그리드 리스트 ====================
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: fruitImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 23,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final bool isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF29B6F6)
                            : Colors.transparent,
                        width: isSelected ? 5.5 : 0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFD7D7D7),
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Image.asset(
                        fruitImages[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ==================== 2. 하단 NEXT 버튼 ====================
            SizedBox(
              width: double.infinity,
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2EACFF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF0288D1),
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    print("Selected fruit index: $selectedIndex");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}