import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'events.dart';
import 'profile.dart';
import '../models/user.dart';
import 'liked_events.dart';
import 'goingto_events.dart';
import 'create_event_screen.dart';


class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  int _selectedIndex = 2; // Home page selected by default

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      CreateEventScreen(),
      GoingToEventsScreen(),
      EventsScreen(city: ''),
      LikedEventsScreen(),
      ProfileScreen(user: widget.user),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _selectedIndex == 2
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 600,
          child: Column(
            children: [
              Container(
                width: 224.7,
                height: 170.7,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  // Optionally, you can set a border, borderRadius, etc.
                ),
                child: Stack(
                  children: [
                    // Image widget goes here
                    Image.asset(
                      'assets/images/city.png',
                      fit: BoxFit.cover,
                    ),
                    // You can add more widgets over the image here
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Positioned(
                left: 0,
                top: 180.25,
                child: SizedBox(
                  width: 390,
                  height: 26.25,
                  child: Text(
                    'Choose your City',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF597DDA),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CSCPicker(
                showStates: true,
                showCities: true,
                flagState: CountryFlag.DISABLE,
                dropdownDecoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.all(Radius.circular(10)),
                  color: Color(0xFF0DCDAA),
                ),
                countrySearchPlaceholder: "Country",
                stateSearchPlaceholder: "State",
                citySearchPlaceholder: "City",
                countryDropdownLabel: "*Country",
                stateDropdownLabel: "*State",
                cityDropdownLabel: "*City",
                selectedItemStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                dropdownHeadingStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                dropdownItemStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                dropdownDialogRadius: 10.0,
                searchBarRadius: 10.0,
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value ?? ""; // Provide default value
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value ?? ""; // Provide default value
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value ?? ""; // Provide default value
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    address = "$cityValue, $stateValue, $countryValue";
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventsScreen(city: cityValue),
                    ),
                  );
                },
                child: const Text("Show Events"),
              ),
            ],
          ),
        )
            : _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedIconTheme: IconThemeData(color: Color(0xFF0DCDAA)),
        unselectedItemColor: Color(0xFFFFFFFF),
        selectedLabelStyle: TextStyle(color: Colors.white), // Couleur des labels sélectionnés
        unselectedLabelStyle: TextStyle(color: Color(0xFF0DCDAA)), // Couleur des labels non sélectionnés
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Going',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Liked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
