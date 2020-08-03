import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Pregunta {
  final int id;
  final String programa;
  final String pregunta;
  final String fechahora;
  final String nombres;
  final String apellidos;


  Pregunta({this.id, this.programa, this.pregunta,this.fechahora,this.nombres,this.apellidos});

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
        id: json['id'],
        programa: json['programa'],
        pregunta: json['pregunta'],
        fechahora: json['fechahora'],
        nombres: json['nombres'],
        apellidos: json['apellidos']
    );
  }
}