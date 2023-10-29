import 'package:isar/isar.dart';
import 'package:my_library/book.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> saveBook(Book newBook) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.books.putSync(newBook));
  }

  Future<List<Book>> getAllBooks() async {
    final isar = await db;
    return await isar.books.where().findAll();
  }

  Stream<List<Book>> listenToBooks() async* {
    final isar = await db;
    yield* isar.books.where().watch(fireImmediately: true);
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<void> deleteBook(Book book) async {
    final isar = await db;
    await isar.writeTxn(() => isar.books.delete(book.id));
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [BookSchema],
        inspector: true,
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }
}
