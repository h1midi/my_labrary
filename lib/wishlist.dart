import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_library/book.dart';
import 'package:my_library/isar_services.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});
  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
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
        title: const Text('Wishlist'),
      ),
      body: StreamBuilder(
        stream: service.listenToBooks(),
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.hasData) {
            // filter the books to only show the ones with format wishlist
            List<Book> wishlist = snapshot.data!
                .where((element) => element.format == "wishlist")
                .toList();
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: wishlist.length,
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
                          child: Text(wishlist[index].coverUrl),
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
                        File(wishlist[index].coverUrl),
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
                                wishlist[index].format,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                wishlist[index].author,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // service.deleteBook(snapshot.data![index]);
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
