import 'package:flutter/material.dart';
import 'package:my_library/book.dart';
import 'package:my_library/camera.dart';

import 'isar_services.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});
  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  @override
  void initState() {
    super.initState();
  }

  final List<bool> _selections = List.generate(2, (_) => false);
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController formatController = TextEditingController();
  TextEditingController coverUrlController = TextEditingController();
  String format = 'own';
  @override
  Widget build(BuildContext context) {
    final service = ModalRoute.of(context)!.settings.arguments as IsarService;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: // create a form to add a book
            Form(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'Author',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ToggleButtons(
                isSelected: _selections,
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < _selections.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        _selections[buttonIndex] = !_selections[buttonIndex];
                        format = _selections[0] ? "own" : "wishlist";
                      } else {
                        _selections[buttonIndex] = false;
                      }
                    }
                  });
                },
                children: const <Widget>[
                  Icon(Icons.shelves),
                  Icon(Icons.shopping_bag_rounded),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  // add the book to the isar database
                  final newBook = Book()
                    ..author = authorController.text
                    ..format = format
                    ..title = titleController.text;
                  // clear the text fields
                  titleController.clear();
                  authorController.clear();
                  formatController.clear();
                  coverUrlController.clear();
                  // close the keyboard
                  FocusScope.of(context).unfocus();
                  // navigate to the library
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Camera(newBook: newBook, service: service),
                    ),
                  );
                  // await service.saveBook(newBook);
                },
                child: const Text('Take a picture'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
