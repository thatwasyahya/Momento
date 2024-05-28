import 'package:flutter/material.dart';
import '../utils/LikedEventDatabase.dart';
import '../models/LikedEvent.dart';


class LikedEventsScreen extends StatefulWidget {
  @override
  _LikedEventsScreenState createState() => _LikedEventsScreenState();
}

class _LikedEventsScreenState extends State<LikedEventsScreen> {
  late Future<List<LikedEvent>> _likedEvents;

  @override
  void initState() {
    super.initState();
    _fetchLikedEvents();
  }

  void _fetchLikedEvents() {
    _likedEvents = LikedEventDatabase.instance.readAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Events'),
      ),
      body: FutureBuilder<List<LikedEvent>>(
        future: _likedEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No liked events.'));
          } else {
            final likedEvents = snapshot.data!;
            return ListView.builder(
              itemCount: likedEvents.length,
              itemBuilder: (context, index) {
                final event = likedEvents[index];
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
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
