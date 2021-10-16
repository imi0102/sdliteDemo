import 'package:flutter/material.dart';
import 'package:local_database_demo/DetailsPage.dart';
import 'package:local_database_demo/database/DatabaseHelper.dart';

import 'dart:async';

import 'package:local_database_demo/models/ListModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Data List';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: BuildBody(),
      ),
    );
  }
}

class BuildBody extends StatefulWidget {
  @override
  _BuildBodyState createState() => _BuildBodyState();
}

class _BuildBodyState extends State<BuildBody> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  late Future<List<ListModel>> listItems;
  late List<ListModel> noteListmain;

  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshDataList();
  }

  refreshDataList() {
    setState(() {
      getAllData();
    });
  }
  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  flex:4,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Text("Title :"),
                        Flexible(
                          child: TextField(
                            controller: titleController,
                          ),
                        ),
                        RaisedButton(
                          child: Text("Add"),
                          onPressed : () {
                            setState(() {
                              insertData();
                              FocusScope.of(context).unfocus();
                            });
                          },
                        )
                      ],
                    ),
                  )
              ),
              Flexible(
                  flex: 9,
                  child: ListView.builder(
                      itemCount: noteListmain.length,

                      itemBuilder: (BuildContext context, int position){
                        return InkWell(
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Icon(Icons.assessment),
                              ),

                              title: Text(this.noteListmain[position].title??"", ),

                              trailing: GestureDetector(
                                child: Icon(Icons.delete, color: Colors.grey,),
                                onTap: () {

                                  deleteData(this.noteListmain[position].id??0);
                                },
                              ),

                            ),
                          ),
                          onTap: ()
                          {
                            updateData(this.noteListmain[position].id??0, this.noteListmain[position].title??"");
                          },
                        );
                      }
                  )
              )
            ]
        )
    );
  }

  void insertData() async {
    int result;
    String title = titleController.text;
    result = await databaseHelper.insertData(ListModel(title));
    print('inserted row id: $result');
    titleController.text = '';
    refreshDataList();
  }

  void getAllData() async  {
    final noteMapList = await databaseHelper.getDbData();
    setState(() {
      noteListmain = noteMapList;
    });
  }

  void updateData(int id, String title) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DetailsPage(id, title);
    }));
    if(result == true){
      refreshDataList();
    }
  }

  void deleteData(int itemId) async{
    int result = await databaseHelper.deleteData(itemId);
    refreshDataList();
  }
}