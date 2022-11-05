import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';
import 'package:intl/intl.dart';
import 'package:mpei3/components/Card.dart';

getLists(Map<int, List<Lesson>> pages, int key) {
  if (pages[key]?.length != null) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: pages[key]?.length,
        itemBuilder: (context, index) {
          return XCard(
              audithorium: pages[key]?[index].audithorium ?? "",
              discipline: pages[key]?[index].discipline ?? "",
              lecturer: pages[key]?[index].lecturer ?? "",
              stream: pages[key]?[index].stream ?? "",
              building: pages[key]?[index].building ?? "",
              placeCount: pages[key]?[index].placeCount ?? "",
              type: pages[key]?[index].type ?? "",
              start: pages[key]?[index].start ?? "",
              end: pages[key]?[index].end ?? "",
              date: pages[key]?[index].date ?? "",
              lessonNum: pages[key]?[index].lessonNum ?? "");
        });
  } else {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.done_all, color: Colors.white, size: 120),
          Text(
            'Пары отсутствуют',
            style: TextStyle(fontSize: 24, color: Colors.white),
          )
        ],
      ),
    );
  }
}

Future<List<Lesson>> fetchLessons(String start, end) async {
  final response = await http.get(Uri.parse(
      'http://ts.mpei.ru/api/schedule/group/15078?start=$start&finish=$end&lng=1'));

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
  final String weekday;

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
    required this.weekday,
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
      weekday: json['dayOfWeek'].toString(),
    );
  }
}

class Lessons extends StatefulWidget {
  const Lessons({super.key});

  @override
  State<Lessons> createState() => _Lessons();
}

const Map<int, String> days = {
  1: 'ПН',
  2: 'ВТ',
  3: 'СР',
  4: 'ЧТ',
  5: 'ПТ',
  6: 'СБ'
};

class _Lessons extends State<Lessons> with SingleTickerProviderStateMixin {
  late Future<List<Lesson>> futureLessons;
  late TabController _tabController;
  late ScrollController _scrollController;

  Map<int, List<Lesson>> pages = {};
  List<Tab> tabs = [];
  var formatter = DateFormat('yyyy.MM.dd');

  var now = DateTime.now();

  void nextWeek() {
    now = now.add(Duration(days: 7));

    var delta = now.weekday - 1;

    var mnd = now.subtract(Duration(days: delta));
    var snd = mnd.add(const Duration(days: 6));
    var tempDat = mnd;

    setState(() {
      tabs = [];
      for (var i = 0; i <= 5; i++) {
        tabs.add(Tab(
          text: '${days[i + 1]} (${tempDat.day > 9 ? tempDat.day : '0${tempDat.day}'}.${tempDat.month})',
        ));
        tempDat = tempDat.add(Duration(days: 1));
      }
    });

    futureLessons = fetchLessons(formatter.format(mnd), formatter.format(snd));
    futureLessons.then((value) {
      pages = {};
      setState(() {
        value.forEach((element) {
          if (pages[int.parse(element.weekday)] == null) {
            pages[int.parse(element.weekday)] = [];
          }

          pages[int.parse(element.weekday)]?.add(element);
        });
      });

      print(pages);
    });
  }

  void prevWeek() {
    now = now.subtract(Duration(days: 7));

    var delta = now.weekday - 1;

    var mnd = now.subtract(Duration(days: delta));
    var snd = mnd.add(const Duration(days: 6));
    var tempDat = mnd;

    setState(() {
      tabs = [];
      for (var i = 0; i <= 5; i++) {
        tabs.add(Tab(
          text: '${days[i + 1]} (${tempDat.day > 9 ? tempDat.day : '0${tempDat.day}'}.${tempDat.month})',
        ));
        tempDat = tempDat.add(Duration(days: 1));
      }
    });

    futureLessons = fetchLessons(formatter.format(mnd), formatter.format(snd));
    futureLessons.then((value) {
      pages = {};
      setState(() {
        value.forEach((element) {
          if (pages[int.parse(element.weekday)] == null) {
            pages[int.parse(element.weekday)] = [];
          }

          pages[int.parse(element.weekday)]?.add(element);
        });
      });

      print(pages);
    });
  }

