class GoingToEvent {
  final String name;
  final String date;
  final String venue;
  final String imageUrl;

  GoingToEvent({required this.name, required this.date, required this.venue, required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'venue': venue,
      'imageUrl': imageUrl,
    };
  }
}