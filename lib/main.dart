import 'dart:io';

import 'package:contectbook/database1.dart';
import 'package:contectbook/editpage.dart';
import 'package:contectbook/secondpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: book(),
  ));
}

class book extends StatefulWidget {
  const book({Key? key}) : super(key: key);

  @override
  State<book> createState() => _bookState();
}

class _bookState extends State<book> {
  Database? db;
  List<Map> mm = [];
  List<Map> searchlist = [];
  bool search = false;
  int? id;
  String image = "";



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getalldata();
  }

  Future<void> getalldata() async {
    datahelper().Getdatabase().then((value) {
      setState(() {
        db = value;
      });

      datahelper().viewdata(db!).then((listofmap) {
        setState(() {
          mm = listofmap;
        });
      });
    });

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    double theight = MediaQuery.of(context).size.height;
    double twidth = MediaQuery.of(context).size.width;
    double tstatusbar = MediaQuery.of(context).padding.top;
    double tNavigator = MediaQuery.of(context).padding.bottom;
    double tappbar = kToolbarHeight;

    double tbodyheight = theight - tstatusbar - tNavigator - tappbar;

    return Scaffold(    
      appBar: AppBar(
        backgroundColor: Color(0xff020b26),
        title: Text("Contect"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color(0xff020b26),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return second();
              },
            ));
          },
          label: Container(
            child: Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 30,
                ),
                Text(
                  "Add Contect",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, tbodyheight * 0.01, 0, 0),
              height: tbodyheight * 0.07,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      searchlist = [];
                      for (int i = 0; i < mm.length; i++) {
                        if (mm[i]['name']
                            .toString()
                            .toLowerCase()
                            .contains(value.toString().toLowerCase())) {
                          searchlist.add(mm[i]);
                        }
                      }
                    } else {
                      searchlist = mm;
                    }
                  });
                },
                decoration: InputDecoration(
                    labelText: "Search Contacts",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            search = true;
                          });
                        },
                        icon: Icon(Icons.search)),
                    border: OutlineInputBorder()),
              ),
            ),
            Container(
              height: tbodyheight * 0.80,
              child: RefreshIndicator(
                onRefresh: getalldata,
                child: ListView.builder(
                  itemCount: search ? searchlist.length : mm.length,
                  itemBuilder: (context, index) {
                    Map map = search ? searchlist[index] : mm[index];
                    return ListTile(
                        onTap: () {
                          setState(() {});
                        },
                        title: Text("${map['name']}"),
                        subtitle: Text("${mm[index]['number']}"),
                        leading: mm[index]['image'] != ""
                            ? Container(
                                height: 100,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(
                                            File("${mm[index]['image']}")))),
                              )
                            : CircleAvatar(
                                backgroundImage: AssetImage("images/front.png"),
                                maxRadius: 30,
                              ),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 0) {
                              print(value);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return editpage1(mm[index], db!);
                                },
                              ));
                            } else {}
                          },
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                onTap: () {},
                                value: 0,
                                child: Text("Edit"),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  id = mm[index]['id'];
                                  datahelper().deletedata(db!, id!);
                                  setState(() {});

                                  Future.delayed(Duration(seconds: 2))
                                      .then((value) {
                                    Fluttertoast.showToast(
                                        msg: "Contect Delete Succesfully",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);

                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return book();
                                      },
                                    ));
                                  });
                                },
                                value: 1,
                                child: Text("Delete"),
                              )
                            ];
                          },
                        ));
                  },
                ),
              ),
            ),

            // Container(height: tbodyheight*0.10,
            //   child: Row(  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       InkWell(
            //         onTap: () {
            //
            //
            //         },
            //         child: Icon(Icons.phone,),
            //       ) ,
            //       InkWell(
            //         onTap: () {},
            //         child: Icon(Icons.person),
            //       ),
            //       InkWell(
            //         onTap: () {},
            //         child: Icon(Icons.star_border),
            //       )
            //     ],
            //   ),
            // )
          ],
        )),
      ),
    );
  }

  TextEditingController a = TextEditingController();
}
