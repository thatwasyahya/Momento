import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/CreatedEvent.dart';
import '../utils/created_events_database.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _city;
  String? _date;
  String? _venue;
  File? _image;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      _showErrorDialog('Failed to pick image');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();

      final newEvent = CreatedEvent(
        name: _name!,
        city: _city!,
        date: _date!,
        venue: _venue!,
        imageUrl: _image!.path,
      );

      await CreatedEventDatabase.instance.create(newEvent);

      // Display a SnackBar notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event added successfully!'),
        ),
      );

      // Optionally, clear the form fields
      _formKey.currentState!.reset();
      setState(() {
        _image = null; // Clear the image
      });
    } else {
      _showErrorDialog('Please fill all fields and select an image.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
                onSaved: (value) {
                  _city = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                onSaved: (value) {
                  _date = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Venue'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a venue';
                  }
                  return null;
                },
                onSaved: (value) {
                  _venue = value;
                },
              ),
              SizedBox(height: 16.0),
              _image == null
                  ? Text('No image selected.')
                  : Image.file(_image!, height: 200.0),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
