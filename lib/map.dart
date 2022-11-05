import 'package:flutter/material.dart';

class Maps extends StatelessWidget {
  const Maps({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,// Here we take the value from the MyHomePage object that was created by
// the App.build method, and use it to set our appbar title.
              title: Text('Карта корпусов'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.settings_applications, color: Colors.white, size: 120),
                  Text('В разработке', style: TextStyle(
                      fontSize: 24,
                      color: Colors.white
                  ),)
                ],
              ),
            )
            );
  }
}

/*
,*/
