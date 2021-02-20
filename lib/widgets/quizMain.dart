import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iraqibayt/modules/Answer.dart';
import 'package:iraqibayt/modules/Question.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:iraqibayt/widgets/firebase_agent.dart';
import 'package:iraqibayt/widgets/home/home.dart';
import 'dart:convert';

import 'package:iraqibayt/widgets/quizs.dart';

class QuizMain extends StatefulWidget {
  final int id;
  final String title;
  QuizMain({Key key, this.id, this.title}) : super(key: key);

  @override
  _QuizMainState createState() => _QuizMainState();
}

class _QuizMainState extends State<QuizMain> {
  List<Question> _questions, _rQuestions = [];
  List<Answer> _choices, _rChoices = [];

  int timer, correctChoices, totalQuestionsCount, wrongId;
  String question, controlLabel;
  double score;

  bool isLoadingChoices = false;
  bool isStart = true;
  bool isGameOver = false;
  bool showCorrect, lockChoices, lockControl, stopTimer;
  int qIndex;

  Timer QTimer;

  Future _getQuestions() async {
    var qsResponse = await http
        .get('https://iraqibayt.com/quizz/' + widget.id.toString() + '/asks');
    var qsData = json.decode(qsResponse.body);
    Question tQues;
    _questions = [];

    for (var ques in qsData['asks15']) {
      tQues = Question.fromJson(ques);
      print(tQues.id);

      _questions.add(tQues);
      //print('depart length is : ' + departs.length.toString());
    }

    return _questions;
  }

  Future _getQuesChoices(int qId) async {
    var csResponse = await http.get(
        'https://iraqibayt.com/api/answers/' + qId.toString() + '/getanswers');
    var csData = json.decode(csResponse.body);
    Answer tAnswer;
    _choices = [];

    for (var choice in csData) {
      tAnswer = Answer.fromJson(choice);
      print(tAnswer.answer);

      _choices.add(tAnswer);
      //print('depart length is : ' + departs.length.toString());
    }

    return _choices;
  }

  void _startQuestionTimer(int qTime) {
    const oneSec = const Duration(seconds: 1);
    QTimer = new Timer.periodic(
      oneSec,
      (Timer BTimer) => setState(
        () {
          if (stopTimer)
            BTimer.cancel();
          else if (qTime < 1) {
            if (qIndex == totalQuestionsCount - 1) _showResultDialog();
            setState(() {
              lockChoices = true;
              showCorrect = true;
              lockControl = false;
            });
            BTimer.cancel();
          } else {
            setState(() {
              qTime--;
              timer = qTime;
            });
          }
        },
      ),
    );
  }

  void _resetGame() {
    setState(() {
      qIndex = 0;
      _rQuestions = [];
      _rChoices = [];
      totalQuestionsCount = 0;
      correctChoices = 0;
      timer = 0;
      question = 'السؤال';
      score = 0.0;
      controlLabel = 'ابدأ المسابقة';
      wrongId = 0;
      showCorrect = false;
      lockChoices = false;
      lockControl = false;
      stopTimer = false;
    });
  }

  void _fireGame() {
    if (!lockControl) {
      if (controlLabel == 'ابدأ المسابقة') {
        _getQuestions().then((value) {
          setState(() {
            lockControl = true;
            _rQuestions = List.from(value);

            totalQuestionsCount = _rQuestions.length;
            timer = _rQuestions[qIndex].time;
            question = _rQuestions[qIndex].ask;

            lockChoices = true;
            _getQuesChoices(_rQuestions[qIndex].id).then((value) {
              setState(() {
                _rChoices = List.from(value);
                lockChoices = false;
                _startQuestionTimer(timer);
              });
            });
            controlLabel = 'السؤال التالي';
          });
        });
      } else if (controlLabel == 'السؤال التالي') {
        if (qIndex < totalQuestionsCount - 1) {
          setState(() {
            lockControl = true;
            qIndex++;
            showCorrect = false;
            lockChoices = false;
            stopTimer = false;
            timer = _rQuestions[qIndex].time;
            question = _rQuestions[qIndex].ask;
            lockChoices = true;
            _getQuesChoices(_rQuestions[qIndex].id).then((value) {
              setState(() {
                _rChoices = List.from(value);
                lockChoices = false;
                _startQuestionTimer(timer);
              });
            });
          });
        } else {}
      }
    }
  }

