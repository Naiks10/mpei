import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'components/Card.dart';

String getNow() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy.MM.dd');
  String formattedDate = formatter.format(now);
  return formattedDate;
}

Future<List<Lesson>> fetchLessons() async {
  String date = getNow();

  final response = await http.get(Uri.parse(
      'http://ts.mpei.ru/api/schedule/group/15078?start=$date&finish=$date&lng=1'));

  if (response.statusCode == 200) {
    // await Future.delayed(Duration(seconds: 5));

    print(response.body);

    List<dynamic> list = json.decode(response.body);
    List<Lesson> lessons = [];

    //int counter = 0;

    for (var item in list) {
      Lesson lesson = Lesson.fromJson(item);
      lessons.add(lesson);
    }

    // If the server did return a 200 OK response,
    // then parse the JSON.
    return lessons;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Lesson {
  final String audithorium;
  final String discipline;
  final String lecturer;
  final String stream;
  final String building;
  final String placeCount;
  final String type;
  final String start;
  final String end;
  final String date;
  final String lessonNum;

  const Lesson({
    required this.audithorium,
    required this.discipline,
    required this.lecturer,
    required this.stream,
    required this.building,
    required this.placeCount,
    required this.lessonNum,
    required this.type,
    required this.date,
    required this.start,
    required this.end,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      audithorium: json['auditorium'].toString(),
      discipline: json['discipline'].toString(),
      lecturer: json['lecturer'].toString(),
      stream: json['stream'] ?? "",
      building: json['building'].toString(),
      placeCount: json['auditoriumAmount'].toString(),
      start: json['beginLesson'].toString(),
      end: json['endLesson'].toString(),
      type: json['kindOfWork'].toString(),
      lessonNum: json['contentTableOfLessonsName'].toString(),
      date: json['date'].toString(),
    );
  }
}

class Stat extends StatefulWidget {
  const Stat({super.key});

  @override
  State<Stat> createState() => _Stat();
}

class _Stat extends State<Stat> {
  late Future<List<Lesson>> futureLessons;

  void initState() {
    super.initState();
    futureLessons = fetchLessons();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
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
                    children: [Icon(Icons.today), SizedBox(width: 5,),Text('СЕГОДНЯ')],
                  )),
                  Tab(
                      child: Row(
                        children: [Icon(Icons.data_saver_off), SizedBox(width: 5,),Text('СВОДКА')],
                      )),
                ],
              ),
// Here we take the value from the MyHomePage object that was created by
// the App.build method, and use it to set our appbar title
            ),
            body: TabBarView(
              children: [
                FutureBuilder<List<Lesson>>(
                    future: futureLessons,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data?.isEmpty ?? true) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.done_all, color: Colors.white, size: 120),
                                Text('Пар сегодня нет', style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white
                                ),)
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          //controller: _scrollController,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return XCard(audithorium: snapshot.data?[index].audithorium ?? "",
                                  discipline: snapshot.data?[index].discipline ?? "",
                                  lecturer: snapshot.data?[index].lecturer ?? "",
                                  stream: snapshot.data?[index].stream ?? "",
                                  building: snapshot.data?[index].building ?? "",
                                  placeCount: snapshot.data?[index].placeCount ?? "",
                                  type: snapshot.data?[index].type ?? "",
                                  start: snapshot.data?[index].start ?? "",
                                  end: snapshot.data?[index].end ?? "",
                                  date: snapshot.data?[index].date ?? "",
                                  lessonNum: snapshot.data?[index].lessonNum ?? "");
                            });
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return Container(
                          height: 3,
                          width: 3,
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.blue, color: Colors.white));
                    }),
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
