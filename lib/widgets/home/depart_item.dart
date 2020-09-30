import 'package:flutter/material.dart';

class DepartItem extends StatelessWidget {
  final int id;
  final String name;
  DepartItem(this.id, this.name);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(5),
      onTap: () => { if(this.id == 1){
        Navigator.pushReplacementNamed(context, '/posts')
  }
      },
      child: Container(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.7),
                Colors.cyanAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(5.0),
          )),
    );
  }
}
