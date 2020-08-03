import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Jobusu{
  final int iusu;
  final String email;
  final String nombres;
  final String apellidos;
  final String tipodoc;
  final String nrodoc;
  final String rucemp;
  final String razemp;
  final String cel;
  final String tlf;
  final String cargo;
  Jobusu({this.iusu, this.email, this.nombres,this.apellidos,this.tipodoc,
    this.nrodoc,this.rucemp,this.razemp,this.cel,this.tlf,
    this.cargo});

  factory Jobusu.fromJson(Map<String, dynamic> json) {
    return Jobusu(
        iusu: json['iusu'],
        email: json['email'],
        nombres: json['nombres'],
        apellidos: json['apellidos'],
        tipodoc: json['tipodoc'],
        nrodoc: json['nrodoc'],
        rucemp: json['rucemp'],
        razemp: json['razemp'],
        cel: json['cel'],
        tlf: json['tlf'],
        cargo: json['cargo']
    );
  }
}