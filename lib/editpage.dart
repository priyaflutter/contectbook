import 'dart:io';

import 'package:contectbook/database1.dart';
import 'package:contectbook/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';


class editpage1 extends StatefulWidget {
  Map mm;
  Database database;



  editpage1(this.mm, this.database);

  @override
  State<editpage1> createState() => _editpage1State();
}

class _editpage1State extends State<editpage1> {
  bool status = false;
  int? id;
  String newimg="";
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status = true;

    String namee = widget.mm['name'];
    name.text = namee;
    String numberr = widget.mm['number'];
    number.text = numberr;
    id=widget.mm['id'];
    newimg=widget.mm['imagpath'];
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
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff020b26),
              centerTitle: true,
              title: Text("Edit Contect"),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                children: [
                  Container(
                    height: tbodyheight * 0.30,
                    // color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          children: [
                            InkWell(
                              onTap: () async {
                                // Pick an image
                                final XFile? image =
                                await picker.pickImage(source: ImageSource.gallery);
                                setState(() {
                                  newimg = image!.path;
                                });
                                print("${newimg}");
                              },
                              child: Container(height: tbodyheight*0.20,
                                    child: Align(alignment: Alignment.center,
                                      child:newimg!="" ?CircleAvatar(
                                backgroundImage:
                                FileImage(File("${newimg}")),
                                      ):CircleAvatar(
                                        backgroundColor: Color(0xff020b26),
                                        maxRadius: 40,
                                        child: CircleAvatar(
                                            radius: 35,
                                            backgroundImage:
                                            AssetImage("images/profile.png")),
                                      ),
                                    ),
                                  )
                            ),
                          ],
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
                  ElevatedButton(
                    onPressed: () {

                     String  name1=name.text;
                     String  number1=number.text;

                    datahelper().editdata(name1,number1,widget.database,id!,newimg);

                    Fluttertoast.showToast(
                        msg: "Update Save Succesfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                return book();
                    },));
                    },
                    child: Text("Save",style: TextStyle(fontSize: 20),),
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff02022f),
                        alignment: Alignment.center),
                  )
                ],
              )),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  bool namestatus = false;
  bool numberstatus = false;


}
