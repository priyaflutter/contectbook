import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:contectbook/database1.dart';
import 'package:contectbook/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

class second extends StatefulWidget {
  const second({Key? key}) : super(key: key);

  @override
  State<second> createState() => _secondState();
}

class _secondState extends State<second> {
  bool status = false;
  Database? db;
  int? id;
  String img = "";

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getdatabase();
    setState(() {
      status = true;
    });
  }

  getdatabase() {
    datahelper().Getdatabase().then((value) {
      db = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double theight = MediaQuery.of(context).size.height;
    double twidth = MediaQuery.of(context).size.width;
    double tstatusbar = MediaQuery.of(context).padding.top;
    double tNavigator = MediaQuery.of(context).padding.bottom;
    double tappbar = kToolbarHeight;

    double tbodyheight = theight - tstatusbar - tNavigator;

    return status
        ? WillPopScope(
            onWillPop: onback,
            child: Scaffold(
                body: SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Color(0xff020b26)),
                    height: tbodyheight * 0.10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return book();
                              },
                            ));
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Text(
                          "New Contact",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            name1 = name.text;
                            number1 = number.text;

                            if (name1.isEmpty || number1.isEmpty) {
                              setState(() {
                                namestatus = true;
                                numberstatus = true;
                              });
                            } else {
                              datahelper().insertdata(name1, number1, db!,img);

                              Fluttertoast.showToast(
                                  msg: "Contect Save Succesfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);

                              Future.delayed(Duration(seconds: 2))
                                  .then((value) {
                                onback();
                              });
                            }
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: tbodyheight * 0.25,
                    // color: Colors.black,
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();
                             // Pick an image
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              img = image!.path;
                            });
                            print("${img}");
                          },
                          child:  Container(
                                child: Align(alignment: Alignment.center,
                                  child:img != ""
                                      ? CircleAvatar(maxRadius: 53,
                                      backgroundImage:
                                          FileImage(File("${img}")),
                                    ):CircleAvatar(
                                    radius: 53,
                                    backgroundImage:
                                    AssetImage("images/profile.png")),
                                ),
                              )

                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: tbodyheight * 0.10,
                      margin: EdgeInsets.all(tbodyheight * 0.01),
                      child: TextField(
                        // maxLength: 10,
                        onChanged: (value) {
                          setState(() {
                            namestatus = false;
                          });
                        },
                        controller: name,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff010431), width: 2)),
                          labelText: "Contect Name",
                          errorText:
                              namestatus ? "Please Fill the Blank" : null,
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffb10909), width: 2)),
                        ),
                      )),
                  Container(
                      height: tbodyheight * 0.10,
                      margin: EdgeInsets.all(tbodyheight * 0.01),
                      child: TextField(
                        // maxLength: 10,
                        onChanged: (value) {
                          setState(() {
                            numberstatus = false;
                          });
                        },
                        controller: number,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff010431), width: 2)),
                          labelText: "Phone No",
                          errorText:
                              numberstatus ? "Please Fill the Blank" : null,
                          prefixIcon: Icon(Icons.call),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffb10909), width: 2)),
                        ),
                      )),
                ],
              )),
            )),
          )
        : Center(child: CircularProgressIndicator());
  }

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  bool namestatus = false;
  bool numberstatus = false;

  String name1 = "";
  String number1 = "";

  Future<bool> onback() {
    showDialog(
        builder: (context) {
          return AlertDialog(
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return book();
                      },
                    ));
                  },
                  child: Text("Yes")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No"))
            ],
            title: Text("Are you Sure want to "),
          );
        },
        context: context);

    return Future.value(true);
  }
}
