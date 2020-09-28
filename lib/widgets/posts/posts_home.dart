

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';


class Posts_Home extends StatefulWidget {
  @override
  _Posts_Home createState() => _Posts_Home();
}

class _Posts_Home extends State<Posts_Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

            backgroundColor: Colors.grey,
            appBar: AppBar(

            backgroundColor: Colors.deepOrange,

            title: Text(
            "العقارات",
            style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0
            , fontFamily: "CustomIcons",),
        ),

        ),
        body :  ListView(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [

                  Padding(
                    padding: const EdgeInsets.all(0),

                    child: Image.network(
                      'https://iraqibayt.com/storage/app/public/posts/5f7180d0137d2.jpeg',
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.width/1.5,),


                  ),

                  ListTile(
                    leading: Icon(Icons.arrow_drop_down_circle),
                    title: const Text('Card title 1'),
                    subtitle: Text(
                      'Secondary Text',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),

                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      FlatButton(
                        onPressed: () {
                          // Perform some action
                        },
                        child: const Text('ACTION 1'),
                      ),
                      FlatButton(
                        onPressed: () {
                          // Perform some action
                        },
                        child: const Text('ACTION 2'),
                      ),
                    ],
                  ),



                ],
              ),
            ),

          ],
        ),
        );
      }


}