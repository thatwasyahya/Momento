class CreatedEvent {
  final String name;
  final String city;
  final String date;
  final String venue;
  final String imageUrl;

  CreatedEvent({
    required this.name,
    required this.city,
    required this.date,
    required this.venue,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'city': city,
      'date': date,
      'venue': venue,
      'imageUrl': imageUrl,
    };
  }
}