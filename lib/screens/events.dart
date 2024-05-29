import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/LikedEvent.dart';
import '../utils/LikedEventDatabase.dart';
import '../models/GoingToEvent.dart';
import '../utils/GoingToEventDatabase.dart';
import '../utils/created_events_database.dart';
import 'create_event_screen.dart';
import '../models/CreatedEvent.dart';
import 'package:share/share.dart';

class Event {
  final String name;
  final String date;
  final String city;
  final String venue;
  String imageUrl;

  Event({
    required this.name,
    required this.date,
    required this.city,
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
  List<CreatedEvent> createdEvents = [];
  bool isLoading = false;
  Map<String, bool> likedStatus = {};
  Map<String, bool> goingToStatus = {};

  @override
  void initState() {
    super.initState();
    fetchEvents();
    fetchCreatedEvents();
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
            city: city,
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

  Future<void> fetchCreatedEvents() async {
    createdEvents = await CreatedEventDatabase.instance.readAllEvents();
    print('Created events fetched: $createdEvents');
    setState(() {});
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

  Future<void> _likeEvent(Event event) async {
    final likedEvent = LikedEvent(
      name: event.name,
      date: event.date,
      venue: event.venue,
      imageUrl: event.imageUrl,
    );
    await LikedEventDatabase.instance.create(likedEvent);
    setState(() {
      likedStatus[event.name] = true;
    });
  }

  Future<void> _goingtoEvent(Event event) async {
    final goingtoEvent = GoingToEvent(
      name: event.name,
      date: event.date,
      venue: event.venue,
      imageUrl: event.imageUrl,
    );
    await GoingToEventDatabase.instance.create(goingtoEvent);
    setState(() {
      goingToStatus[event.name] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter created events by the city selected in EventsScreen
    final filteredCreatedEvents = createdEvents
        .where((event) => event.city.toLowerCase() == widget.city.toLowerCase())
        .map((createdEvent) => Event(
      name: createdEvent.name,
      city: createdEvent.city,
      date: createdEvent.date,
      venue: createdEvent.venue,
      imageUrl: createdEvent.imageUrl,
    ))
        .toList();

    print('Filtered created events: $filteredCreatedEvents');

    final allEvents = [...filteredCreatedEvents, ...events];

    return Scaffold(
      appBar: AppBar(
        title: Text('Events in ${widget.city}'),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : allEvents.isEmpty
          ? Center(
        child: Text('No events found.'),
      )
          : ListView.builder(
        itemCount: allEvents.length,
        itemBuilder: (context, index) {
          final event = allEvents[index];
          final isLiked = likedStatus[event.name] ?? false;
          final isGoingTo = goingToStatus[event.name] ?? false;

          return Card(
            color: Colors.white.withOpacity(0.8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                event.imageUrl.isNotEmpty
                    ? (event.imageUrl.startsWith('http')
                    ? Image.network(
                  event.imageUrl,
                  fit: BoxFit.cover,
                  height: 200.0,
                )
                    : Image.file(
                  File(event.imageUrl),
                  fit: BoxFit.cover,
                  height: 200.0,
                ))
                    : Image.asset(
                  'assets/images/default_image.png',
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
                            icon: Icon(
                              Icons.favorite,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              await _likeEvent(event);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${event.name} liked!')),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.event,
                              color: isGoingTo ? Colors.green : Colors.grey,
                            ),
                            onPressed: () async {
                              await _goingtoEvent(event);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${event.name} Going To!')),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Share.share('Check out this event: ${event.name} happening on ${event.date} at ${event.venue}!');
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
        },
      ),
    );
  }
}
