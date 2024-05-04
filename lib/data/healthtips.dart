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
final List<HealthTips> healthTips = [
  HealthTips(
    title: 'Stay active',
    description:
        'Incorporate physical activity into your daily routine to improve cardiovascular health and boost mood.',
    imageUrl: 'assets/stay_active.png',
  ),
  HealthTips(
    title: 'Eat a balanced diet',
    description:
        'Consume a variety of fruits, vegetables, lean proteins, and whole grains for essential nutrients.',
    imageUrl: 'assets/1.png',
  ),
  HealthTips(
    title: 'Stay hydrated',
    description:
        'Drink plenty of water throughout the day to support digestion, circulation, and overall health.',
    imageUrl: 'assets/stay_hydrated.png',
  ),
  HealthTips(
    title: 'Get sufficient sleep',
    description:
        'Aim for 7-9 hours of quality sleep each night to rejuvenate your body and mind.',
    imageUrl: 'assets/sleep.png',
  ),
  HealthTips(
    title: 'manage stress',
    description:
        'Practice stress-reducing techniques such as deep breathing or meditation to alleviate tension.',
    imageUrl: 'assets/manage_stress.png',
  ),
  HealthTips(
    title: 'Limit sugar',
    description:
        'Minimize intake of sugary drinks.',
    imageUrl: 'assets/sugar-free.png',
  ),
   HealthTips(
    title: 'Avoid processed foods',
    description:
        'Processed snacks are causes for weight gain and energy crashes.',
    imageUrl: 'assets/smart-factory.png',
  ),
  HealthTips(
    title: 'Prioritize Mental Health',
    description:
        'Take time for self-care activities and seek support from loved ones or professionals when needed.',
    imageUrl: 'assets/mental-health.png',
  ),
  HealthTips(
    title: 'Practice Good Hygiene',
    description:
        'Maintain proper hygiene habits such as regular handwashing and dental care to prevent infections.',
    imageUrl: 'assets/hygiene.png',
  ),
  HealthTips(
    title: 'Stay Connected',
    description:
        'Foster meaningful relationships to cultivate a support network that enhances emotional resilience.',
    imageUrl: 'assets/network.png',
  ),
  HealthTips(
    title: 'Listen to Your Body',
    description:
        'Pay attention to your body\'s signals and respond appropriately by seeking medical attention.',
    imageUrl: 'assets/attention.png',
  ),
];
