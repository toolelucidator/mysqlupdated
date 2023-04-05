import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Student.dart';
import 'dart:convert';

class BDConnections {
  static const SERVER = "http://192.168.0.130/Students/sqloperations.php";
  static const _CREATE_TABLE_COMMAND = "CREATE_TABLE";
  static const _SELECT_TABLE_COMMAND = "SELECT_TABLE";
  static const _INSERT_TABLE_COMMAND = "INSERT_DATA";
  static const _UPDATE_TABLE_COMMAND = "UPDATE_DATA";

  //Crear tablaq
  static Future<String> createTable() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_COMMAND;
      final response = await http.post(Uri.parse(SERVER), body: map);
      print('Table response: ${response.body}');

      if (200 == response.statusCode) {
        print(response.body.toString());
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print("Error creando tabla o la tabla ya existe");
      print(e.toString());
      return "error";
    }
  }

  //Get data from server
  static Future<List<Student>?> selectData() async {
    List<Student> lista = [];
    try {
      var map = Map<String, dynamic>();
      map['action'] = _SELECT_TABLE_COMMAND;
      final response = await http.post(Uri.parse(SERVER), body: map);
      print('select response: ${response.body}');

      if (200 == response.statusCode) {
        //Mapear lista
        List<Student>? list = parseResponse(response.body);
        return list;
      } else {
        //return List<Student>();
        return lista;
      }
    } catch (e) {
      print("Error obteniendo datos");
      print(e.toString());
      //return List<Student>();
      return lista;
    }
  }

  static List<Student>? parseResponse(String responsebody) {
    final parsedData = json.decode(responsebody).cast<Map<String, dynamic>>();
    return parsedData.map<Student>((json) => Student.fromJson(json)).toList();
  }

  //Insertar data

  static Future<String> insertData(String first_name, String last_name,
      String apema, String telefono, String correo) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _INSERT_TABLE_COMMAND;
      map['first_name'] = first_name;
      map['last_name'] = last_name;
      map['apematerno'] = apema;
      map['telefono'] = telefono;
      map['correo'] = correo;

      final response = await http.post(Uri.parse(SERVER), body: map);
      print('INSERT response: ${response.body}');

      if (200 == response.statusCode) {
        print("Insert Sucess");
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print("Error añadiendo datos a la tabla ");
      print(e.toString());
      return "error";
    }
  }

  //Update
  static Future<String> UpdateData(String id, String first_name,
      String last_name, String apema, String telefono, String correo) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_TABLE_COMMAND;
      map['id'] = id;
      map['first_name'] = first_name;
      map['last_name'] = last_name;
      map['apematerno'] = apema;
      map['telefono'] = telefono;
      map['correo'] = correo;

      final response = await http.post(Uri.parse(SERVER), body: map);
      print('UPDATE response: ${response.body}');

      if (200 == response.statusCode) {
        print("Insert Sucess");
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print("Error añadiendo datos a la tabla ");
      print(e.toString());
      return "error";
    }
  }
}
