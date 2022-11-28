import 'package:mysql_client/mysql_client.dart';

class Mysql {
  static String host = "10.0.2.2",
      user = "root",
      password = "admin",
      db = "shop_app";
  static int port = 3306;

  Mysql();

  Future<MySQLConnection> getConnection() async {
    print("Connecting to mysql server...");
    return await MySQLConnection.createConnection(
      host: "10.0.2.2",
      port: 3306,
      userName: "root",
      password: "admin",
      databaseName: "shop_app", // optional
    );

    //await conn.connect();

    // print("Connected");

    // var result = await conn.execute("select * from customers");

    // for (final row in result.rows) {
    //   //print(row.colAt(0));
    //   print(row.colByName("email"));

      // print all rows as Map<String, String>
      //print(row.assoc());
    }
  }
