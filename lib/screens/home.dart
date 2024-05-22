import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'events.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Container(
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Handle navigation based on index
        },
        selectedIconTheme: IconThemeData(color: Color(0xFF0DCDAA)),
        unselectedItemColor: Color(0xFFFFFFFF),
        items: <BottomNavigationBarItem>[
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
            label: 'Event',
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
