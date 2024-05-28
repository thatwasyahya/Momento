import 'package:flutter/material.dart';
import '../utils/GoingToEventDatabase.dart';
import '../models/GoingToEvent.dart';


class GoingToEventsScreen extends StatefulWidget {
  @override
  _GoingToEventsScreenState createState() => _GoingToEventsScreenState();
}

class _GoingToEventsScreenState extends State<GoingToEventsScreen> {
  late Future<List<GoingToEvent>> _goingtoEvents;

  @override
  void initState() {
    super.initState();
    _fetchGoingToEvents();
  }

  void _fetchGoingToEvents() {
    _goingtoEvents = GoingToEventDatabase.instance.readAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoingTo Events'),
      ),
      body: FutureBuilder<List<GoingToEvent>>(
        future: _goingtoEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No goingto events.'));
          } else {
            final goingtoEvents = snapshot.data!;
            return ListView.builder(
              itemCount: goingtoEvents.length,
              itemBuilder: (context, index) {
                final event = goingtoEvents[index];
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
