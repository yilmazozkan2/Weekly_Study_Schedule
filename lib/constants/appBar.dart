import 'package:flutter/material.dart';

class myAppBar extends AppBar implements PreferredSizeWidget{
  myAppBar():super(
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
    title: Text("Haftalık Ders Çalışma Programı"),
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.green
  );
}