import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Contact_us_card extends StatefulWidget {
  @override
  _Contact_us_card createState() => _Contact_us_card();
}

class _Contact_us_card extends State<Contact_us_card> {

  int signup_btn_child_index = 0;
  String type_selected;
  final email_Controller = TextEditingController();
  final message_Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(10.0),
      //color: Colors.grey,
      elevation: 0,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              padding: const EdgeInsets.all(3.0),
              color: Color(0xff275879),
              child: Text(
                'أرسل ملاحظاتك',
                style: TextStyle(
                  fontSize: 18,
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
    );
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