  void _checkAnswer(Answer userInput) {
    if (!lockChoices) {
      setState(() {
        lockChoices = true;
        showCorrect = true;
        stopTimer = true;
        lockControl = false;
      });
      if (userInput.right == 1) {
        setState(() {
          correctChoices++;
          score = (correctChoices.toDouble() / totalQuestionsCount.toDouble()) *
              100;
        });
      } else {
        setState(() {
          wrongId = userInput.id;
        });
      }
      if (qIndex == totalQuestionsCount - 1) {
        //if (timer > 0) QTimer.cancel();
        _showResultDialog();
      }
    }
  }

  void _showResultDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              elevation: 16,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.315,
                width: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: Text(
                          'النتيجة',
                          style: TextStyle(
                            fontFamily: 'CustomIcons',
                            fontSize: 30.0,
                            color: Color(0xff275879),
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
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          score.toStringAsFixed(2) + '%',
                          style: TextStyle(
                              fontFamily: 'CustomIcons', fontSize: 30.0),
                        ),
                      ),
                    ),
                    Container(
                      //padding: const EdgeInsets.all(10.0),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color(0xff275879), width: 0.5),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                color: Color(0xff275879),
                                //padding: EdgeInsets.all(8.0),
                                splashColor: Colors.blue,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  _resetGame();
                                },
                                child: Text(
                                  'أعد المحاولة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: "CustomIcons",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: GFButton(
                                  shape: GFButtonShape.pills,
                                  color: GFColors.LIGHT,
                                  //blockButton: true,
                                  child: Center(
                                    child: Text(
                                      'المسابقات',
                                      style: TextStyle(
                                          fontFamily: 'CustomIcons',
                                          fontSize: 20.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Quizs()),
                                      (Route<dynamic> route) => false,
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  @override
  void dispose() {
    QTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            widget.title,
            style: TextStyle(
              fontFamily: "CustomIcons",
            ),
          ),
        ),
        backgroundColor: Color(0xff275879),
        actions: [
          FirebaseAgent(),
        ],
      ),
      body: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: () {},
        child: Card(
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
                child: Column(
                  children: <Widget>[
                    GFProgressBar(
                      percentage: _rQuestions.length == 0
                          ? 0
                          : ((timer).toDouble() /
                              _rQuestions[qIndex].time.toDouble()),
                      radius: 10,
                      backgroundColor: Colors.white,
                      progressBarColor: Colors.lightBlueAccent,
                      animateFromLastPercentage: true,
                      animation: true,
                    ),
                    Container(
                      padding: const EdgeInsets.all(7.0),
                      //color: Color(0xffEBEBEB),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'السؤال ' +
                                  (qIndex == null ? 0 : qIndex + 1).toString() +
                                  '/' +
                                  totalQuestionsCount.toString(),
                              style: TextStyle(fontFamily: 'CustomIcons'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.cyan,
                                foregroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    timer.toString(),
                                    style: TextStyle(
                                        fontFamily: 'digital_counter_7',
                                        fontSize: 30),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'النتيجة : ' + score.toStringAsFixed(2) + '%',
                              style: TextStyle(fontFamily: 'CustomIcons'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      height: MediaQuery.of(context).size.height * 0.34,
                      child: Center(
                        child: Text(
                          question,
                          style: TextStyle(
                              fontFamily: 'CustomIcons', fontSize: 25.0),
                        ),
                      ),
                    ),
                    Container(
                      child: _rChoices.length == 0
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.32,
                              //color: Colors.deepOrangeAccent,
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemExtent:
                                  MediaQuery.of(context).size.height * 0.08,
                              itemCount: _rChoices.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: FlatButton(
                                    color: showCorrect &&
                                            _rChoices[index].right == 1
                                        ? Color(0xff5BB75B)
                                        : showCorrect &&
                                                _rChoices[index].id == wrongId
                                            ? Color(0xffED5F59)
                                            : Color(0xffdBdBdB),
                                    textColor: Colors.black,
                                    disabledColor: Colors.grey,
                                    disabledTextColor: Colors.blue,
                                    padding: EdgeInsets.all(8.0),
                                    splashColor: Colors.blue,
                                    onPressed: _rQuestions.length > 0
                                        ? () {
                                            _checkAnswer(_rChoices[index]);
                                          }
                                        : null,
                                    child: Text(
                                      _rChoices[index].answer,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                        fontFamily: "CustomIcons",
                                      ),
                                    ),
                                  ),
                                );
                              }),
                    ),
                    Container(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: Color(0xff275879), width: 0.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Color(0xff275879),
                        textColor: Colors.black,
                        disabledColor: Colors.blue,
                        disabledTextColor: Colors.blue,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blue,
                        onPressed: _fireGame,
                        child: Text(
                          controlLabel,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: "CustomIcons",
                          ),
                        ),
                      ),
                    ),
                    Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
