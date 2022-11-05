import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: TabBar(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
//indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.white60,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white),
                tabs: [
                  Tab(
                      child: Row(
                        children: [Icon(Icons.settings), SizedBox(width: 5,),Text('НАСТРОЙКИ')],
                      )),
                  Tab(
                      child: Row(
                        children: [Icon(Icons.update), SizedBox(width: 5,),Text('ОБНОВЛЕНИЯ')],
                      )),
                ],
              ),
// Here we take the value from the MyHomePage object that was created by
// the App.build method, and use it to set our appbar title
            ),
            body: TabBarView(
              children: [
                Center(
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
                ),
                Center(
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
              ],
            )));
  }
}

/*
,*/
