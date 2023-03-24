import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: ' Home Page'),
        routes: {
          '/new-contact': (context) => const NewContactView(),
        });
  }
}

//single tone class
class Contact {
  final String name;
  final String id;
  Contact({required this.name}) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInsetance()
      : super([Contact(name: 'Sajjad'), Contact(name: 'Samina')]);

  static final ContactBook _shared = ContactBook._sharedInsetance();

  factory ContactBook() => _shared;

  final List<Contact> _contacts = [];

  // int get length => _contacts.length;
  int get length => value.length;

  void add({required Contact contact}) {
    // _contacts.add(contact);
    // value.add(contact);

    final contacts = value;
    contacts.add(contact);
    // value = contacts;
    notifyListeners();
  }

  void remove({required Contact contact}) {
    //_contacts.remove(contact);
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.add(contact);
      notifyListeners();
    }
  }

  Contact? contact({required int atIndex}) =>
      // _contacts.length > atIndex ? _contacts[atIndex] : null;
      value.length > atIndex ? value[atIndex] : null;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ValueListenableBuilder(
          valueListenable: ContactBook(),
          builder: (contact, value, child) {
            final contacts = value as List<Contact>;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];

                return Dismissible(
                  onDismissed: (direction) {
                    contacts.remove(contact);
                    //ContactBook().remove(contact: contact);
                    //when this use the error is occred
                  },
                  key: ValueKey(contact.id),
                  child: Material(
                    color: Colors.blue,
                    elevation: 5.0,
                    child: ListTile(
                      title: Text(contact.name),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/new-contact');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Contact')),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
                hintText: 'Enter your name please.............'),
          ),
          TextButton(
              onPressed: () {
                final contact = Contact(name: _controller.text);
                ContactBook().add(contact: contact);
                Navigator.of(context).pop();
              },
              child: const Text('Add Contact'))
        ],
      ),
    );
  }
}
