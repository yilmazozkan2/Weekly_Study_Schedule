import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper{

  Future<Database> initilizaeDb() async {
    Future<Database> db = openDatabase(
        join(await getDatabasesPath(), 'dbprogram.db'), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE TABLO1 (ID INTEGER PRIMARY KEY AUTOINCREMENT, DERS TEXT, SORUSAYI INTEGER, TOPLAMHAFTALIK TEXT)');
    }, version: 1);

    return db;
  }
  Future<void> insertItemsToDb(ders, sorusayi, toplamHaftalik) async{
    Database db = await initilizaeDb();
    await db.transaction((txn) {
      return txn.rawInsert("INSERT INTO TABLO1(DERS, SORUSAYI,TOPLAMHAFTALIK) VALUES('$ders', $sorusayi, $toplamHaftalik)");
    }
    );
    print('the item has been added');
  }
  Future<List> retreiveItemsFromDb() async{
    Database db = await initilizaeDb();
    return db.rawQuery('SELECT * FROM TABLO1 ');
  }

  Future<List> deleteItemDb(id) async{
    Database db = await initilizaeDb();
    return db.rawQuery('DELETE FROM TABLO1 WHERE ID=$id');
  }

  Future<List> deleteTable() async{
    Database db = await initilizaeDb();
    return db.rawQuery('DELETE FROM TABLO1');
  }
}