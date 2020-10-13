import 'package:flutter/material.dart';
import 'package:iraqibayt/modules/Note.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<Note> notes = [];

  Future<List<Note>> _getNotes() async {
    var notesResponse = await http.get('https://iraqibayt.com/Info');
    var notesData = json.decode(notesResponse.body);
    Note tNote;
    notes = [];

    for (var note in notesData) {
      tNote = Note(
        id: note['id'],
        content: note['name'],
      );

      notes.add(tNote);
      print('depart length is : ' + notes.length.toString());
    }
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight =
        MediaQuery.of(context).size.height - statusBarHeight - kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        title: Text('هل تعلم'),
      ),
      body: Container(
        height: screenHeight * 0.99,
        padding: const EdgeInsets.only(top: 20.0),
        child: FutureBuilder(
          future: _getNotes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                height: 100,
                child: Center(
                  child: Text('جاري التحميل ...'),
                ),
              );
            } else
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: FittedBox(
                            child: Image.asset('assets/images/note.png'),
                          ),
                        ),
                      ),
                      title: Text(
                        snapshot.data[index].content,
                        style: TextStyle(
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              );
          },
        ),
      ),
    );
  }
}
