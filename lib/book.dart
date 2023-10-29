import 'package:isar/isar.dart';

part 'book.g.dart';

@collection
class Book {
  Id id = Isar.autoIncrement;
  late String title;
  late String author;
  late String format;
  late String coverUrl;
}
