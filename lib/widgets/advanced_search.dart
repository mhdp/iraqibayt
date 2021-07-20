import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/Category.dart';
import 'package:iraqibayt/modules/City.dart';
import 'package:iraqibayt/modules/Favorite.dart';
import 'package:iraqibayt/modules/RCity.dart';
import 'package:iraqibayt/modules/Region.dart';
import 'package:iraqibayt/modules/SubCategory.dart';
import 'package:iraqibayt/modules/api/callApi.dart';
import 'package:iraqibayt/modules/db_helper.dart';
import 'package:iraqibayt/widgets/adv_search_card.dart';
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/my_icons_icons.dart';
import 'package:iraqibayt/widgets/posts/add_post.dart';
import 'package:iraqibayt/widgets/posts/full_post.dart';
import 'package:iraqibayt/widgets/posts/post_details.dart';
import 'package:iraqibayt/widgets/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

DatabaseHelper databaseHelper = new DatabaseHelper();

String default_image = "";
bool _isVisible, _isExtraLoadingVisible, _isEndResultsVisible;

class AdvancedSearch extends StatefulWidget {
  final int categoryId;
  final List<int> subCategories;
  final int cityId;
  final List<int> regions;
  final int sortBy;
  final String catHint;
  final String cityHint;

  AdvancedSearch(
      {this.categoryId,
      this.subCategories,
      this.cityId,
      this.regions,
      this.sortBy,
      this.cityHint,
      this.catHint
      });

  @override
  _AdvancedSearchState createState() => _AdvancedSearchState();
}

class _AdvancedSearchState extends State<AdvancedSearch> {
  var is_loading = true;

