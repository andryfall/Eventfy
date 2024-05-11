import 'package:flutter/material.dart';
import 'package:mobpro/firebase_options.dart';
import 'home_page.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: "Poppins"
      ),
      home: const DismissKeyboard(
          child: HomePage()
      ),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}

class EventCardWithImage extends StatelessWidget {
  final Event event;
  final ImageProvider image;
  final VoidCallback onTap;

  EventCardWithImage({required this.event, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 5),
                Text(event.formattedDateTime()),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 5),
                Text(event.location),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class NavigationMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      decoration: BoxDecoration(
        color: Colors.red,
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('Profile'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bagian 1: Banner Wallpaper
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFB70000).withOpacity(0.8), 
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3), 
                        image: DecorationImage(
                          image: AssetImage("assets/images/cat.jpg"), 
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      'Walid, 20',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserat',
                      ),
                    ),
                   
                    Text(
                      'UI/UX Designer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Edit User Profile"),
                            Icon(Icons.edit),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("History Event"),
                            Icon(Icons.history),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late String previousMonth;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    previousMonth = DateFormat('MMMM').format(now);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MMMM').format(now);

    if (currentMonth != previousMonth) {
      previousMonth = currentMonth;

      String formattedDate = DateFormat('MMMM y').format(now);
      return Scaffold(
        appBar: AppBar(
          title: Text('History'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'History Page',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20), 
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFB70000).withOpacity(0.8), 
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display event cards
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return EventCardHistory(
                    event: events[index],
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('History'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'History Page',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20), 
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFB70000).withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                DateFormat('MMMM y').format(now),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display event cards
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return EventCardHistory(
                    event: events[index],
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}

class EventCardHistory extends StatelessWidget {
  final Event event;

  EventCardHistory({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 5),
                Text(event.formattedDateTime()),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 5),
                Text(event.location),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPage()));
        },
      ),
    );
  }
}

class AddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Addresses'),
      ),
      body: Center(
        child: Text('This is the Addresses Page'),
      ),
    );
  }
}


class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Page'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(
            event: events[index],
          );
        },
      ),
    );
  }
}



List<Event> events = [
  Event(
    id: '',
    title: 'Webinar flutter',
    dateAndTime: DateTime.now(),
    description: 'webinar flutter',
    location: 'TULT',
    price: '20.000',
    isReviewed: true,
  ),
  Event(
    id: '',
    title: 'Webinar Scrum Master',
    dateAndTime: DateTime.now(),
    description: 'webinar scrum master',
    location: 'GKU',
    price: '20.000',
    isReviewed: false,
  ),
];

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 5),
                Text(event.formattedDateTime()),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 5),
                Text(event.location),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: event.isReviewed ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            event.isReviewed ? 'Reviewed' : 'Pending',
            style: TextStyle(color: Colors.white),
          ),
        ),
        onTap: () {
          // Action when tapping on the card
        },
      ),
    );
  }
}


class EventPage extends StatelessWidget {
  final Event event;

  EventPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              event.title,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 10.0),
            Text('Date and Time: ${event.dateAndTime}'),
            SizedBox(height: 10.0),
            Text('Location: ${event.location}'),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Registration Success'),
                      content: Text('You have successfully registered for this event.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

