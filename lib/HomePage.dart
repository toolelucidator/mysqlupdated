import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Student.dart';
import 'dart:convert';
import 'bd_connections.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student>? _Students;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  TextEditingController? _firstnameController;
  TextEditingController? _lastnameController;
  TextEditingController? _apemController;
  TextEditingController? _telefonoController;
  TextEditingController? _correoController;
  String _currentID = "";
  bool _isupdating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Students = [];
    _scaffoldKey = GlobalKey();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _apemController = TextEditingController();
    _telefonoController = TextEditingController();
    _correoController = TextEditingController();
    _selectData();
  }

  //Desplegar la snackbar
  /*_showSnackBar(context, message) {
    _scaffoldKey!.currentState!.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }*/

  //Crear tabla
  _createTable() {
    BDConnections.createTable().then((result) {
      if ('success' == result) {
      //  _showSnackBar(context, result);
      }
    });
  }

  //Update

  _updateData() {
    if (_firstnameController!.text.isEmpty || _lastnameController!.text.isEmpty) {
      print("Empty fields");
      return;
    }
    BDConnections.UpdateData(
        _currentID.toString(),
        _firstnameController!.text,
        _lastnameController!.text,
        _apemController!.text,
        _telefonoController!.text,
        _correoController!.text)
        .then((result) {
      if ('success' == result) {
        //_showSnackBar(context, result);

        _firstnameController!.text = "";
        _lastnameController!.text = "";
        _apemController!.text = "";
        _telefonoController!.text = "";
        _correoController!.text = "";

        //llamar la consulta general
      }
      _selectData();

    });
  }

  //Add data
  _insertData() {
    if (_firstnameController!.text.isEmpty || _lastnameController!.text.isEmpty) {
      print("Empty fields");
      return;
    }
    BDConnections.insertData(
        _firstnameController!.text,
        _lastnameController!.text,
        _apemController!.text,
        _telefonoController!.text,
        _correoController!.text)
        .then((result) {
      if ('success' == result) {
        //_showSnackBar(context, result);
        _firstnameController!.text = "";
        _lastnameController!.text = "";
        _apemController!.text = "";
        _telefonoController!.text = "";
        _correoController!.text = "";

        //llamar la consulta general
        _selectData();
      }
    });
  }

  //Secleccionar datos

  _selectData() {
    BDConnections.selectData().then((students) {
      setState(() {
        _Students = students;
      });
      //_showSnackBar(context, "Data Acquired");
      print("Number of Students ${students!.length}");
    });
  }

//Body

  SingleChildScrollView _body() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text("ID")),
            DataColumn(label: Text("Nombre")),
            DataColumn(label: Text("A. Paterno")),
            DataColumn(label: Text("A. Materno")),
            DataColumn(label: Text("Teléfono")),
            DataColumn(label: Text("Correo")),
          ],
          rows: _Students!.map((student) => DataRow(cells: [
            DataCell(Text(student.id!), onTap: () {
              _currentID = student.id.toString();
              print("Id Actual");
              print(_currentID);
              _isupdating = true;
              print("Update Status");
              print(_isupdating);
              fillTextFields(student);

            }),
            DataCell(Text(student.firstName!)),
            DataCell(Text(student.lastName!)),
            DataCell(Text(student.apematerno!)),
            DataCell(Text(student.telefono!)),
            DataCell(Text(student.correo!)),
          ])).toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("MySQL Remote Basic Operations"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              BDConnections.createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              setState(() async {
                _Students = await _selectData();
              });

            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _firstnameController,
                      decoration:
                      InputDecoration.collapsed(hintText: "Primer Nombre"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _lastnameController,
                      decoration: InputDecoration.collapsed(
                          hintText: "Apellido Paterno"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _apemController,
                      decoration: InputDecoration.collapsed(
                          hintText: "Apellido Materno"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _telefonoController,
                      decoration:
                      InputDecoration.collapsed(hintText: "Teléfono"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _correoController,
                      decoration: InputDecoration.collapsed(hintText: "Correo"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: _body(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_isupdating){
            _updateData();
            _isupdating = false;
            _selectData();
          }
          else{
            _insertData();
            _isupdating = false;
            _selectData();
          }

        },
        child: Icon(Icons.add),
      ),
    );
  }

  void fillTextFields(Student student){
    _firstnameController!.text = student.firstName!;
    _lastnameController!.text = student.lastName!;
    _apemController!.text = student.apematerno!;
    _telefonoController!.text = student.telefono!;
    _correoController!.text = student.correo!;
  }
}