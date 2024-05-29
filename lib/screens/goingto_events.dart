import 'package:flutter/material.dart';
import '../utils/GoingToEventDatabase.dart';
import '../models/GoingToEvent.dart';
import 'dart:io';

class GoingToEventsScreen extends StatefulWidget {
  @override
  _GoingToEventsScreenState createState() => _GoingToEventsScreenState();
}

class _GoingToEventsScreenState extends State<GoingToEventsScreen> {
  late Future<List<GoingToEvent>> _goingToEvents;

  @override
  void initState() {
    super.initState();
    _fetchGoingToEvents();
  }

  void _fetchGoingToEvents() {
    _goingToEvents = GoingToEventDatabase.instance.readAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Going To Events'),
      ),
      body: FutureBuilder<List<GoingToEvent>>(
        future: _goingToEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No going to events.'));
          } else {
            final goingToEvents = snapshot.data!;
            return ListView.builder(
              itemCount: goingToEvents.length,
              itemBuilder: (context, index) {
                final event = goingToEvents[index];
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
