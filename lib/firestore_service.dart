import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final CollectionReference events = FirebaseFirestore.instance.collection('/events');

  Future<void> addEvent({
    required String title,
    required String description,
    required DateTime dateAndTime,
    required String location,
    required String price,
    required bool isReviewed,
  }) async {
    try {
      await events.add({
        'title': title,
        'description': description,
        'dateAndTime': Timestamp.fromDate(dateAndTime),
        'location': location,
        'price': price,
        'isReviewed': false,
      });
    } catch (e) {
      throw 'Error adding event: $e';
    }
  }

  Future<List<Event>> getEvents() async {
    try {
      QuerySnapshot querySnapshot = await events.get();
      List<Event> eventsList = querySnapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();
      return eventsList;
    } catch (e) {
      throw 'Error fetching events: $e';
    }
  }

  Future<List<Event>> getEventsPaginated({required int pageNumber, required int pageSize}) async {
    try {
      QuerySnapshot querySnapshot = await events
          .orderBy('dateAndTime')
          .startAfter([Timestamp.fromDate(DateTime.now())])
          .limit(pageSize)
          .get();

      List<Event> eventsList = querySnapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();
      return eventsList;
    } catch (e) {
      throw 'Error fetching paginated events: $e';
    }
  }

  Future<void> updateEvent(String eventId, {
    String? title,
    String? description,
    String? location,
    String? price,
  }) async {
    try {
      await events.doc(eventId).update({
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (location != null) 'location': location,
        if (price != null) 'price': price,
      });
    } catch (e) {
      throw 'Error updating event: $e';
    }
  }

  Future<void> deleteEvent(Event event) async {
    try {
      await events.doc(event.id).delete();
    } catch (e) {
      throw 'Error deleting event: $e';
    }
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime dateAndTime;
  final String location;
  final String price;
  final bool isReviewed;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.dateAndTime,
    required this.location,
    required this.price,
    required this.isReviewed,
  });

  String formattedDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateAndTime);
  }

  factory Event.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Event(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      dateAndTime: (data['dateAndTime'] as Timestamp).toDate(),
      location: data['location'],
      price: data['price'],
      isReviewed: data['isReviewed']
    );
  }
}
