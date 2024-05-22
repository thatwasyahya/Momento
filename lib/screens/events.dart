import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Event {
  final String name;
  final String date;
  final String venue;
  String imageUrl;

  Event({
    required this.name,
    required this.date,
    required this.venue,
    required this.imageUrl,
  });
}

class EventsScreen extends StatefulWidget {
  final String city;

  EventsScreen({required this.city});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Event> events = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
    });

    final String ticketmasterApiKey = "cGVyMAfEGcU1SFEKnQRtxpT95Tiq8rIl";
    final String unsplashApiKey = "bW9iqrbPv9TxhduWGR-yP0LFmIjACVVd-qvrhGmfTx0";
    final String city = widget.city;

    final ticketmasterUrl =
        'https://app.ticketmaster.com/discovery/v2/events.json?apikey=$ticketmasterApiKey&city=$city';

    try {
      final ticketmasterResponse = await http.get(Uri.parse(ticketmasterUrl));

      if (ticketmasterResponse.statusCode == 200) {
        final ticketmasterData = json.decode(ticketmasterResponse.body);
        final List<dynamic> eventsData = ticketmasterData['_embedded']['events'];

        events = await Future.wait(eventsData.map((event) async {
          final eventName = event['name'];
          final eventDate = event['dates']['start']['localDate'];
          final eventVenue = event['_embedded']['venues'][0]['name'];
          final eventImageUrl = await fetchEventImage(eventName, unsplashApiKey);
          return Event(
            name: eventName,
            date: eventDate,
            venue: eventVenue,
            imageUrl: eventImageUrl,
          );
        }));

        setState(() {
          isLoading = false;
        });
      } else {
        print('Failed to load events: ${ticketmasterResponse.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Exception occurred: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> fetchEventImage(String eventName, String unsplashApiKey) async {
    final unsplashUrl =
        'https://api.unsplash.com/search/photos?query=$eventName&per_page=1&page=1';

    try {
      final response = await http.get(
        Uri.parse(unsplashUrl),
        headers: {'Authorization': 'Client-ID $unsplashApiKey'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> photos = data['results'];

        if (photos.isNotEmpty) {
          final photo = photos[0];
          return photo['urls']['regular'];
        } else {
          print('No photos found for $eventName');
          return ''; // Return empty string if no photos found
        }
      } else {
        print('Failed to load event image: ${response.statusCode}');
        return ''; // Return empty string if image loading fails
      }
    } catch (e) {
      print('Exception occurred while fetching event image: $e');
      return ''; // Return empty string if exception occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events in ${widget.city}'),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : events.isEmpty
          ? Center(
        child: Text('No events found.'),
      )
          : ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return EventCard(event: event);
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            event.imageUrl,
            fit: BoxFit.cover,
            height: 200.0,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text('Date: ${event.date}\nVenue: ${event.venue}'),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {
                        // Handle like button tap
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        // Handle save button tap
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.event),
                      onPressed: () {
                        // Handle going button tap
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
