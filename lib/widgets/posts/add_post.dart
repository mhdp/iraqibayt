import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/db_helper.dart';

class Add_Post extends StatefulWidget {

  @override
  _Add_Post createState() => _Add_Post();
}

class _Add_Post extends State<Add_Post> {

  List cat_list = List();
  List sub_cat_list = List();
  List city_list = List();
  List regions_list = List(); //edited line

  String cat_Selection;
  String sub_cat_Selection;
  String city_Selection;
  String region_Selection;


  final title_Controller = TextEditingController();
  final details_Controller = TextEditingController();

  var is_sub = false;
  Future<String> get_cats() async {

    String url = "https://iraqibayt.com/getCategories";

    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      cat_list = resBody;
    });

    //print(resBody);

    return "Sucess";
  }

  Future<String> get_sub_cats(String cat_id) async {

    String url = "subcategories/$cat_id/fromCat";

    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      sub_cat_list = resBody;
    });

    //print(resBody);

    return "Sucess";
  }

  Future<String> get_cities() async {

    String url = "https://iraqibayt.com/getCities";

    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      city_list = resBody;
    });

    //print(resBody);

    return "Sucess";
  }


  void initState() {
    super.initState();
    get_cats();
    get_cities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        backgroundColor: Color(0xFF335876),

        title: Text(
          "أضف إعلان جديد",
          style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0
            , fontFamily: "CustomIcons", ),
        ),

      ),
      body :SingleChildScrollView(
        child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [

        Padding(
        padding: const EdgeInsets.all(30.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                cat_list.length >0 ? DropdownButton(
                  hint: SizedBox(
                      width: MediaQuery.of(context).size.width/2, // for example
                      child: Text("اختر قسم رئيسي",
                        textAlign: TextAlign.right,textDirection: TextDirection.rtl,)
                  ),
                  items: cat_list.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['name']),
                      value: item['id'].toString(),
                    );
                  }).toList(),

                  onChanged: (newVal) {
                    setState(() {
                     cat_Selection = newVal;
                     sub_cat_Selection = null;
                     //print(_mycountrySelection);
                     sub_cat_list.clear();
                     sub_cat_list = List();
                     is_sub = true;
                    });

                    get_sub_cats(newVal);
                  },
                  value: cat_Selection,

                ):Center(child: new GFLoader(type:GFLoaderType.circle)),

                is_sub ? sub_cat_list.length>0 ? DropdownButton(
                  hint: SizedBox(
                      width: MediaQuery.of(context).size.width/2, // for example
                      child: Text("اختر قسم فرعي",
                        textAlign: TextAlign.right,textDirection: TextDirection.rtl,)
                  ),
                  items: sub_cat_list.map((item) {
                    //_mycitySelection = item['city_id'].toString();
                    return new DropdownMenuItem(
                      child: new Text(item['name']),
                      value: item['id'].toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      sub_cat_Selection = newVal;
                      //print(_mycitySelection);
                    });
                  },
                  value: sub_cat_Selection,

                ):Center(child: new GFLoader(type:GFLoaderType.circle)):Container(),

                SizedBox(
                  height: 20,
                ),

                city_list.length >0 ? DropdownButton(
                  hint: SizedBox(
                      width: MediaQuery.of(context).size.width/2, // for example
                      child: Text("اختر مدينة",
                        textAlign: TextAlign.right,textDirection: TextDirection.rtl,)
                  ),
                  items: city_list.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['name']),
                      value: item['id'].toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      city_Selection = newVal;

                    });
                  },
                  value: city_Selection,

                ):Center(child: new GFLoader(type:GFLoaderType.circle)),

                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: title_Controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5.0),
                        ),
                      ),
                      hintText: "عنوان الإعلان"),
                ),

                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: details_Controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5.0),
                        ),
                      ),
                      hintText: "تفاصيل الإعلان"),
                ),
                ])
        )
      ]
        )
      ),

    );
  }

}