class WeatherStatus {
  String name;
  double temp;
  Condition condition;

  WeatherStatus({
    required this.name,
    required this.temp,
    required this.condition,
  });

  factory WeatherStatus.fromJson(Map<String, dynamic> json) {
    return WeatherStatus(
      name: json['location']['name'],
      temp: json['current']['temp_c'],
      condition: Condition.fromJson(json['current']['condition']),
    );
  }
}

class Condition {
  String text;
  String icon;

  Condition({required this.text, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(text: json['text'], icon: 'https:${json['icon']}');
  }
}
