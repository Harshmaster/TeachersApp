import 'package:eduvelopeV2/widgets/classTile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpcomingClasses extends StatefulWidget {
  @override
  _UpcomingClassesState createState() => _UpcomingClassesState();
}

class _UpcomingClassesState extends State<UpcomingClasses> {
  SharedPreferences prefs;
  getTeacherId() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("teacherId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (ctx, fdata) {
          return StreamBuilder(
            builder: (ctx, sdata) {
              if (sdata.connectionState == ConnectionState.waiting) {
                return Icon(Icons.warning);
              }
              print(sdata.data.documents);
              return ListView.builder(
                itemBuilder: (ctx, index) {
                  if (sdata.data.documents[index]['start'] >
                      int.parse(DateFormat.H().format(DateTime.now()))) {
                    return ClassTile(
                      isLive: false,
                      name: sdata.data.documents[index]['className'],
                      standard: sdata.data.documents[index]['standard'],
                      timing: sdata.data.documents[index]['timing'],
                    );
                  }
                  return SizedBox(
                    width: 0,
                    height: 0,
                  );
                },
                itemCount: sdata.data.documents.length,
              );
            },
            stream: Firestore.instance
                .collection('Teachers')
                .document(fdata.data)
                .collection('Classrooms')
                .snapshots(),
          );
        },
        future: getTeacherId(),
      ),
    );
  }
}