  @override
  void initState() {
    var delta = now.weekday - 1;

    var mnd = now.subtract(Duration(days: delta));
    var snd = mnd.add(const Duration(days: 6));
    var tempDat = mnd;

    for (var i = 0; i <= 5; i++) {
      tabs.add(Tab(
        text: '${days[i + 1]} (${tempDat.day > 9 ? tempDat.day : '0${tempDat.day}'}.${tempDat.month})',
      ));
      tempDat = tempDat.add(Duration(days: 1));
    }

    _tabController = TabController(
        length: 6,
        vsync: this,
        initialIndex: now.weekday - 1 == 6 ? 5 : now.weekday - 1);
    _scrollController = ScrollController(initialScrollOffset: 145);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        //print('scrolling');
      });
      _scrollController.position.isScrollingNotifier.addListener(() {
        if (!_scrollController.position.isScrollingNotifier.value) {
          if (_scrollController.position.pixels > 0 &&
              _scrollController.position.pixels < 45) {
            Timer(Duration(milliseconds: 100), () {
              _scrollController.animateTo(0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
              HapticFeedback.lightImpact();
            });
          } else if (_scrollController.position.pixels >= 45 &&
              _scrollController.position.pixels < 145) {
            Timer(Duration(milliseconds: 100), () {
              _scrollController.animateTo(145,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
              HapticFeedback.lightImpact();
            });
          }
        } else {
          //print('scroll is started');
        }
      });
    });

    super.initState();

    futureLessons = fetchLessons(formatter.format(mnd), formatter.format(snd));
    futureLessons.then((value) {
      setState(() {
        value.forEach((element) {
          if (pages[int.parse(element.weekday)] == null) {
            pages[int.parse(element.weekday)] = [];
          }

          pages[int.parse(element.weekday)]?.add(element);
        });
      });

      print(pages);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              //snap: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          prevWeek();
                          HapticFeedback.mediumImpact();
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue.shade400),
                            //foregroundColor: MaterialStateProperty.all(Colors.blue),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(20))),
                        child: Row(
                          children: [
                            Icon(Icons.chevron_left),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'ПРЕДЫДУЩАЯ\nНЕДЕЛЯ',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )
                          ],
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue.shade400),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(20))),
                        onPressed: () {
                          nextWeek();
                          HapticFeedback.mediumImpact();
                        },
                        child: Row(
                          children: [
                            Text(
                              'СЛЕДУЮЩАЯ\nНЕДЕЛЯ',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.chevron_right),
                          ],
                        ))
                  ],
                ),
              ),
              //floating: true,
              centerTitle: true,
              expandedHeight: 250,
              elevation: 4,
              title: Text('Расписание'),
              bottom: TabBar(
                  controller: _tabController,
                  indicatorPadding: EdgeInsets.zero,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
//indicatorSize: TabBarIndicatorSize.label,
                  isScrollable: true,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.white60,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  tabs: tabs),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            getLists(pages, 1),
            getLists(pages, 2),
            getLists(pages, 3),
            getLists(pages, 4),
            getLists(pages, 5),
            getLists(pages, 6),
          ],
        ));

    /* Scaffold(
          //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          appBar: AppBar(
            elevation: 0,
            title: Text('Расписание'),
            bottom: TabBar(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
//indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.white60,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.white),
              tabs: [
                Tab(text: 'ПН (01.09)'),
                Tab(text: 'ВТ (02.09)'),
                Tab(text: 'СР (03.09)'),
                Tab(text: 'ЧТ (04.09)'),
                Tab(text: 'ПТ (05.09)'),
                Tab(text: 'СБ (06.09)'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FutureBuilder<List<Lesson>>(
                  future: futureLessons,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Container(
                                      //height: 250,
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Center(
                                                      child: Container(
                                                    decoration: BoxDecoration(
                                                        color: getColor(snapshot
                                                                .data?[index]
                                                                .type ??
                                                            ""),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 5, 0),
                                                    width: 7,
                                                    height: 7,
                                                  )),
                                                  Text(
                                                      snapshot.data?[index]
                                                              .type ??
                                                          "",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w800)),
                                                ],
                                              ),
                                              SizedBox(width: 10),
                                              if (snapshot
                                                      .data?[index].stream !=
                                                  "")
                                                Chip(
                                                    label: Text(
                                                      snapshot.data?[index]
                                                              .stream ??
                                                          "",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor:
                                                        Colors.blue),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                              snapshot.data?[index]
                                                      .discipline ??
                                                  "",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                          Divider(),
                                          Row(children: [
                                            Icon(
                                              Icons.person,
                                              color: Colors.black54,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(snapshot
                                                    .data?[index].lecturer ??
                                                ""),
                                          ]),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.business,
                                                color: Colors.black54,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(snapshot
                                                      .data?[index].building ??
                                                  ""),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(snapshot.data?[index]
                                                      .audithorium ??
                                                  ""),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  '${snapshot.data?[index].placeCount} мест(а)' ??
                                                      ""),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(children: [
                                            Icon(
                                              Icons.access_time_filled,
                                              color: Colors.black54,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Row(children: [
                                              Text(
                                                snapshot.data?[index].start ??
                                                    "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              const VerticalDivider(
                                                  thickness: 10,
                                                  color: Colors.black54),
                                              Text(
                                                  snapshot.data?[index].end ??
                                                      "",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16))
                                            ])
                                          ])
                                        ],
                                      ),
                                    ));
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
              ListView(
                children: [
                  Card(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        height: 250,
                      )),
                  Card(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        height: 250,
                      )),
                  Card(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        height: 250,
                      )),
                  Card(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        height: 250,
                      )),
                ],
              ),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),*/
    /*const TabBarView(
              children: [
                Icon(Icons.directions_car),
                Icon(Icons.directions_transit),
                Icon(Icons.directions_bike),
                Icon(Icons.directions_car),
                Icon(Icons.directions_transit),
                Icon(Icons.directions_bike),
              ],
            )*/
  }
}

/*
,*/
