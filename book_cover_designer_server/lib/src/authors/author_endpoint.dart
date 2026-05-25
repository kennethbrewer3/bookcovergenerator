import '../generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class AuthorEndpoint extends Endpoint {
  Future<List<Author>> list(Session session) async {
    return Author.db.find(
      session,
      where: (t) => t.isActive.equals(true),
      orderBy: (t) => t.sortName,
    );
  }

  Future<Author> create(Session session, String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw Exception('Author name is required.');
    }

    final existingAuthors = await Author.db.find(
      session,
      where: (t) => t.sortName.equals(trimmedName.toLowerCase()),
      limit: 1,
    );

    if (existingAuthors.isNotEmpty) {
      final existingAuthor = existingAuthors.first;
      if (existingAuthor.isActive) return existingAuthor;

      existingAuthor.isActive = true;
      existingAuthor.name = trimmedName;
      existingAuthor.sortName = trimmedName.toLowerCase();
      await Author.db.updateRow(session, existingAuthor);
      return existingAuthor;
    }

    return Author.db.insertRow(
      session,
      Author(
        name: trimmedName,
        sortName: trimmedName.toLowerCase(),
        createdAt: DateTime.now(),
        isActive: true,
      ),
    );
  }

  Future<void> clear(Session session) async {
    await Author.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
  }
}
