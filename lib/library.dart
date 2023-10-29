import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_library/book.dart';
import 'package:my_library/isar_services.dart';

import 'wishlist.dart';

class Library extends StatefulWidget {
  const Library({super.key});
  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final service = IsarService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_book', arguments: service);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Wishlist();
              }));
            },
            icon: const Icon(Icons.shopping_bag_rounded),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: service.listenToBooks(),
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.hasData) {
            // filter the books to only show the ones with format own
            List<Book> own = snapshot.data!
                .where((element) => element.format == "own")
                .toList();
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: own.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Alert Dialog'),
                      content: Text('Item $index'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(own[index].coverUrl),
                        ),
                      ],
                    ),
                  );
                },
                child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAlias,
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(own[index].coverUrl),
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 50.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                own[index].title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                own[index].author,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // service.deleteBook(own[index]);
                    ]),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
