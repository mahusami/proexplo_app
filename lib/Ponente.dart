import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Job3 {
  final int id;
  final int puntaje;
  final String nombre;


  Job3({this.id, this.puntaje, this.nombre});

  factory Job3.fromJson(Map<String, dynamic> json) {
    return Job3(
        id: json['id'],
        puntaje: json['puntaje'],
        nombre: json['nombre']
    );
  }
}