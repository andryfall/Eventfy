import 'package:flutter/material.dart';
import 'main.dart';
import 'home_page.dart';
import 'calendar_page.dart';
import 'firestore_service.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final FirestoreService _firestoreService = FirestoreService();

  void _showDeleteConfirmationDialog(Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this event?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteEvent(event);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(Event event) async {
    try {
      await _firestoreService.deleteEvent(event);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Event deleted successfully"),
        ),
      );
      setState(() {}); // Refresh UI after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting event: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Uploaded Events'),
      ),
      body: FutureBuilder<List<Event>>(
        future: _firestoreService.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                if (event.title == 'placeholder') {
                  return SizedBox.shrink();
                }
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.formattedDateTime()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditEventPage(event)),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(event);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle onTap event if needed
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUploadEvent()),
          );
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              icon: Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),
                );
              },
              icon: Icon(Icons.calendar_month),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddressPage()),
                );
              },
              icon: Icon(Icons.map_outlined),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewPage()),
                );
              },
              icon: Icon(Icons.star),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class AddUploadEvent extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ValueNotifier<DateTime?> startDateController =
      ValueNotifier<DateTime?>(null);
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        final DateTime combinedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        startDateController.value = combinedDateTime;
      }
    }
  }

  void _submitEvent(BuildContext context) async {
    String title = titleController.text;
    String description = descriptionController.text;
    DateTime? dateAndTime = startDateController.value;
    String location = locationController.text;
    String price = priceController.text;

    if (dateAndTime == null) {
      return;
    }

    try {
      await _firestoreService.addEvent(
        title: title,
        description: description,
        dateAndTime: dateAndTime,
        location: location,
        price: price,
        isReviewed: false,
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            InkWell(
              onTap: () => _selectStartDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Start Date',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(startDateController.value?.toString() ??
                        'Select Start Date'),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
              ),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitEvent(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditEventPage extends StatefulWidget {
  final Event event;

  EditEventPage(this.event);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.event.title;
    descriptionController.text = widget.event.description;
    locationController.text = widget.event.location;
    priceController.text = widget.event.price;
  }

  void _submitChanges(BuildContext context) async {
    String title = titleController.text;
    String description = descriptionController.text;
    String location = locationController.text;
    String price = priceController.text;

    try {
      await _firestoreService.updateEvent(
        widget.event.id,
        title: title,
        description: description,
        location: location,
        price: price,
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error updating event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
              ),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitChanges(context),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}