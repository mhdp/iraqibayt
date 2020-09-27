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
      onTap: () => {},
      child: Container(
          padding: const EdgeInsets.all(15),
          child: Text(
            name,
            style: Theme.of(context).textTheme.headline6,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.7),
                Colors.lightBlueAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(5),
          )),
    );
  }
}
