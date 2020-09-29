import 'package:flutter/material.dart';
import 'package:iraqibayt/modules/Note.dart';

class Notes extends StatelessWidget {
  final List<Note> myNotes = [
    Note(
        id: 0,
        content:
            'هل تعلم انه يمكنك التخفيف من حدة غضب الأشخاص الغاضبين قبل التوجه بالحديث إليك! بوضع مرآة خلفك عند جلوسك على المكتب.'),
    Note(
        id: 1,
        content:
            'هل تعلم أن مرض الطاعون يسبب صعود الدم الى الجلد وظهور بقع سوداء على الجلد لذا سمي بالمرض الأسود!'),
    Note(
        id: 2,
        content:
            'هل تعلم أن الذهاب إلى رحلة الزفاف وقيادة جماعات النمل هي الأسباب التي تدفع ملكة النمل لمغادرة خليتها للقيام بها!'),
    Note(
        id: 3,
        content:
            'هل تعلم أن الأفعى تستخدم لسانها لالتقاط موجات الصوت والذبذبات!'),
    Note(
        id: 4,
        content:
            'هل تعلم أن هنالك حيوان وحيد يمكنه إخراج معدته خارج جسمه! وهو حيوان نجم البحر'),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
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
                myNotes[index].content,
                style: TextStyle(
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        itemCount: myNotes.length,
      ),
    );
  }
}
