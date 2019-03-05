import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

Database db;

Future<Database> getApplicationDatabase() async {
  if (db != null) {
    return db;
  }

  db =await databaseFactoryIo.openDatabase(
    join((await getTemporaryDirectory()).path,'database','flutterplay.db')
  );
  return db;
}