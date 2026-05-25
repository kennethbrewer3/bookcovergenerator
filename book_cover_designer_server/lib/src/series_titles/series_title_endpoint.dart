import '../generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class SeriesTitleEndpoint extends Endpoint {
  Future<List<SeriesTitle>> list(Session session) async {
    return SeriesTitle.db.find(
      session,
      where: (t) => t.isActive.equals(true),
      orderBy: (t) => t.sortName,
    );
  }

  Future<SeriesTitle> create(Session session, String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw Exception('Series title is required.');
    }

    final existingSeriesTitles = await SeriesTitle.db.find(
      session,
      where: (t) => t.sortName.equals(trimmedName.toLowerCase()),
      limit: 1,
    );

    if (existingSeriesTitles.isNotEmpty) {
      final existingSeriesTitle = existingSeriesTitles.first;
      if (existingSeriesTitle.isActive) return existingSeriesTitle;

      existingSeriesTitle.isActive = true;
      existingSeriesTitle.name = trimmedName;
      existingSeriesTitle.sortName = trimmedName.toLowerCase();
      await SeriesTitle.db.updateRow(session, existingSeriesTitle);
      return existingSeriesTitle;
    }

    return SeriesTitle.db.insertRow(
      session,
      SeriesTitle(
        name: trimmedName,
        sortName: trimmedName.toLowerCase(),
        createdAt: DateTime.now(),
        isActive: true,
      ),
    );
  }

  Future<void> clear(Session session) async {
    await SeriesTitle.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
  }
}
