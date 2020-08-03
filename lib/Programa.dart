import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Job {
  final int id;
  final String tipo;
  final String nombre;
  final String horario;
  final String ponente;
  final String hi;
  final String hf;
  final String fecha;
  final String link;
  final int encuesta;
  final int asistio;
  final int envivo;
  final int importante;
  Job({this.id, this.tipo, this.nombre, this.horario,this.ponente,this.encuesta,this.hi,this.hf,this.link,this.fecha,this.asistio,this.envivo,this.importante});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      tipo: json['tipo'],
      nombre: json['nombre'],
      horario: json['horario'],
      ponente: json['ponente'],
      encuesta: json['encuesta'],
        hi: json['hi'],
        hf: json['hf'],
        link: json['link'],
        fecha: json['fecha'],
        asistio: json['asistio'],
        envivo: json['envivo'],
        importante: json['importante']
    );
  }
}