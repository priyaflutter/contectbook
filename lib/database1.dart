import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
 //search sqflite in flutter

class datahelper{

  Future<Database>Getdatabase() async {
                                                                                                 
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'contect.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'create table Contectbook(id integer primary key autoincrement, name Text , number Text, image Text)');
        });
    return database;
  }

  Future<void> insertdata(String name1, String number1, Database database, String img) async {

    String insertqry="insert into Contectbook (name,number,image) values('$name1','$number1','$img')";

    int cnt=await database.rawInsert(insertqry);
    print(cnt);
  }

  Future<List<Map>> viewdata(Database database) async {

    String viewqry = "select * from Contectbook";

   List<Map> list = await database.rawQuery(viewqry);
    print(list);

           return list;

  }

  Future<void> deletedata(Database database, int id) async {

    String deleteqry="delete from Contectbook where id ='${id}'";
    int delete=await database.rawDelete(deleteqry);

    print("delete11111========${id}");


  }

  void editdata(String name1, String number1,Database database, int id, String newimg) {

    String updateqry="update Contectbook set name = '${name1}' , number = '${number1}' , imagepath = '${newimg}' where id = '${id}' ";

    database.rawUpdate(updateqry);
  }













}