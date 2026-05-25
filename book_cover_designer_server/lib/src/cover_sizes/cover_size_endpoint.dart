import '../generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class CoverSizeEndpoint extends Endpoint {
  Future<List<CoverSize>> list(Session session) async {
    return CoverSize.db.find(
      session,
      where: (t) => t.isActive.equals(true),
      orderBy: (t) => t.sortOrder,
    );
  }
}
