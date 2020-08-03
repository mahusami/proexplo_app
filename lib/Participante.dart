import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Job2 {
  final int id;
  final int tipo;
  final String nombre;
  final String correo;
  final String cargo;
  final String empresa;
  final String linkedin;
  final String twiter;
  final int auto;

  Job2({this.id, this.tipo, this.nombre,this.correo,this.empresa,this.cargo,this.twiter,this.linkedin,this.auto});

  factory Job2.fromJson(Map<String, dynamic> json) {
    return Job2(
        id: json['id'],
        tipo: json['tipo'],
        nombre: json['nombre'],
        correo: json['correo'],
        empresa: json['empresa'],
        cargo: json['cargo'],
        twiter: json['twiter'],
        linkedin: json['linkedin'],
        auto:json['auto']
    );
  }
}