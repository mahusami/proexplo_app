import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Job4 {
  final int id;
  final String tipo;
  final int estado;
  final String nombre;
  final String fechacierre;
  final int realizada;

  Job4({this.id, this.tipo, this.estado,this.nombre,this.fechacierre,this.realizada});

  factory Job4.fromJson(Map<String, dynamic> json) {
    return Job4(
      id: json['id'],
      tipo: json['tipo'],
        estado: json['estado'],
        nombre: json['nombre'],
        fechacierre: json['fechacierre'],
        realizada: json['realizada']

    );
  }
}