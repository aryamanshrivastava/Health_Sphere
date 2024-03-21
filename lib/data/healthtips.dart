// ignore_for_file: public_member_api_docs, sort_constructors_first
class HealthTips {
  final String title;
  final String description;
  final String imageUrl;
  HealthTips({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

//data
final List<HealthTips> healthTips = [
  HealthTips(
    title: 'Healthy Eating',
    description:
        'A healthy diet is a solution to many of our health-care problems. It\'s the most important solution.',
    imageUrl: 'assets/1.png',
  ),
  HealthTips(
    title: 'Exercise',
    description:
        'Exercise is king. Nutrition is queen. Put them together and you\'ve got a kingdom.',
    imageUrl: 'assets/1.png',
  ),
  HealthTips(
    title: 'Mental Health',
    description:
        'Mental health...is not a destination, but a process. It\'s about how you drive, not where you\'re going.',
    imageUrl: 'assets/mental_health.jpg',
  ),
  HealthTips(
    title: 'Sleep',
    description:
        'Sleep is that golden chain that ties health and our bodies together.',
    imageUrl: 'assets/sleep.jpg',
  ),
  HealthTips(
    title: 'Hydration',
    description:
        'Drinking water is like washing out your insides. The water will cleanse the system, fill you up, decrease your caloric load and improve the function of all your tissues.',
    imageUrl: 'assets/hydration.jpg',
  ),
  HealthTips(
    title: 'Stress Management',
    description:
        'The greatest weapon against stress is our ability to choose one thought over another.',
    imageUrl: 'assets/stress_management.jpg',
  ),
  HealthTips(
    title: 'Social Connection',
    description:
        'The people who help you maintain a healthy lifestyle are the ones you should be spending the most time with.',
    imageUrl: 'assets/social_connection.jpg',
  ),
  HealthTips(
    title: 'Healthy Habits',
    description: 'The groundwork of all happiness is health.',
    imageUrl: 'assets/healthy_habits.jpg',
  ),
];