import 'package:flutter/material.dart';

searchBar(){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black)
      ),child: Row(
      children: [
        IconButton(onPressed: (){}, icon: Icon(Icons.location_on,)),
        TextField(
          decoration: InputDecoration(
            labelText: 'search'
          ),
        ),
        IconButton(onPressed: (){}, icon: Icon(Icons.search))
      ],
    ),
    ),
  );
}