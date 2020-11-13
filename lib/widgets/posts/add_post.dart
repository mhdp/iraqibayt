import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:responsive_grid/responsive_grid.dart';


class Add_Post extends StatefulWidget {

  @override
  _Add_Post createState() => _Add_Post();
}

class _Add_Post extends State<Add_Post> {

  List cat_list = List();
  List sub_cat_list = List();
  List city_list = List();
  List regions_list = List(); //edited line
  List units_list = List(); //edited line
  List Currancies_list = List(); //edited line

  String cat_Selection;
  String sub_cat_Selection;
  String city_Selection;
  String region_Selection;
  String units_Selection;
  String Currancies_Selection;
  String payment_method;

  final title_Controller = TextEditingController();
  final details_Controller = TextEditingController();
  final phone_Controller = TextEditingController();

  var is_sub = false;
  var is_region = false;

  bool phone = false;
  bool whatsapp = false;
  bool telegram = false;
  bool viber = false;

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

    String url = "https://iraqibayt.com/subcategories/$cat_id/fromCat";

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

  Future<String> get_regions(String city_id) async {

    String url = "https://iraqibayt.com/city/region/$city_id/all_list";

    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      regions_list = resBody;
    });

    //print(resBody);

    return "Sucess";
  }

  Future<String> get_Units() async {

    String url = "https://iraqibayt.com/getUnits";

    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      units_list = resBody;
    });

    //print(resBody);

    return "Sucess";
  }

  Future<String> get_Currancies() async {

    String url = "https://iraqibayt.com/getCurrancies";

    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      Currancies_list = resBody;
    });

    //print(resBody);

    return "Sucess";
  }


  void initState() {
    super.initState();
    get_cats();
    get_cities();
    get_Units();
    get_Currancies();
  }




  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
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
        padding: const EdgeInsets.all(15.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Card(
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
                                'اختر قسم',
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
                            padding: const EdgeInsets.all(10.0),
                            child: cat_list.length >0 ? DropdownButton(
                              isExpanded: true,
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

                          ),

                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: is_sub? sub_cat_list.length>0 ? DropdownButton(
                                isExpanded: true,
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

                          ),

                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: city_list.length >0 ? DropdownButton(
                                isExpanded: true,
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
                                    region_Selection = null;
                                    //print(_mycountrySelection);
                                    regions_list.clear();
                                    regions_list = List();
                                    is_region = true;
                                  });
                                  get_regions(newVal);
                                },
                                value: city_Selection,

                              ):Center(child: new GFLoader(type:GFLoaderType.circle)),

                          ),

                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: is_region ? regions_list.length>0 ? DropdownButton(
                                isExpanded: true,
                                hint: SizedBox(
                                    width: MediaQuery.of(context).size.width/2, // for example
                                    child: Text("اختر المنطقة",
                                      textAlign: TextAlign.right,textDirection: TextDirection.rtl,)
                                ),
                                items: regions_list.map((item) {
                                  //_mycitySelection = item['city_id'].toString();
                                  return new DropdownMenuItem(
                                    child: new Text(item['name']),
                                    value: item['id'].toString(),
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  setState(() {
                                    region_Selection = newVal;
                                    //print(_mycitySelection);
                                  });
                                },
                                value: region_Selection,

                              ):Center(child: new GFLoader(type:GFLoaderType.circle)):Container(),

                          ),

                        ])),



                Card(
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
                                'تفاصيل الإعلان',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: "CustomIcons",
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          Padding(
                          padding: const EdgeInsets.all(10),
                          child:TextFormField(
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
                          ),),

                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child:TextFormField(
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
                          ),),


                ])),



                units_list.length >0 ? DropdownButton(
                  hint: SizedBox(
                      width: MediaQuery.of(context).size.width/2, // for example
                      child: Text("اختر وحدة قياس",
                        textAlign: TextAlign.right,textDirection: TextDirection.rtl,)
                  ),
                  items: units_list.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['name']),
                      value: item['id'].toString(),
                    );
                  }).toList(),

                  onChanged: (newVal) {
                    setState(() {
                      units_Selection = newVal;
                    });

                    get_sub_cats(newVal);
                  },
                  value: units_Selection,

                ):Center(child: new GFLoader(type:GFLoaderType.circle)),

                Currancies_list.length >0 ? DropdownButton(
                  hint: SizedBox(
                      width: MediaQuery.of(context).size.width/2, // for example
                      child: Text("اختر العملة",
                        textAlign: TextAlign.right,textDirection: TextDirection.rtl,)
                  ),
                  items: Currancies_list.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['name']),
                      value: item['id'].toString(),
                    );
                  }).toList(),

                  onChanged: (newVal) {
                    setState(() {
                      Currancies_Selection = newVal;
                    });

                    get_sub_cats(newVal);
                  },
                  value: Currancies_Selection,

                ):Center(child: new GFLoader(type:GFLoaderType.circle)),

                DropdownButton(
                    value: payment_method,
                    hint: SizedBox(
                        width: MediaQuery.of(context).size.width/2, // for example
                        child: Text("اختر طريقة الدفع",
                          textAlign: TextAlign.right,textDirection: TextDirection.rtl,)
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text("كاش"),
                        value: "كاش",
                      ),
                      DropdownMenuItem(
                        child: Text("تقسيط"),
                        value: "تقسيط",
                      ),
                      DropdownMenuItem(
                          child: Text("كاش وتقسيط"),
                          value: "كاش وتقسيط"
                      ),

                    ],
                    onChanged: (value) {
                      setState(() {
                        payment_method = value;
                      });
                    }),




                Card(
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
                                'معلومات التواصل',
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
                            padding: const EdgeInsets.all(10.0),
                            child:TextFormField(
                            controller: phone_Controller,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(5.0),
                                  ),
                                ),
                                hintText: "رقم الاتصال"),
                          ),),
                          Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('يمكن التواصل عن طريق'),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,

                                  children: <Widget>[
                                    //phone number

                                    // connection methodes
                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          // [Monday] checkbox
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.phone, color: Colors.black, size: 30.0,),
                                              Checkbox(
                                                value: phone,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    phone = value;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          // [Tuesday] checkbox
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.whatsapp, color: Color(0XFF63a63a), size: 30.0,),
                                              Checkbox(
                                                value: whatsapp,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    whatsapp = value;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          // [Wednesday] checkbox
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.telegram, color: Color(0xFF51a1d3), size: 30.0,),
                                              Checkbox(
                                                value: telegram,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    telegram = value;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),

                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.viber, color: Color(0xFF6c439a), size: 30.0,),
                                              Checkbox(
                                                value: viber,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    viber = value;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ])),
                          ])),

                Column(
                  children: <Widget>[
                    //Center(child: Text('Error: $_error')),
                    RaisedButton(
                      child: Text("Pick images"),
                      onPressed: loadAssets,
                    ),

                     buildGridView(),

                  ],
                ),

              ])
        )
      ]
        )
      ),
        )
    );

    /*return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(child: Text('Error: $_error')),
            RaisedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
    );*/

  }


  /////multiselect images////
  List<Asset> images = List<Asset>();
  String _error;

  Widget buildGridView() {
    if (images != null)
      return ResponsiveGridRow(
        children: [for(var i = 0; i < images.length; i++) ResponsiveGridCol(
          xs: 6,
          md: 4,
          child: Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(0),
              /*decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFebebeb),

              ),*/
              height: 300,
              alignment: Alignment(0, 0),
              //color: Colors.grey,
              child: AssetThumb(
                asset: images[i],
                width: 300,
                height: 300,

              ),
          ),
        ),],);
    else
      return Container();
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 30,
        enableCamera: true,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

}