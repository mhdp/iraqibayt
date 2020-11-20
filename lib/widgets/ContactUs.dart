import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/profile.dart';
import 'home/home.dart';
import 'my_icons_icons.dart';
import 'package:http/http.dart' as http;

class ContactUs extends StatefulWidget {
  @override
  _ContactUs createState() => _ContactUs();
}

class _ContactUs extends State<ContactUs> {

  int signup_btn_child_index = 0;
  String type_selected;
  final email_Controller = TextEditingController();
  final message_Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFc4c4c4),
      appBar: AppBar(
        backgroundColor: Color(0xFF335876),
        title: Text(
          "اتصل بنا",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            fontFamily: "CustomIcons",
          ),
        ),
        actions: [

          Padding(
            padding: const EdgeInsets.all(10),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new Add_Post()),
                );
              },
              color: Color(0xFFdd685f),
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.add_box,
                    color: Colors.white,
                  ),
                  Text(
                    " أضف إعلان ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: "CustomIcons",
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Card(
  shape: RoundedRectangleBorder(
    side: BorderSide(color: Colors.grey, width: 0.5),
    borderRadius: BorderRadius.circular(0),
  ),
  clipBehavior: Clip.antiAlias,
  margin: const EdgeInsets.only(top:10.0),
  //color: Colors.grey,
  elevation: 0,

  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.all(3.0),
          color: Color(0xff275879),
          child: Text(
            'أرسل ملاحظاتك',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: "CustomIcons",
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child:DropdownButtonFormField(

          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(7),
            filled: true,
            fillColor: Color(0xFFe8e8e8),
            border: const OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(5.0),
              ),
            ),),
          isExpanded: true,
          hint: SizedBox(
            //width: MediaQuery.of(context).size.width/2, // for example
              child: Text("نوع الملاحظة",
                textAlign: TextAlign.right,textDirection: TextDirection.rtl,)
          ),


          items: [
            DropdownMenuItem(
              value: "شكر",
              child: Text(
                "شكر",
              ),
            ),
            DropdownMenuItem(
              value: "إقتراح",
              child: Text(
                "إقتراح",
              ),
            ),
            DropdownMenuItem(
              value: "مشكلة",
              child: Text(
                "مشكلة",
              ),
            ),
            DropdownMenuItem(
              value: "الإعلان في موقعنا",
              child: Text(
                "الإعلان في موقعنا",
              ),
            ),
          ],


          onChanged: (value) {
            setState(() {
              type_selected = value;
            });
          },
          value: type_selected,

        ),),
      Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: email_Controller,
          keyboardType: TextInputType.emailAddress,
          maxLines: null,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(7),
              filled: true,
              fillColor: Color(0xFFe8e8e8),
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(5.0),
                ),
              ),
              hintText: "البريد الإلكتروني"),
        ),),
      Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: message_Controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(7),
              filled: true,
              fillColor: Color(0xFFe8e8e8),
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(5.0),
                ),
              ),
              hintText: "الرسالة"),
        ),),
      send_button(),
    ],
  ),
),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF335876),
        unselectedItemColor: Colors.white,
        selectedItemColor: Color(0xFFdd685f),
        onTap: onTabTapped, // new
        currentIndex: 4,
        type: BottomNavigationBarType.fixed, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'الإعلانات',
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: 'أضف إعلان'
          ),
          new BottomNavigationBarItem(
              icon: Icon(MyIcons.user),
              label: 'حسابي'
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: 'ملاحظات'
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index)
  {
    if(index == 0){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Home()),
      );
    }else if(index == 1){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Posts_Home()));
    }else if(index == 2){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Add_Post()),
      );
    }else if(index == 3){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Profile()));
    }
    /*setState(() {
      _currentIndex = index;
      print(index.toString());
    });*/
  }

  Widget send_button() {
    return InkWell(onTap:(){ send_message();} , child: Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top:10.0,right: 10.0,left: 10.0,bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),


        color: Color(0xff65AECA),
      ),
      child: signup_button_child(),
    ),
    );
  }

  send_message() async {

    setState(() {
      signup_btn_child_index = 1;
    });

    if (type_selected == "" || type_selected == null) {
      _showDialog("يرجى اختيار نوع الملاحطة.");
      setState(() {
        signup_btn_child_index = 0;
      });
      return;
    }

    if (email_Controller.text == "" || email_Controller.text == null) {
      _showDialog("يرجى إدخال البريد الإلكتروني.");
      setState(() {
        signup_btn_child_index = 0;
      });
      return;
    }

    if (message_Controller.text == "" || message_Controller.text == null) {
      _showDialog("يرجى إدخال الرسالة.");
      setState(() {
        signup_btn_child_index = 0;
      });
      return;
    }

    Map<String, String> postBody = new Map<String, String>();
    postBody.putIfAbsent('type', () => '${type_selected.toString()}');
    postBody.putIfAbsent('email', () => '${email_Controller.text.toString()}');
    postBody.putIfAbsent('msg', () => '${message_Controller.text.toString()}');

    Uri uri = Uri.parse('https://iraqibayt.com/api/sendMsg_api');
    http.MultipartRequest request = http.MultipartRequest("POST", uri);

    request.fields.addAll(postBody);

    print("start send");
    http.Response response2 = await http.Response.fromStream(
        await request.send());

    var res = json.decode(response2.body);

    if(res["success"] == true){
      setState(() {
        signup_btn_child_index = 0;
      });
      _showDialog("شكراً لك، تم ارسال الرسالة بنجاح!");
    }else{
      setState(() {
        signup_btn_child_index = 0;
      });
      _showDialog("حدث خطأ! يرجى المحاولة لاحقاً.");
    }

  }

  void _showDialog(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('تنبيه'),
            content: new Text(msg),
            actions: <Widget>[
              new RaisedButton(

                child: new Text(
                  'موافق',
                ),

                onPressed: () {
                  Navigator.of(context).pop();
                },

              ),
            ],
          );
        }
    );
  }

  signup_button_child() {
    if (signup_btn_child_index == 0) {
      return Text(
        'أرسل',
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontFamily: "CustomIcons"),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
}