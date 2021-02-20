import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http_parser/http_parser.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/home/home.dart';
import 'package:iraqibayt/widgets/my_account.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../ContactUs.dart';
import '../my_icons_icons.dart';
import '../profile.dart';

class UpdatePost extends StatefulWidget {
  String postId;

  UpdatePost({Key key, this.postId}) : super(key: key);

  @override
  _UpdatePost createState() => _UpdatePost();
}

class _UpdatePost extends State<UpdatePost> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  List cat_list = List();
  List sub_cat_list = List();
  List city_list = List();
  List regions_list = List(); //edited line
  List units_list = List(); //edited line
  List Currancies_list = List(); //edited line
  List<File> listFile = List<File>();
  List<String> imageList = new List<String>();

  var is_loading = true;

  String cat_Selection;
  String sub_cat_Selection;
  String city_Selection;
  String region_Selection;
  String units_Selection;
  String Currancies_Selection;
  String bath_Selection;
  String beed_Selection;
  String car_Selection;
  String car_number_Selection;
  String payment_method;

  final title_Controller = TextEditingController();
  final details_Controller = TextEditingController();
  final phone_Controller = TextEditingController();
  final area_Controller = TextEditingController();
  final price_Controller = TextEditingController();
  final floor_Controller = TextEditingController();
  final floor_num_Controller = TextEditingController();
  final car_num_Controller = TextEditingController();

  var is_sub = false;
  var is_region = false;
  var is_home = false;
  bool phone = false;
  bool whatsapp = false;
  bool telegram = false;
  bool viber = false;
  int signup_btn_child_index = 0;
  var _guest = false;

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
      print(sub_cat_list.toString());
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

  Widget _submit_signup_Button() {
    return InkWell(
      onTap: () {
        send_post();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          /*boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],*/
          /*gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])*/
          color: Color(0xff65AECA),
        ),
        child: signup_button_child(),
      ),
    );
  }

  signup_button_child() {
    if (signup_btn_child_index == 0) {
      return Text(
        'تعديل الإعلان',
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontFamily: "CustomIcons"),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  _checkIfGuest() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');
    if (value != '1') {
      setState(() {
        _guest = true;
        //_username = 'زائر';
      });
    } else {
      final key = 'name';
      final value = prefs.get(key);
      setState(() {
        _guest = false;
      });
    }
  }

  void _fillFormData() {
    databaseHelper.get_post_by_id(widget.postId).whenComplete(() {
      //print(databaseHelper.get_post_by_id_list.length.toString());
      setState(() async {
        //print("img: ${databaseHelper.get_post_by_id_list[0]["img"].toString()}");

//        if (databaseHelper.get_post_by_id_list[0]["img"].toString().isEmpty) {
//          databaseHelper.get_default_post_image().whenComplete(() {
//            setState(() {
//              String default_image = databaseHelper.default_post_image;
//              imageList.add(
//                  "https://iraqibayt.com/storage/app/public/posts/$default_image");
//            });
//          });
//        } else {
//          imageList.add(
//              'https://iraqibayt.com/storage/app/public/posts/${databaseHelper.get_post_by_id_list[0]["img"].toString()}');
//        }

        is_loading = false;
        setState(() {
          cat_Selection =
              databaseHelper.get_post_by_id_list[0]["category_id"].toString();
          get_sub_cats(cat_Selection).then((value) {
            is_sub = true;
            sub_cat_Selection =
                databaseHelper.get_post_by_id_list[0]["subcat_id"].toString();

            for (var sub_type in sub_cat_list) {
              if (sub_type["id"].toString() == sub_cat_Selection) {
                print(sub_type["type"]);
                if (sub_type["type"] == "سكني") {
                  setState(() {
                    is_home = true;
                    print('got here');
                  });
                } else {
                  setState(() {
                    is_home = false;
                    print('got there');
                  });
                }
              }
            }
          });

          city_Selection =
              databaseHelper.get_post_by_id_list[0]["city_id"].toString();
          get_regions(city_Selection).then((value) {
            is_region = true;
            region_Selection =
                databaseHelper.get_post_by_id_list[0]["region_id"].toString();
          });

          //if (is_home) {
          beed_Selection =
              databaseHelper.get_post_by_id_list[0]["bedroom"].toString();
          bath_Selection =
              databaseHelper.get_post_by_id_list[0]["bathroom"].toString();
          car_Selection =
              databaseHelper.get_post_by_id_list[0]["carage"].toString();
          car_num_Controller.text =
              databaseHelper.get_post_by_id_list[0]["num_car"].toString();
          floor_Controller.text =
              databaseHelper.get_post_by_id_list[0]["floor"].toString();
          floor_num_Controller.text =
              databaseHelper.get_post_by_id_list[0]["num_floor"].toString();
          //}

          title_Controller.text =
              databaseHelper.get_post_by_id_list[0]["title"].toString();
          details_Controller.text =
              databaseHelper.get_post_by_id_list[0]["description"].toString();
          area_Controller.text =
              databaseHelper.get_post_by_id_list[0]["area"].toString();

          units_Selection =
              databaseHelper.get_post_by_id_list[0]["unit_id"].toString();
          price_Controller.text =
              databaseHelper.get_post_by_id_list[0]["price"].toString();
          Currancies_Selection =
              databaseHelper.get_post_by_id_list[0]["currancy_id"].toString();
          payment_method =
              databaseHelper.get_post_by_id_list[0]["payment"].toString();

          phone_Controller.text =
              databaseHelper.get_post_by_id_list[0]["phone"].toString();

          if (databaseHelper.get_post_by_id_list[0]["contact"]
              .toString()
              .contains('إتصال مباشر')) {
            setState(() {
              phone = true;
            });
          }

          if (databaseHelper.get_post_by_id_list[0]["contact"]
              .toString()
              .contains('تلغرام')) {
            setState(() {
              telegram = true;
            });
          }

          if (databaseHelper.get_post_by_id_list[0]["contact"]
              .toString()
              .contains('فايبر')) {
            setState(() {
              viber = true;
            });
          }

          if (databaseHelper.get_post_by_id_list[0]["contact"]
              .toString()
              .contains('واتسآب')) {
            setState(() {
              whatsapp = true;
            });
          }
        });

        if(databaseHelper.get_post_by_id_list[0]["img"] != null || databaseHelper.get_post_by_id_list[0]["img"].toString().isNotEmpty){
            print("imag one : ${databaseHelper.get_post_by_id_list[0]["img"].toString()}");
            File img_one = await urlToFile(databaseHelper.get_post_by_id_list[0]["img"].toString());
            images_files.add(img_one);
            //Asset asset_one = await fileToAsset(img_one);
            //images.add(asset_one);
            //print(images.length.toString());

        }

        String imgs_list1 = databaseHelper.get_post_by_id_list[0]["imgs"]
            .toString()
            .replaceAll("[", "");
        imgs_list1 = imgs_list1.replaceAll("]", "");
        imgs_list1 = imgs_list1.replaceAll(" ", "");

        List<String> imgs = imgs_list1.split(",");
        //print(imgs.length.toString());
        imgs.forEach((element) async {
          //print(element.toString());
          if (!element.isEmpty) {
            print("enter $element");
            /*imageList
                .add('https://iraqibayt.com/storage/app/public/posts/$element');*/

            File img_one = await urlToFile(element.toString());
            images_files.add(img_one);
            setState(() {

            });
          }
        });
        print("images file : ${images_files.length.toString()}");
        setState(() {

        });



        //print(databaseHelper.get_post_by_id_list[0]["imgs"].toString());
//        String imgs_list1 = databaseHelper.get_post_by_id_list[0]["imgs"]
//            .toString()
//            .replaceAll("[", "");
//        imgs_list1 = imgs_list1.replaceAll("]", "");
//        imgs_list1 = imgs_list1.replaceAll(" ", "");
//
//        List<String> imgs = imgs_list1.split(",");
//        //print(imgs.length.toString());
//        imgs.forEach((element) {
//          //print(element.toString());
//          if (!element.isEmpty) {
//            print("enter $element");
//            imageList
//                .add('https://iraqibayt.com/storage/app/public/posts/$element');
//          }
//        });

        //print(imageList.length);
        //imageList = Set.from(imgs);
        //print(imgs);


      });
    });
  }

  List<File> images_files = [];

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    //Directory tempDir = await getTemporaryDirectory();
    Directory documentDirectory = await getApplicationDocumentsDirectory();

// get temporary path from temporary directory.
    String tempPath = documentDirectory.path;


// create a new file in temporary path with random file name.
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.jpg');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get("https://iraqibayt.com/storage/app/public/posts/$imageUrl");
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  var uuid = Uuid();

  Future<Asset> fileToAsset(File image) async {
    String fileName = Path.basename(image.path);
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    return Asset(uuid.v4(), fileName, decodedImage.width, decodedImage.height);
  }

  void initState() {
    super.initState();
    _checkIfGuest();
    get_cats();
    get_cities();
    get_Units();
    get_Currancies();

    _fillFormData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF8e8d8d),
      appBar: AppBar(
        backgroundColor: Color(0xFF335876),
        title: Text(
          "تعديل الإعلان",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            fontFamily: "CustomIcons",
          ),
        ),
        actions: [
          FirebaseAgent(),
        ],
      ),
      body: _guest
          ? Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(0),
              ),
              //clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.only(top: 10),
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
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: "CustomIcons",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          'الرجاء تسجيل الدخول لتتمكن من إضافة إعلان',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'CustomIcons',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        FlatButton(
                          color: Color(0xFF335876),
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.grey,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.orange,
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          child: Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: "CustomIcons",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            //choos dropdowns
                            Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.antiAlias,
                                margin: const EdgeInsets.all(10.0),
                                //color: Colors.grey,
                                elevation: 0,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                                        child: cat_list.length > 0
                                            ? DropdownButtonFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(7),
                                                  filled: true,
                                                  fillColor: Color(0xFFe8e8e8),
                                                  border:
                                                      const OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      const Radius.circular(
                                                          5.0),
                                                    ),
                                                  ),
                                                ),
                                                isExpanded: true,
                                                hint: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2, // for example
                                                    child: Text(
                                                      'اختر القسم الرئيسي',
                                                      textAlign:
                                                          TextAlign.right,
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    )),
                                                items: cat_list.map((item) {
                                                  return new DropdownMenuItem(
                                                    child:
                                                        new Text(item['name']),
                                                    value:
                                                        item['id'].toString(),
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
                                              )
                                            : Center(
                                                child: new GFLoader(
                                                    type: GFLoaderType.circle)),
                                      ),
                                      is_sub
                                          ? sub_cat_list.length > 0
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child:
                                                      DropdownButtonFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(7),
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xFFe8e8e8),
                                                      border:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          const Radius.circular(
                                                              5.0),
                                                        ),
                                                      ),
                                                    ),
                                                    isExpanded: true,
                                                    hint: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2, // for example
                                                        child: Text(
                                                          'اختر القسم الفرعي',
                                                          textAlign:
                                                              TextAlign.right,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                        )),
                                                    items: sub_cat_list
                                                        .map((item) {
                                                      //_mycitySelection = item['city_id'].toString();
                                                      return new DropdownMenuItem(
                                                        child: new Text(
                                                            item['name']),
                                                        value: item['id']
                                                            .toString(),
                                                      );
                                                    }).toList(),
                                                    onChanged: (newVal) {
                                                      setState(() {
                                                        sub_cat_Selection =
                                                            newVal;

                                                        for (var sub_type
                                                            in sub_cat_list) {
                                                          if (sub_type["id"]
                                                                  .toString() ==
                                                              newVal
                                                                  .toString()) {
                                                            print(sub_type[
                                                                    "type"]
                                                                .toString());

                                                            if (sub_type["type"]
                                                                    .toString() ==
                                                                "سكني") {
                                                              is_home = true;
                                                            } else {
                                                              is_home = false;
                                                            }
                                                          }
                                                        }
                                                        //print(_mycitySelection);
                                                      });
                                                    },
                                                    value: sub_cat_Selection,
                                                  ))
                                              : Center(
                                                  child: new GFLoader(
                                                      type:
                                                          GFLoaderType.circle))
                                          : Container(),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: city_list.length > 0
                                            ? DropdownButtonFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(7),
                                                  filled: true,
                                                  fillColor: Color(0xFFe8e8e8),
                                                  border:
                                                      const OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      const Radius.circular(
                                                          5.0),
                                                    ),
                                                  ),
                                                ),
                                                isExpanded: true,
                                                hint: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2, // for example
                                                    child: Text(
                                                      "اختر مدينة",
                                                      textAlign:
                                                          TextAlign.right,
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    )),
                                                items: city_list.map((item) {
                                                  return new DropdownMenuItem(
                                                    child:
                                                        new Text(item['name']),
                                                    value:
                                                        item['id'].toString(),
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
                                              )
                                            : Center(
                                                child: new GFLoader(
                                                    type: GFLoaderType.circle)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: is_region
                                            ? regions_list.length > 0
                                                ? DropdownButtonFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(7),
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xFFe8e8e8),
                                                      border:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          const Radius.circular(
                                                              5.0),
                                                        ),
                                                      ),
                                                    ),
                                                    isExpanded: true,
                                                    hint: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2, // for example
                                                        child: Text(
                                                          "اختر المنطقة",
                                                          textAlign:
                                                              TextAlign.right,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                        )),
                                                    items: regions_list
                                                        .map((item) {
                                                      //_mycitySelection = item['city_id'].toString();
                                                      return new DropdownMenuItem(
                                                        child: new Text(
                                                            item['name']),
                                                        value: item['id']
                                                            .toString(),
                                                      );
                                                    }).toList(),
                                                    onChanged: (newVal) {
                                                      setState(() {
                                                        region_Selection =
                                                            newVal;
                                                        //print(_mycitySelection);
                                                      });
                                                    },
                                                    value: region_Selection,
                                                  )
                                                : Center(
                                                    child: new GFLoader(
                                                        type: GFLoaderType
                                                            .circle))
                                            : Container(),
                                      ),
                                    ])),
                            //home details
                            is_home
                                ? Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    margin: const EdgeInsets.all(10.0),
                                    //color: Colors.grey,
                                    elevation: 0,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              color: Color(0xff275879),
                                              child: Text(
                                                'تفاصيل المسكن',
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
                                              padding: const EdgeInsets.all(5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child:
                                                            DropdownButtonFormField(
                                                          decoration:
                                                              const InputDecoration(
                                                            isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    7),
                                                            filled: true,
                                                            fillColor: Color(
                                                                0xFFe8e8e8),
                                                            border:
                                                                const OutlineInputBorder(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                const Radius
                                                                        .circular(
                                                                    5.0),
                                                              ),
                                                            ),
                                                          ),
                                                          isExpanded: true,
                                                          hint: SizedBox(
                                                              //width: MediaQuery.of(context).size.width/2, // for example
                                                              child: Text(
                                                            "عدد غرف النوم",
                                                            textAlign:
                                                                TextAlign.right,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                          )),
                                                          items: [
                                                            DropdownMenuItem(
                                                              value: "1",
                                                              child: Text(
                                                                "1",
                                                              ),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: "2",
                                                              child: Text(
                                                                "2",
                                                              ),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: "3",
                                                              child: Text(
                                                                "3",
                                                              ),
                                                            ),
                                                            DropdownMenuItem(
                                                              value:
                                                                  "أكثر من 3",
                                                              child: Text(
                                                                "أكثر من 3",
                                                              ),
                                                            ),
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              beed_Selection =
                                                                  value;
                                                            });
                                                          },
                                                          value: beed_Selection,
                                                        )),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child:
                                                            DropdownButtonFormField(
                                                          decoration:
                                                              const InputDecoration(
                                                            isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    7),
                                                            filled: true,
                                                            fillColor: Color(
                                                                0xFFe8e8e8),
                                                            border:
                                                                const OutlineInputBorder(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                const Radius
                                                                        .circular(
                                                                    5.0),
                                                              ),
                                                            ),
                                                          ),
                                                          isExpanded: true,
                                                          hint: SizedBox(
                                                              //width: MediaQuery.of(context).size.width/2, // for example
                                                              child: Text(
                                                            "عدد الحمامات",
                                                            textAlign:
                                                                TextAlign.right,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                          )),
                                                          items: [
                                                            DropdownMenuItem(
                                                              value: "1",
                                                              child: Text(
                                                                "1",
                                                              ),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: "2",
                                                              child: Text(
                                                                "2",
                                                              ),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: "3",
                                                              child: Text(
                                                                "3",
                                                              ),
                                                            ),
                                                            DropdownMenuItem(
                                                              value:
                                                                  "أكثر من 3",
                                                              child: Text(
                                                                "أكثر من 3",
                                                              ),
                                                            ),
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              bath_Selection =
                                                                  value;
                                                            });
                                                          },
                                                          value: bath_Selection,
                                                        )),
                                                  )
                                                ],
                                              )),

                                          //carage
                                          Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child:
                                                            DropdownButtonFormField(
                                                          decoration:
                                                              const InputDecoration(
                                                            isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    7),
                                                            filled: true,
                                                            fillColor: Color(
                                                                0xFFe8e8e8),
                                                            border:
                                                                const OutlineInputBorder(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                const Radius
                                                                        .circular(
                                                                    5.0),
                                                              ),
                                                            ),
                                                          ),
                                                          isExpanded: true,
                                                          hint: SizedBox(
                                                              //width: MediaQuery.of(context).size.width/2, // for example
                                                              child: Text(
                                                            "الكراج",
                                                            textAlign:
                                                                TextAlign.right,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                          )),
                                                          items: [
                                                            DropdownMenuItem(
                                                              value:
                                                                  "تحتوي كراج",
                                                              child: Text(
                                                                "تحتوي كراج",
                                                              ),
                                                            ),
                                                            DropdownMenuItem(
                                                              value:
                                                                  "لا تحتوي كراج",
                                                              child: Text(
                                                                "لا تحتوي كراج",
                                                              ),
                                                            ),
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              car_Selection =
                                                                  value;
                                                            });
                                                          },
                                                          value: car_Selection,
                                                        )),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: TextFormField(
                                                      controller:
                                                          car_num_Controller,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLines: null,
                                                      textAlign:
                                                          TextAlign.right,
                                                      decoration:
                                                          InputDecoration(
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(7),
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFFe8e8e8),
                                                              border:
                                                                  new OutlineInputBorder(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  const Radius
                                                                          .circular(
                                                                      5.0),
                                                                ),
                                                              ),
                                                              hintText:
                                                                  "عدد السيارات"),
                                                    ),
                                                  ))
                                                ],
                                              )),

                                          Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: TextFormField(
                                                      controller:
                                                          floor_Controller,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLines: null,
                                                      textAlign:
                                                          TextAlign.right,
                                                      decoration:
                                                          InputDecoration(
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(7),
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFFe8e8e8),
                                                              border:
                                                                  new OutlineInputBorder(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  const Radius
                                                                          .circular(
                                                                      5.0),
                                                                ),
                                                              ),
                                                              hintText:
                                                                  "الطابق"),
                                                    ),
                                                  )),
                                                  Expanded(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: TextFormField(
                                                      controller:
                                                          floor_num_Controller,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLines: null,
                                                      textAlign:
                                                          TextAlign.right,
                                                      decoration:
                                                          InputDecoration(
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(7),
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFFe8e8e8),
                                                              border:
                                                                  new OutlineInputBorder(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  const Radius
                                                                          .circular(
                                                                      5.0),
                                                                ),
                                                              ),
                                                              hintText:
                                                                  "عدد الطوابق"),
                                                    ),
                                                  ))
                                                ],
                                              )),
                                        ]))
                                : Container(),

                            //post details
                            Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.antiAlias,
                                margin: const EdgeInsets.all(10.0),
                                //color: Colors.grey,
                                elevation: 0,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                                        child: TextFormField(
                                          controller: title_Controller,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(7),
                                              filled: true,
                                              fillColor: Color(0xFFe8e8e8),
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(5.0),
                                                ),
                                              ),
                                              hintText: "عنوان الإعلان"),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: TextFormField(
                                          controller: details_Controller,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(7),
                                              filled: true,
                                              fillColor: Color(0xFFe8e8e8),
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(5.0),
                                                ),
                                              ),
                                              hintText: "تفاصيل الإعلان"),
                                        ),
                                      ),
                                      /*SizedBox(
                            height: 5,
                          ),*/
                                      Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: TextFormField(
                                                      controller:
                                                          area_Controller,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Color(0xFFe8e8e8),
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                5), // Added this

                                                        border:
                                                            new OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(5.0),
                                                          ),
                                                        ),
                                                        hintText: "المساحة",
                                                        hintStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    )),
                                              ),
                                              Expanded(
                                                child: units_list.length > 0
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child:
                                                            DropdownButtonFormField(
                                                          decoration:
                                                              const InputDecoration(
                                                            isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    7),
                                                            filled: true,
                                                            fillColor: Color(
                                                                0xFFe8e8e8),
                                                            border:
                                                                const OutlineInputBorder(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                const Radius
                                                                        .circular(
                                                                    5.0),
                                                              ),
                                                            ),
                                                          ),
                                                          isExpanded: true,
                                                          hint: SizedBox(
                                                              //width: MediaQuery.of(context).size.width/2, // for example
                                                              child: Text(
                                                            "اختر وحدة قياس",
                                                            textAlign:
                                                                TextAlign.right,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                          )),
                                                          items: units_list
                                                              .map((item) {
                                                            return new DropdownMenuItem(
                                                              child: new Text(
                                                                  item['name']),
                                                              value: item['id']
                                                                  .toString(),
                                                            );
                                                          }).toList(),
                                                          onChanged: (newVal) {
                                                            setState(() {
                                                              units_Selection =
                                                                  newVal;
                                                            });
                                                          },
                                                          value:
                                                              units_Selection,
                                                        ))
                                                    : Center(
                                                        child: new GFLoader(
                                                            type: GFLoaderType
                                                                .circle)),
                                              )
                                            ],
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: TextFormField(
                                                      controller:
                                                          price_Controller,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Color(0xFFe8e8e8),
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                5), // Added this

                                                        border:
                                                            new OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(5.0),
                                                          ),
                                                        ),
                                                        hintText: "سعر العقار",
                                                        hintStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    )),
                                              ),
                                              Expanded(
                                                child: Currancies_list.length >
                                                        0
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child:
                                                            DropdownButtonFormField(
                                                          decoration:
                                                              const InputDecoration(
                                                            isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    7),
                                                            filled: true,
                                                            fillColor: Color(
                                                                0xFFe8e8e8),
                                                            border:
                                                                const OutlineInputBorder(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                const Radius
                                                                        .circular(
                                                                    5.0),
                                                              ),
                                                            ),
                                                          ),
                                                          isExpanded: true,
                                                          hint: SizedBox(
                                                              //width: MediaQuery.of(context).size.width/2, // for example
                                                              child: Text(
                                                            "اختر العملة",
                                                            textAlign:
                                                                TextAlign.right,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                          )),
                                                          items: Currancies_list
                                                              .map((item) {
                                                            return new DropdownMenuItem(
                                                              child: new Text(
                                                                  item['name']),
                                                              value: item['id']
                                                                  .toString(),
                                                            );
                                                          }).toList(),
                                                          onChanged: (newVal) {
                                                            setState(() {
                                                              Currancies_Selection =
                                                                  newVal;
                                                            });
                                                          },
                                                          value:
                                                              Currancies_Selection,
                                                        ))
                                                    : Center(
                                                        child: new GFLoader(
                                                            type: GFLoaderType
                                                                .circle)),
                                              )
                                            ],
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: DropdownButtonFormField(
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(7),
                                              filled: true,
                                              fillColor: Color(0xFFe8e8e8),
                                              border: const OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(5.0),
                                                ),
                                              ),
                                            ),
                                            value: payment_method,
                                            hint: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2, // for example
                                                child: Text(
                                                  "اختر طريقة الدفع",
                                                  textAlign: TextAlign.right,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                )),
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
                                                  value: "كاش وتقسيط"),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                payment_method = value;
                                              });
                                            }),
                                      )
                                    ])),

                            //choose images
                            Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.antiAlias,
                                margin: const EdgeInsets.all(10.0),
                                //color: Colors.grey,
                                elevation: 0,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                          padding: const EdgeInsets.all(3.0),
                                          color: Color(0xff275879),
                                          child: Text(
                                            'اختر صور العقار',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontFamily: "CustomIcons",
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          //Center(child: Text('Error: $_error')),
                                          image_button(),

                                          buildGridView(),
                                        ],
                                      ),
                                    ])),

                            //contact information
                            Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.antiAlias,
                                margin: const EdgeInsets.all(10.0),
                                //color: Colors.grey,
                                elevation: 0,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                                        child: TextFormField(
                                          controller: phone_Controller,
                                          keyboardType: TextInputType.number,
                                          maxLines: null,
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(7),
                                              filled: true,
                                              fillColor: Color(0xFFe8e8e8),
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(5.0),
                                                ),
                                              ),
                                              hintText: "رقم الاتصال"),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text('يمكن التواصل عن طريق'),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center, //Center Row contents horizontally,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center, //Center Row contents vertically,

                                              children: <Widget>[
                                                //phone number

                                                // connection methodes
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      // [Monday] checkbox
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .phone,
                                                            color: Colors.black,
                                                            size: 30.0,
                                                          ),
                                                          Checkbox(
                                                            value: phone,
                                                            onChanged:
                                                                (bool value) {
                                                              setState(() {
                                                                phone = value;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      // [Tuesday] checkbox
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .whatsapp,
                                                            color: Color(
                                                                0XFF63a63a),
                                                            size: 30.0,
                                                          ),
                                                          Checkbox(
                                                            value: whatsapp,
                                                            onChanged:
                                                                (bool value) {
                                                              setState(() {
                                                                whatsapp =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      // [Wednesday] checkbox
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .telegram,
                                                            color: Color(
                                                                0xFF51a1d3),
                                                            size: 30.0,
                                                          ),
                                                          Checkbox(
                                                            value: telegram,
                                                            onChanged:
                                                                (bool value) {
                                                              setState(() {
                                                                telegram =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),

                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .viber,
                                                            color: Color(
                                                                0xFF6c439a),
                                                            size: 30.0,
                                                          ),
                                                          Checkbox(
                                                            value: viber,
                                                            onChanged:
                                                                (bool value) {
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

                            _submit_signup_Button(),
                          ]))
                ])),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF335876),
        unselectedItemColor: Colors.white,
        selectedItemColor: Color(0xFFdd685f),
        onTap: onTabTapped, // new
        currentIndex: 2,
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
              icon: Icon(Icons.post_add), label: 'أضف إعلان'),
          new BottomNavigationBarItem(icon: Icon(MyIcons.user), label: 'حسابي'),
          new BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'ملاحظات'),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) => new Home()),
      );
    } else if (index == 1) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Posts_Home()),
      );
    } else if (index == 3) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new MyAccount()));
    } else if (index == 4) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new ContactUs()));
    }
    /*setState(() {
      _currentIndex = index;
      print(index.toString());
    });*/
  }

  /////multiselect images////
  List<Asset> images = List<Asset>();
  String _error;

  Widget image_button() {
    return InkWell(
      onTap: () {
        loadAssets();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(
            top: 10.0, right: 10.0, left: 10.0, bottom: 10),
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color(0xFFdd685f),
        ),
        child: Text(
          'انقر لاختيار الصور',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontFamily: "CustomIcons"),
        ),
      ),
    );
  }

  Widget buildGridView() {
    print(' images list: ${images.length.toString()}');
    if (images != null || images_files != null)
      return ResponsiveGridRow(
        children: [
          for (var i = 0; i < images_files.length; i++)
            ResponsiveGridCol(
              xs: 6,
              md: 4,
              child: Container(
                margin: const EdgeInsets.all(3.0),
                padding: const EdgeInsets.all(0),
                /*decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFebebeb),

              ),*/
                height: 180,
                alignment: Alignment(0, 0),
                //color: Colors.grey,
                child: Column(children: [
                  Image.file(
                   images_files[i],
                ),
                  IconButton(
                    icon:
                    Icon(Icons.delete),
                    color:
                    Colors.red,
                    onPressed:
                        () {
                      setState(() {
                        //print(images.length.toString());
                        //images.remove(i);
                        images_files.removeAt(i);
                        //print(images.length.toString());

                      });
                      //_deletePost(post.id);
                    },
                  ),
                ],),
              ),
            ),
          for (var i = 0; i < images.length; i++)
            ResponsiveGridCol(
              xs: 6,
              md: 4,
              child: Container(
                margin: const EdgeInsets.all(3.0),
                padding: const EdgeInsets.all(0),
                /*decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFebebeb),

              ),*/
                height: 230,
                alignment: Alignment(0, 0),
                //color: Colors.grey,
                child: Column(children: [AssetThumb(
                  asset: images[i],
                  width: 300,
                  height: 300,
                ),
                  IconButton(
                    icon:
                    Icon(Icons.delete),
                    color:
                    Colors.red,
                    onPressed:
                        () {
                      setState(() {
                        print(images.length.toString());
                        //images.remove(i);
                        images.removeAt(i);
                        print(images.length.toString());

                      });
                      //_deletePost(post.id);
                    },
                  ),
                ]),
              ),
            ),
        ],
      );
    else
      return Container();
  }

  Future<void> loadAssets() async {
    List<Asset> images_temp = List<Asset>();

    setState(() {
      images_temp = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 30,
        enableCamera: true,
        selectedAssets: images,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList ;
    });
  }

  send_post() async {
    if (signup_btn_child_index == 0) {
      setState(() {
        signup_btn_child_index = 1;
      });

      /////////form validation/////////////

      //category and sub
      if (cat_Selection == "" || cat_Selection == null) {
        _showDialog("يرجى اختيار القسم الرئيسي.");
        setState(() {
          signup_btn_child_index = 0;
        });
        return;
      }

      //check sub
      if (sub_cat_Selection == "" || sub_cat_Selection == null) {
        _showDialog("يرجى اختيار القسم الفرعي.");
        setState(() {
          signup_btn_child_index = 0;
        });

        return;
      }

      //check home details
      for (var sub_type in sub_cat_list) {
        if (sub_type["id"].toString() == sub_cat_Selection.toString()) {
          print(sub_type["type"].toString());

          if (sub_type["type"].toString() == "سكني") {
            //beedroom check
            if (beed_Selection == "" || beed_Selection == null) {
              _showDialog("يرجى اختيار عدد غرف النوم.");
              setState(() {
                signup_btn_child_index = 0;
              });
              return;
            }

            //bathroom check
            if (bath_Selection == "" || bath_Selection == null) {
              _showDialog("يرجى اختيار عدد الحمامات.");
              setState(() {
                signup_btn_child_index = 0;
              });
              return;
            }

            //carage check
            if (car_Selection == "" || car_Selection == null) {
              _showDialog("يرجى اختيار الكراج.");
              setState(() {
                signup_btn_child_index = 0;
              });
              return;
            }

            if (car_Selection == "تحتوي كراج") {
              //check cars number
              //carage check
              if (car_num_Controller.text == "" ||
                  car_num_Controller.text == null) {
                _showDialog("يرجى اختيار عدد السيارات في الكراج");
                setState(() {
                  signup_btn_child_index = 0;
                });
                return;
              }
            }
          }
        }
      }

      //check city
      if (city_Selection == "" || city_Selection == null) {
        _showDialog("يرجى اختيار المدينة.");
        setState(() {
          signup_btn_child_index = 0;
        });
        return;
      }

      //check region
      if (region_Selection == "" || region_Selection == null) {
        _showDialog("يرجى اختيار المنطقة.");
        setState(() {
          signup_btn_child_index = 0;
        });
        return;
      }

      //check post title
      if (title_Controller.text == "" || title_Controller.text == null) {
        _showDialog("يرجى إدخال عنوان الإعلان.");
        setState(() {
          signup_btn_child_index = 0;
        });
        return;
      }

      //check post details
      if (details_Controller.text == "" || details_Controller.text == null) {
        _showDialog("يرجى إدخال تفاصيل الإعلان.");
        setState(() {
          signup_btn_child_index = 0;
        });
        return;
      }

      //check area
      if (area_Controller.text == "" || area_Controller.text == null) {
        _showDialog("يرجى إدخال مساحة العقار.");
        setState(() {
          signup_btn_child_index = 0;
        });
        return;
      }

      //check unite
      if (units_Selection == "" || units_Selection == null) {
        _showDialog("يرجى اختيار وحدة قياس.");
        setState(() {
          signup_btn_child_index = 0;
        });
        return;
      }

      //check price
      if (price_Controller.text == "" || price_Controller.text == null) {
        _showDialog("يرجى إدخال سعر العقار.");
        setState(() {
          signup_btn_child_index = 0;
        });
        return;
      }

      //check currancy
      if (Currancies_Selection == "" || Currancies_Selection == null) {
        _showDialog("يرجى اختيار العملة.");
        setState(() {
          signup_btn_child_index = 0;
        });
        return;
      }

      //check payment
      if (payment_method == "" || payment_method == null) {
        _showDialog("يرجى اختيار طريقة الدفع.");
        setState(() {
          signup_btn_child_index = 0;
        });
        return;
      }

      //check contact information
      if (phone_Controller.text == "" || phone_Controller.text == null) {
        _showDialog("يرجى إدخال رقم التواصل.");
        setState(() {
          signup_btn_child_index = 0;
        });
        return;
      }

      //check contact method
      if (phone == false &&
          whatsapp == false &&
          telegram == false &&
          viber == false) {
        _showDialog("يرجى اختيار طريقة تواصل واحدة على الأقل.");
        setState(() {
          signup_btn_child_index = 0;
        });
        return;
      }

      /////////end form valdation/////////

      ////////get user parameter///////
      final prefs = await SharedPreferences.getInstance();
      final key = 'token';
      final token = prefs.get(key) ?? 0;

      ////////// send data to api
      Map<String, String> postBody = new Map<String, String>();

      postBody.putIfAbsent('token', () => token.toString());
      postBody.putIfAbsent('id', () => widget.postId.toString());
      postBody.putIfAbsent(
          'title', () => '${title_Controller.text.toString()}');
      postBody.putIfAbsent(
          'description', () => '${details_Controller.text.toString()}');
      postBody.putIfAbsent(
          'price', () => '${price_Controller.text.toString()}');
      postBody.putIfAbsent('currancy_id', () => '${Currancies_Selection}');
      postBody.putIfAbsent('area', () => '${area_Controller.text.toString()}');
      postBody.putIfAbsent('rooms', () => '');
      postBody.putIfAbsent('bedroom', () => '${beed_Selection}');
      postBody.putIfAbsent('bathroom', () => '${bath_Selection}');
      postBody.putIfAbsent('payment', () => '${payment_method}');
      postBody.putIfAbsent('furniture', () => '');
      postBody.putIfAbsent('carage', () => '${car_Selection}');
      postBody.putIfAbsent(
          'num_car', () => '${car_num_Controller.text.toString()}');
      postBody.putIfAbsent(
          'floor', () => '${floor_Controller.text.toString()}');
      postBody.putIfAbsent('age', () => '');
      postBody.putIfAbsent(
          'num_floor', () => '${floor_num_Controller.text.toString()}');
      postBody.putIfAbsent('name', () => '');
      postBody.putIfAbsent(
          'phone', () => '${phone_Controller.text.toString()}');
      postBody.putIfAbsent('category_id', () => '${cat_Selection}');
      postBody.putIfAbsent('subcat_id', () => '${sub_cat_Selection}');
      postBody.putIfAbsent('unit_id', () => '${units_Selection}');
      postBody.putIfAbsent('city_id', () => '${city_Selection}');
      postBody.putIfAbsent('region_id', () => '${region_Selection}');
      postBody.putIfAbsent('level', () => '0');
      postBody.putIfAbsent('type', () => 'سكني');
      postBody.putIfAbsent('img', () => '');
      postBody.putIfAbsent('call', () => '${phone.toString()}');
      postBody.putIfAbsent('whatsapp', () => '${whatsapp.toString()}');
      postBody.putIfAbsent('telegram', () => '${telegram.toString()}');
      postBody.putIfAbsent('viber', () => '${viber.toString()}');

      Uri uri = Uri.parse('https://iraqibayt.com/api/update_post_api');
      http.MultipartRequest request = http.MultipartRequest("POST", uri);

      int files_counter = 0;
      for (var i = 0; i < images_files.length; i++) {
        var path = images_files[i].path;

        request.files.add(await http.MultipartFile.fromPath('imgs_file$files_counter', path,
            contentType: new MediaType('application', 'x-tar')));
        files_counter++;
        //final file = File(path);
      };

      for (var i = 0; i < images.length; i++) {
        var path =
        await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);

        request.files.add(await http.MultipartFile.fromPath('imgs_file$files_counter', path,
            contentType: new MediaType('application', 'x-tar')));
        files_counter++;
        //final file = File(path);
      };
      request.fields.addAll(postBody);

      print("start send");
      http.Response response2 =
          await http.Response.fromStream(await request.send());

      var res = json.decode(response2.body);
      print(res);

      if (res["success"] == true) {
        Navigator.pushReplacementNamed(context, '/my_posts');
      } else {
        _showDialog("حدث خطأ! يرجى المحاولة لاحقاً.");
      }
      print("Result: ${response2.statusCode}");
      print("Result: ${response2.body}");

      setState(() {
        signup_btn_child_index = 0;
      });
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
        });
  }
}
