import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color getColor(String s) {
  switch (s) {
    case 'Лекция':
      return Colors.blue;
    case 'Практическое занятие':
      return Colors.deepPurple;
    case 'Консультация':
      return Colors.orange;
    default:
      return Colors.white54;
  }
}

class XCard extends StatelessWidget {
  const XCard(
      {super.key,
      required this.audithorium,
      required this.discipline,
      required this.lecturer,
      required this.stream,
      required this.building,
      required this.placeCount,
      required this.type,
      required this.start,
      required this.end,
      required this.date,
      required this.lessonNum});

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

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        clipBehavior: Clip.hardEdge,
        child: Container(
          //height: 250,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Center(
                          child: Container(
                        decoration: BoxDecoration(
                            color: getColor(type ?? ""),
                            borderRadius: BorderRadius.circular(50)),
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        width: 7,
                        height: 7,
                      )),
                      Text(type ?? "",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  SizedBox(width: 10),
                  if (stream != "")
                    Chip(
                        label: Text(
                          stream ?? "",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue),
                ],
              ),
              SizedBox(height: 10),
              Text(discipline ?? "",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Divider(),
              Row(children: [
                Icon(
                  Icons.person,
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(lecturer ?? ""),
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
                  Text(building ?? ""),
                  SizedBox(
                    width: 10,
                  ),
                  Text(audithorium ?? ""),
                  SizedBox(
                    width: 10,
                  ),
                  Text('$placeCount мест(а)' ?? ""),
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
                    start ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const VerticalDivider(thickness: 10, color: Colors.black54),
                  Text(end ?? "",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                ])
              ])
            ],
          ),
        ));
  }
}