  void initState() {
    super.initState();
    setState(() {
      _isVisible = false;
      _isExtraLoadingVisible = false;
      _isEndResultsVisible = false;
    });

    databaseHelper.get_default_post_image().whenComplete(() {
      setState(() {
        default_image = databaseHelper.default_post_image;
      });
    });

    databaseHelper
        .getAdvSearchResults(widget.categoryId, widget.subCategories,
            widget.cityId, widget.regions, widget.sortBy)
        .whenComplete(() {
      setState(() {
        is_loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight =
        MediaQuery.of(context).size.height - statusBarHeight - kToolbarHeight;
    return Scaffold(
      backgroundColor: Color(0xFFe8e8e8),
      appBar: AppBar(
        backgroundColor: Color(0xFF335876),
        title: Text(
          "العقارات",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            fontFamily: "CustomIcons",
          ),
        ),
        actions: [
          FirebaseAgent(),
          IconButton(
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            color: Colors.white,
            //elevation: 0,
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
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
      body: Container(
        height: screenHeight,
        child: is_loading
            ? new Center(
                child: new GFLoader(type: GFLoaderType.circle),
              )
            : ResultListItem(
                catId: widget.categoryId,
                subCats: widget.subCategories,
                citId: widget.cityId,
                regions: widget.regions,
                catHint: widget.catHint,
                cityHint: widget.cityHint,
                list1: databaseHelper.posts_list,
              ),
      ),
    );
  }
}

class ResultListItem extends StatefulWidget {
  Map<String, dynamic> list1;
  int catId, citId, sortById;
  List<int> subCats, regions;
  String catHint,cityHint;


  ResultListItem(
      {this.catId,
      this.subCats,
      this.citId,
      this.regions,
      this.sortById,
      this.list1,
      this.catHint,
      this.cityHint
      });

  @override
  _ResultListItemState createState() => _ResultListItemState();
}

class _ResultListItemState extends State<ResultListItem> {
  String _email, _password;
  List<Favorite> _favorites, _rFavorites;
  int _pageIndex;
  List<dynamic> data;

  var _controller = ScrollController();

  List<RCity> _cities, _rCities;
  List<Region> _regions;
  List<Category> _categories, _rCategories;
  List<SubCategory> _subCategories;

  int catValue;
  String catHint;
  int cityValue;
  String cityHint;

  int selectedRCounter, selectedSCounter;
  bool _isAllRSelected, _isAllSSelected, _subsFirstTime, _regionsFirstTime;

  List<int> _subsIds, _regionsIds;

  var is_loading = true;

  Future _getUserFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    //print('$value');
    if (value == '1') {
      final key2 = 'email';
      final key3 = 'pass';
      final value2 = prefs.get(key2);
      //print(value2);
      final value3 = prefs.get(key3);
      //print(value3);

      setState(() {
        _email = value2;
        _password = value3;
      });
    }

    var data = {
      'email': _email,
      'password': _password,
    };

    Favorite tFav;
    _favorites = [];

    var res = await CallApi().postData(data, '/users/favorit');
    var body = json.decode(res.body);
    //print(body);

    if (body['success'] == true && body['favorites'] != null) {
      for (var fav in body['favorites']) {
        tFav = Favorite.fromJson(fav);
        _favorites.add(tFav);
        //_favsIds.add(tFav.postId);
      }

      return _favorites;
    }
  }

  int _checkIfInFavs(int pid, List<Favorite> favsPosts) {
    try {
      for (Favorite fav in favsPosts) if (pid == fav.postId) return fav.id;
    } catch (e) {
      return null;
    }
  }

  _addFavorite(int pid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    //print('$value');
    if (value == '1') {
      final key2 = 'email';
      final key3 = 'pass';
      final value2 = prefs.get(key2);
      //print(value2);
      final value3 = prefs.get(key3);
      //print(value3);

      setState(() {
        _email = value2;
        _password = value3;
      });

      var data = {
        'id': pid,
        'email': _email,
        'password': _password,
      };

      var res = await CallApi().postData(data, '/favorites/add');
      var body = json.decode(res.body);
      //print(body);

      _getUserFavorites().then((value) {
        setState(() {
          _rFavorites = List.from(value);
        });
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                elevation: 16,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.38,
                  width: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    children: [
                      Container(
                        child: Center(
                          child: Text(
                            'تنبيه',
                            style: TextStyle(
                              fontFamily: 'CustomIcons',
                              fontSize: 30.0,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Divider(
                          thickness: 1.0,
                          color: Colors.black54,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: Text(
                            'يجب عليك تسجيل الدخول أولاً لكي تتمكن من المتابعة',
                            style: TextStyle(
                                fontFamily: 'CustomIcons', fontSize: 20.0),
                          ),
                        ),
                      ),
                      Container(
                        //padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: GFButton(
                              color: GFColors.LIGHT,
                              //blockButton: true,
                              child: Center(
                                child: Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                      fontFamily: 'CustomIcons',
                                      fontSize: 20.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Welcome()),
                                  (Route<dynamic> route) => false,
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ));
          });
    }
  }

  _deleteFavorite(int fid) async {
    var data = {
      'id': fid,
      'email': _email,
      'password': _password,
    };

    var res = await CallApi().postData(data, '/favorites/delete');
    var body = json.decode(res.body);
    //print(body);

    if (body['success'] == true) {
      _getUserFavorites().then((value) {
        setState(() {
          _rFavorites = List.from(value);
        });
      });
    }
  }

  void _listener() {
    if (_controller.position.atEdge) {
      if (_controller.position.pixels == 0)
        setState(() {
          _isExtraLoadingVisible = false;
          _isEndResultsVisible = false;
        });
      else {
        setState(() {
          _isExtraLoadingVisible = true;
        });

        if (_pageIndex <= databaseHelper.maxPagesNumber) {
          _pageIndex++;
          databaseHelper
              .getSearchNextPage(_pageIndex, widget.catId, widget.subCats,
                  widget.citId, widget.regions, widget.sortById)
              .whenComplete(() {
            setState(() {
              for (var item in databaseHelper.extraPostList['data']) {
                data.add(item);
              }
              _isExtraLoadingVisible = false;
            });
          });
        } else {
          setState(() {
            _isExtraLoadingVisible = false;
            _isEndResultsVisible = true;
          });
        }
      }
    } else
      setState(() {
        _isExtraLoadingVisible = false;
        _isEndResultsVisible = false;
      });
  }

  void up_widget(){
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

    getCachedData();

    _controller.addListener(_listener);

    _getUserFavorites().then((value) {
      setState(() {
        _rFavorites = List.from(value);
      });
    });

    setState(() {
      _pageIndex = 1;
    });

    catHint = widget.catHint;
    cityHint = widget.cityHint;

    print("catHint: "+widget.catId.toString());
    print("cityHint: "+widget.citId.toString());
    _isAllRSelected = true;
    _isAllSSelected = true;
    _subsFirstTime = true;
    _regionsFirstTime = true;
    selectedRCounter = 0;
    selectedSCounter = 0;

    catValue = 1;
    _getBaghdadId().then((value) {
      setState(() {
        cityValue = value;
      });
    });


    _subsIds = new List<int>();

    _regionsIds = new List<int>();

    _getData();
  }

  getCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'cities';
    final is_cities = prefs.get(key) ?? 0;

    final key2 = 'categories';
    final is_categories = prefs.get(key2) ?? 0;

    /*print ("is_cities:"+is_cities.toString());
    print ("is_categories:"+is_categories.toString());*/

    if (is_cities != 0 && is_categories != 0) {
      var citiesData = json.decode(is_cities);
      //print ("get saved categories data");
      for (var record in citiesData) {
        _cities = [];
        RCity tCity;
        tCity = RCity.fromJson(record);
        //print(tCity.name + '->');
        //print(tCity.regions);
        _cities.add(tCity);
      }

      var categoriesData = json.decode(is_categories);
      _categories = [];
      Category tCategory;

      for (var record in categoriesData) {
        tCategory = Category.fromJson(record);
        //print(tCategory.name);
        _categories.add(tCategory);
      }

      setState(() {
        is_loading = false;
      });
    }
  }

  _getData() async {
    setState(() {
      is_loading = true;
    });
    //Fetching Cities Data
    var citiesResponse = await http.get(Uri.parse('https://iraqibayt.com/getCities'));
    var citiesData = json.decode(citiesResponse.body);

    final prefs = await SharedPreferences.getInstance();
    final key = 'cities';

    prefs.setString(key, citiesResponse.body);
    //print ("save cities data");
    _cities = [];
    RCity tCity;

    for (var record in citiesData) {
      tCity = RCity.fromJson(record);
      //print(tCity.name + '->');
      //print(tCity.regions);
      _cities.add(tCity);
    }

    //Fetching Categories Data
    var categoriesResponse =
    await http.get(Uri.parse('https://iraqibayt.com/getCategories'));
    var categoriesData = json.decode(categoriesResponse.body);
    final key2 = 'categories';

    prefs.setString(key2, categoriesResponse.body);
    //print ("save categories data");

    _categories = [];
    Category tCategory;

    for (var record in categoriesData) {
      tCategory = Category.fromJson(record);
      //print(tCategory.name);
      _categories.add(tCategory);
    }

    setState(() {
      is_loading = false;
    });
  }

  List<SubCategory> _getSubCats(int cat_id, List<Category> catList) {
    for (Category cat in catList) if (cat.id == cat_id) return cat.subCatList;
  }

  List<Region> _getRegions(int cit_id, List<RCity> citList) {
    for (RCity cit in citList) if (cit.id == cit_id) return cit.regions;
  }

  void _showCitiesDialog(context, List<RCity> cities) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                height: cities.length <= 4
                    ? MediaQuery.of(context).size.height * 0.1 * cities.length
                    : MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'اختر المدينة',
                          style: TextStyle(
                            fontFamily: 'CustomIcons',
                            fontSize: 20.0,
                            color: Color(0xff275879),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cities.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                cities[index].name,
                                style: TextStyle(fontFamily: 'CustomIcons'),
                              ),
                              onTap: () {
                                setState(() {
                                  cityValue = cities[index].id;

                                  _regions = List.from(
                                      _getRegions(cityValue, _rCities));
                                  //print(cityValue);

                                  _regionsFirstTime = true;
                                  _isAllRSelected = true;
                                });

                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                setState(() {
                                  cityHint = cities[index].name;
                                });
                                up_widget();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  void _showCategoriesDialog(context, List<Category> categories) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'اختر القسم الرئيسي',
                          style: TextStyle(
                            fontFamily: 'CustomIcons',
                            fontSize: 20.0,
                            color: Color(0xff275879),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                categories[index].name,
                                style: TextStyle(fontFamily: 'CustomIcons'),
                              ),
                              onTap: () {
                                setState(() {
                                  catValue = categories[index].id;

                                  _subCategories = List.from(
                                      _getSubCats(catValue, _rCategories));
                                  //print(catValue);
                                  _isAllSSelected = true;
                                  _subsFirstTime = true;
                                });

                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                setState(() {
                                  catHint = categories[index].name;
                                });
                                up_widget();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  void _showSubcatsDialog(context, List<SubCategory> subs) {
    if (_subsFirstTime) {
      setState(() {
        _subsFirstTime = false;
        selectedSCounter = _subCategories.length;
      });
    }
    _updateSelectedSubCats();
    //print(_isAllSSelected);
    //print(
        //_subCategories.length.toString() + '--' + selectedSCounter.toString());

    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                height: _subCategories.length <= 4
                    ? MediaQuery.of(context).size.height *
                    0.1 *
                    _subCategories.length
                    : MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'اختر الأقسام الفرعية',
                          style: TextStyle(
                            fontFamily: 'CustomIcons',
                            fontSize: 20.0,
                            color: Color(0xff275879),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.black54,
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CheckboxListTile(
                          title: Text(
                            'تحديد الكل',
                            style: TextStyle(fontFamily: 'CustomIcons'),
                          ),
                          value: _isAllSSelected,
                          onChanged: (bool value) {
                            if (!value) {
                              for (var sub in _subCategories) {
                                setState(() {
                                  sub.checked = 0;
                                });
                              }

                              setState(() {
                                _isAllSSelected = value;
                                selectedSCounter = 0;
                              });
                            } else {
                              for (var sub in _subCategories) {
                                setState(() {
                                  sub.checked = 1;
                                });
                              }

                              setState(() {
                                _isAllSSelected = value;
                                selectedSCounter = _subCategories.length;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _subCategories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              title: Text(
                                _subCategories[index].name,
                                style: TextStyle(fontFamily: 'CustomIcons'),
                              ),
                              value: _isAllSSelected
                                  ? true
                                  : _subCategories[index].checked == 1
                                  ? true
                                  : false,
                              onChanged: (bool value) {
                                //print(value);

                                if (value) {
                                  setState(() {
                                    _subCategories[index].checked = 1;
                                    selectedSCounter++;
                                  });
                                  _updateSelectedSubCats();
                                } else {
                                  setState(() {
                                    _subCategories[index].checked = 0;
                                    selectedSCounter--;
                                  });
                                  _updateSelectedSubCats();
                                }

                                /*print(_subCategories.length.toString() +
                                    '--' +
                                    selectedSCounter.toString());*/
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  void _showRegionsDialog(context, List<Region> regions) {
    if (_regionsFirstTime) {
      setState(() {
        _regionsFirstTime = false;
        selectedRCounter = _regions.length;
      });
    }
    _updateSelectedRegions();
    /*print(_isAllRSelected);
    print(_regions.length.toString() + '--' + selectedRCounter.toString());*/

    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                height: _regions.length <= 4
                    ? MediaQuery.of(context).size.height * 0.1 * _regions.length
                    : MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'اختر المناطق',
                          style: TextStyle(
                            fontFamily: 'CustomIcons',
                            fontSize: 20.0,
                            color: Color(0xff275879),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.black54,
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CheckboxListTile(
                          title: Text(
                            'تحديد الكل',
                            style: TextStyle(fontFamily: 'CustomIcons'),
                          ),
                          value: _isAllRSelected,
                          onChanged: (bool value) {
                            if (!value) {
                              for (var region in _regions) {
                                setState(() {
                                  region.checked = 0;
                                });
                              }

                              setState(() {
                                _isAllRSelected = value;
                                selectedRCounter = 0;
                              });
                            } else {
                              for (var region in _regions) {
                                setState(() {
                                  region.checked = 1;
                                });
                              }

                              setState(() {
                                _isAllRSelected = value;
                                selectedRCounter = _regions.length;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _regions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              title: Text(
                                _regions[index].name,
                                style: TextStyle(fontFamily: 'CustomIcons'),
                              ),
                              value: _isAllRSelected
                                  ? true
                                  : _regions[index].checked == 1
                                  ? true
                                  : false,
                              onChanged: (bool value) {
                                //print(value);

                                if (value) {
                                  setState(() {
                                    _regions[index].checked = 1;
                                    selectedRCounter++;
                                  });
                                  _updateSelectedRegions();
                                } else {
                                  setState(() {
                                    _regions[index].checked = 0;
                                    selectedRCounter--;
                                  });
                                  _updateSelectedRegions();
                                }

                                /*print(_regions.length.toString() +
                                    '--' +
                                    selectedRCounter.toString());*/
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  Future _getBaghdadId() async {
    var response =
    await http.get(Uri.parse('https://iraqibayt.com/api/cities/Baghdad/get_id'));
    var data = json.decode(response.body);

    City baghdad;
    for (var record in data) baghdad = City.fromJson(record);

    return baghdad.id;
  }

  void _updateSelectedRegions() {
    if (_regions.length == selectedRCounter)
      setState(() {
        _isAllRSelected = true;
      });
    else
      setState(() {
        _isAllRSelected = false;
      });
  }

  void _updateSelectedSubCats() {
    if (_subCategories.length == selectedSCounter)
      setState(() {
        _isAllSSelected = true;
      });
    else
      setState(() {
        _isAllSSelected = false;
      });
  }

  searchCard(){
    if(is_loading == false)
    {
      _rCategories = _categories;
      _rCities = _cities;

      _subCategories =
          _getSubCats(catValue, _categories);

      _regions =
          _getRegions(cityValue, _cities);
    }

    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(0),
            onTap: () {},
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(0),
              ),
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.only(top: 10.0, bottom: 10),
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
                        'محرك بحث العقارات',
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
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              child:
//
                              is_loading?
                              Container(
                                height: 50,
                                child: Center(
                                  child:
                                  new CircularProgressIndicator(),
                                ),
                              )
                                  : Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 50,
                                          child: FlatButton(
                                            shape:
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    0),
                                                side: BorderSide(
                                                    color: Colors
                                                        .black)),
                                            onPressed: () {
                                              _showCategoriesDialog(
                                                  context,
                                                  _rCategories);
                                              setState(() {});
                                            },
                                            child: FittedBox(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: <Widget>[
                                                  Text(
                                                    catHint,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors
                                                          .black,
                                                      fontFamily:
                                                      "CustomIcons",
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_drop_down,
                                                    color:
                                                    Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
//
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 50,
                                          child: FlatButton(
                                            shape:
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    0),
                                                side: BorderSide(
                                                    color: Colors
                                                        .black)),
                                            onPressed: () {
                                              _showSubcatsDialog(
                                                  context,
                                                  _subCategories);
                                            },
                                            child: FittedBox(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: <Widget>[
                                                  Text(
                                                    'اختر الأقسام الفرعية',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors
                                                          .black,
                                                      fontFamily:
                                                      "CustomIcons",
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_drop_down,
                                                    color:
                                                    Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
//                                                    child: DropdownButton<int>(
//                                                      elevation: 5,
//                                                      hint: Container(
//                                                        alignment: Alignment
//                                                            .centerRight,
//                                                        child: Text(
//                                                          cityHint,
//                                                          style: TextStyle(
//                                                            fontSize: 18,
//                                                            fontFamily:
//                                                                'CustomIcons',
//                                                          ),
//                                                        ),
//                                                      ),
//                                                      value: cityValue,
//                                                      items: _rCities
//                                                          .map((RCity city) {
//                                                        return new DropdownMenuItem<
//                                                            int>(
//                                                          value: city.id,
//                                                          child: Container(
//                                                            alignment: Alignment
//                                                                .centerRight,
//                                                            child: new Text(
//                                                              city.name,
//                                                              textAlign:
//                                                                  TextAlign
//                                                                      .right,
//                                                              style: TextStyle(
//                                                                fontFamily:
//                                                                    "CustomIcons",
//                                                              ),
//                                                            ),
//                                                          ),
//                                                        );
//                                                      }).toList(),
//                                                      onChanged: (int cityId) {
//                                                        setState(() {
//                                                          cityValue = cityId;
//
//                                                          _regions = List.from(
//                                                              _getRegions(
//                                                                  cityValue,
//                                                                  _rCities));
//                                                          //regionValue = _regions[0].id;
//                                                          print(cityValue);
//                                                        });
//                                                      },
//                                                    ),
                                          child: FlatButton(
                                            shape:
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    0),
                                                side: BorderSide(
                                                    color: Colors
                                                        .black)),
                                            color: Colors.white,
                                            textColor: Colors.black,
                                            splashColor:
                                            Colors.orange,
                                            onPressed: () {
                                              _showCitiesDialog(
                                                  context, _rCities);
                                              setState(() {});
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Text(
                                                  cityHint,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                    Colors.black,
                                                    fontFamily:
                                                    "CustomIcons",
                                                  ),
                                                ),
                                                Icon(
                                                  Icons
                                                      .arrow_drop_down,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 5,
                                            child: FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      0),
                                                  side: BorderSide(
                                                      color: Colors
                                                          .black)),
                                              onPressed: () {
                                                _showRegionsDialog(
                                                    context,
                                                    _regions);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: <Widget>[
                                                  Text(
                                                    'اختر المناطق',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors
                                                          .black,
                                                      fontFamily:
                                                      "CustomIcons",
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_drop_down,
                                                    color:
                                                    Colors.black,
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        _subsIds.clear();
                                        _regionsIds.clear();

                                        //print('cat:' +catValue.toString());
                                        _subCategories
                                            .forEach((element) {
                                          if (element.checked == 1)
                                            _subsIds.add(element.id);
                                          //print('scat:' +element.toString());
                                        });
                                        //print('cit:' + cityValue.toString());
                                        _regions.forEach((element) {
                                          if (element.checked == 1)
                                            _regionsIds
                                                .add(element.id);
                                          //print('reg:' +element.toString());
                                        });

                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                            builder: (BuildContext
                                            context) =>
                                            new AdvancedSearch(
                                              categoryId: catValue,
                                              subCategories: _subsIds,
                                              cityId: cityValue,
                                              catHint: catHint,
                                              cityHint: cityHint,
                                              regions: _regionsIds,
                                              sortBy: 1,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'بحث',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontFamily:
                                              "CustomIcons",
                                            ),
                                          ),
                                          Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      //blockButton: true,
                                      color: Color(0xff65AECA),
                                    ),
                                  )
                                ],
                              )


                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list1.length > 0) {
      data = widget.list1["data"];

      return SingleChildScrollView(
        child: Column(
          //scrollDirection: Axis.vertical,
          children: <Widget>[
            searchCard(),
            Container(
              height: MediaQuery.of(context).size.height * 0.04,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'عدد النتائج :' + widget.list1['total'].toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF335876),
                    fontFamily: "CustomIcons",
                  ),
                ),
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              controller: _controller,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, i) {
                //print("i:"+i.toString());
                var show_icons = true;

                var img = data[i]['img'].toString();
                //print("img: $img");
                if (img == "" || img == null) {
                  img = default_image;
                  //print("img: $img");
                }

                var bath = data[i]['bathroom'];
                if (bath == null || bath == 'null') {
                  show_icons = false;
                  bath = "0";
                }

                var bed = data[i]['bedroom'];
                if (bed == null || bed == 'null') {
                  show_icons = false;
                  bed = "0";
                }

                var car_num = data[i]['num_car'];
                if (car_num == null || car_num == 'null') {
                  car_num = "0";
                }

                return new Container(
                  padding: const EdgeInsets.all(0),
                  child: new GestureDetector(
                    onTap: () {},
                    child: InkWell(
                      borderRadius: BorderRadius.circular(0),
                      onTap: () {
                        Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                              new FullPost(
                                post_id: data[i]['id'].toString(),
                              )),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        elevation: 0,
                        margin: const EdgeInsets.only(top: 10.0),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Stack(
                                fit: StackFit.passthrough,
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: img == 'null'
                                          ? Image.asset(
                                        'assets/images/posts/default_post_img.jpeg',
                                        fit: BoxFit.fill,
                                        height: MediaQuery.of(context)
                                            .size
                                            .width /
                                            1.5,
                                      )
                                          : Image.network(
                                        "https://iraqibayt.com/storage/app/public/posts/$img",
                                        fit: BoxFit.cover,
                                        height: MediaQuery.of(context)
                                            .size
                                            .width /
                                            1.5,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                          const EdgeInsets.all(3.0),
                                          margin: const EdgeInsets.only(
                                              top: 50.0),
                                          constraints: BoxConstraints(),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            border: Border.all(
                                              color: Colors.redAccent,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topRight:
                                              Radius.circular(10.0),
                                              bottomRight:
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          child: Text(
                                            "${data[i]['category']['name']}",
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
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                          const EdgeInsets.all(3.0),
                                          margin: const EdgeInsets.only(
                                              top: 90.0),
                                          constraints: BoxConstraints(),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            border: Border.all(
                                              color: Colors.redAccent,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topRight:
                                              Radius.circular(10.0),
                                              bottomRight:
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          child: Text(
                                            "${data[i]['price']} ${data[i]['currancy']['name']}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontFamily: "CustomIcons",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
//
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data[i]['title'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF335876),
                                  fontFamily: "CustomIcons",
                                ),
                                softWrap: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                              ),
                              child: Divider(
                                color: Colors.black,
                                thickness: 0.5,
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {},
                              color: Colors.white,
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.location_on,
                                      color: Color(0xff275879)),
                                  Text(
                                    "${data[i]['city']['name']} - ${data[i]['region']['name']}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: "CustomIcons",
                                      fontWeight: FontWeight.w300,
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {},
                              color: Colors.white,
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.format_line_spacing,
                                      color: Color(0xff275879)),
                                  Text(
                                    " المساحة:  ${data[i]['area']} ${data[i]['unit']['name']}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: "CustomIcons",
                                      fontWeight: FontWeight.w300,
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {},
                              color: Colors.white,
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.add_box,
                                    color: Color(0xff275879),
                                  ),
                                  Text(
                                    " أضيف: ${data[i]['created_at']}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: "CustomIcons",
                                      fontWeight: FontWeight.w300,
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                            show_icons
                                ? Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3, // 20%
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        MyIcons.car,
                                        color: Color(0xff275879),
                                      ),
                                      Text(car_num.toString()),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3, // 20%
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        MyIcons.bed,
                                        color: Color(0xff275879),
                                      ),
                                      Text(bed.toString()),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3, // 20%
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        MyIcons.bath,
                                        color: Color(0xff275879),
                                      ),
                                      Text(bath.toString()),
                                    ],
                                  ),
                                ),
                              ],
                            )
                                : Container(),
                            //Divider
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                              ),
                              child: Divider(
                                color: Colors.black,
                                thickness: 0.5,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                  color: Colors.white,
                                  margin: const EdgeInsets.only(
                                      top: 0, bottom: 0.0),
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      FlatButton(
                                        onPressed: () async {
                                          var url =
                                              "tel:+${data[i]['phone'].toString().trim()}";
                                          //print(url);
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xFF335876),
                                              width: 0,
                                              style: BorderStyle.solid),
                                        ),
                                        color: Color(0xFF335876),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.call,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              data[i]['phone'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontFamily: "CustomIcons",
                                                fontWeight: FontWeight.w300,
                                              ),
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                      _checkIfInFavs(data[i]['id'],
                                          _rFavorites) ==
                                          null
                                          ? FlatButton(
                                        onPressed: () {
                                          _addFavorite(data[i]['id']);
                                        },
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.red,
                                              width: 1,
                                              style:
                                              BorderStyle.solid),
                                        ),
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.favorite_border,
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                      )
                                          : FlatButton(
                                        onPressed: () {
                                          _deleteFavorite(
                                              _checkIfInFavs(
                                                  data[i]['id'],
                                                  _rFavorites));
                                        },
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.red,
                                              width: 1,
                                              style:
                                              BorderStyle.solid),
                                        ),
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Visibility(
              visible: _isExtraLoadingVisible,
              child: Container(
                height: 50,
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              ),
            ),
            Visibility(
              visible: _isEndResultsVisible,
              child: Container(
                height: 50,
                child: Center(
                  child: Text(
                    'نهاية النتائج',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: "CustomIcons",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          'لا يوجد إعلانات',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            fontFamily: "CustomIcons",
          ),
          softWrap: true,
        ),
      );
    }
  }
}
