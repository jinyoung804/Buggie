import 'package:shared_preferences/shared_preferences.dart';

class FruitRepository {
  // 데이터 불러오기
  static Future<Map<String, int>> getFruitData(String fruitId) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'condition': prefs.getInt('${fruitId}_condition') ?? 100,
      'bugs': prefs.getInt('${fruitId}_bugs') ?? 0,
      'totalTime': prefs.getInt('total_usage_time') ?? 0,
    };
  }

  // 데이터 저장 및 업데이트
  static Future<Map<String, int>> updateUsage({
    required String fruitId,
    required int addedMinutes,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    int currentCondition = prefs.getInt('${fruitId}_condition') ?? 100;
    int currentBugs = prefs.getInt('${fruitId}_bugs') ?? 0;
    int currentTotalTime = prefs.getInt('total_usage_time') ?? 0;

    //밑에꺼 바꾸면 썩는 시간 수정 가능
    int newCondition = (currentCondition - (addedMinutes / 10 * 5).toInt()).clamp(0, 100);
    int newBugs = currentBugs + (addedMinutes / 10).toInt();
    int newTotalTime = currentTotalTime + addedMinutes;


    await prefs.setInt('${fruitId}_condition', newCondition);
    await prefs.setInt('${fruitId}_bugs', newBugs);
    await prefs.setInt('total_usage_time', newTotalTime);

    return {
      'Condition': newCondition,
      'bugs': newBugs,
      'totalTime': newTotalTime,
    };
  }
}